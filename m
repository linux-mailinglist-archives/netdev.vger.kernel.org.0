Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF426EED2
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 04:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfD3Cqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 22:46:46 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:34863 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfD3Cqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 22:46:46 -0400
Received: by mail-ed1-f48.google.com with SMTP id y67so10949590ede.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 19:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bnTneCm8QtC6lN1B3ADie7qS2JICVS+DVd+34tap9/8=;
        b=pw6hXD/Amg7Xtiv0+mUFYF7hmgRTJOFKqP+nvd/MrFQ/4a+xeyiiCVuQban189odS0
         6VyMRTNZz5tOs0evh2vkcwaG5y+O8u8QY26lMfpT6g+/lmbW4cpK/Tiln5h3L/kH4GNZ
         7e4rvugFYRtENx89MPi1HsA8obQWkLuTheEe2MQO5Y5amux6mzuSBqXEKiXZ26MA3fK+
         dxpONaBv8REgu5szytniAP5JIlyx/bt38SPfhdjRtN2oVqA82t0Hwc27OAqOVdBDPAUK
         oNpQFO4RDtA3pqwJlFQFbUI9yueowu4uzDL6MzVNgamSgtAMznDuzcfmnN/e5v0y6GKR
         3yNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bnTneCm8QtC6lN1B3ADie7qS2JICVS+DVd+34tap9/8=;
        b=m2fKJ2JpK/x2w1pj59/iWyQ8zS4xkHEtPbpQY1ZuZOMicAtEHOxCcMo6udb7AXiI1t
         vskmGygrSR/KhsRX/UJKC6K4j9cOk1JViqHoN5Z2A8eRGltD4CuyR9TDCUjX4jsfQsAk
         szpsC5jPJjQfVcmqHvS2IqjrJnJF6+mxmYzJBE04GZgWeHAolMoJd5pche7V4H3dS8Ih
         fA59hmVpKlrYI3FVTpzDNxVZcQKxQSfbKC/JQnTWhlhX/TeVW0IncMDg+WxBMClCGT86
         0rCX9/lfAJcZyImNItwkAVPAY1g1Soq9VioV2No6/IsXbTQuJ7KKBxvhXpbBHspXsIjf
         0s5Q==
X-Gm-Message-State: APjAAAXQXqKmUkAUYHQS+9/npbTdIsW92jlm8lsuT41n8H8Iiha1EdWq
        1rhybCVlSIzQPzd7GoahAijSb/TvcKM=
X-Google-Smtp-Source: APXvYqwieaO5smPnwJ+es7Xodl0rDzT2C4pP9i2t4uJqLvqR4RkANZtM4S7EuS6ftUh11OnP5eU/fQ==
X-Received: by 2002:a50:92a3:: with SMTP id k32mr14387629eda.123.1556592404572;
        Mon, 29 Apr 2019 19:46:44 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e18sm2294092ejx.82.2019.04.29.19.46.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 19:46:44 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: fib_rule_tests: print the result and return 1 if any tests failed
Date:   Tue, 30 Apr 2019 10:46:10 +0800
Message-Id: <20190430024610.26177-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index d4cfb6a7a086..d84193bdc307 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -27,6 +27,7 @@ log_test()
 		nsuccess=$((nsuccess+1))
 		printf "\n    TEST: %-50s  [ OK ]\n" "${msg}"
 	else
+		ret=1
 		nfail=$((nfail+1))
 		printf "\n    TEST: %-50s  [FAIL]\n" "${msg}"
 		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
@@ -245,4 +246,9 @@ setup
 run_fibrule_tests
 cleanup
 
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
 exit $ret
-- 
2.19.2

