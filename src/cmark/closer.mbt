///|
/// Closer indexes.
///
/// They map closing delimiters to the position where they
/// start. Shortcuts forward searches in inline parsing. See
/// `inline_struct`
#derive(Eq, Hash, Show, ToJson)
priv enum Closer {
  /// Run length of backticks.
  Backticks(Int32)
  RightBrack
  RightParen
  EmphasisMarks(Char)
  StrikethroughMarks
  MathSpanMarks(Int32)
}

///|
test {
  // Prevent warning about unused Show and ToJson
  (fn(c : Closer) { c.to_string() }) |> ignore()
  (fn(c : Closer) { c.to_json() }) |> ignore()
}

///|
type PosSet = Set[Int32]

///|
#derive(Show, ToJson)
priv struct CloserIndex(Map[Closer, PosSet])

///|
test {
  // Prevent warning about unused Show and ToJson
  (fn(c : CloserIndex) { c.to_string() }) |> ignore()
  (fn(c : CloserIndex) { c.to_json() }) |> ignore()
}

///|
fn CloserIndex::new() -> CloserIndex {
  Map::new()
}

///|
fn CloserIndex::add(self : CloserIndex, key : Closer, pos : Int32) -> Unit {
  (match self.0.get(key) {
    Some(ps) => ps
    None => {
      let ps = PosSet::new()
      self.0[key] = ps
      ps
    }
  }).add(pos)
}

///|
fn CloserIndex::pos(self : CloserIndex, key : Closer, after~ : Int32) -> Int32? {
  self.0.get(key).bind(fn(s) { s.iter().find_first(fn(pos) { pos > after }) })
}

///|
fn CloserIndex::exists(
  self : CloserIndex,
  key : Closer,
  after~ : Int32,
) -> Bool {
  not(self.pos(key, after~) is None)
}
