package nl.nn.testtool.test.webapp;

import nl.nn.testtool.Checkpoint;
import nl.nn.testtool.Report;
import nl.nn.testtool.filter.CheckpointMatcher;

public class Matcher implements CheckpointMatcher {

    public boolean match(Report report, Checkpoint checkpoint) {
        if (checkpoint.getName() != null && checkpoint.getName().equals("Hide this checkpoint")) {
            return false;
        }
        return true;
    }
}
