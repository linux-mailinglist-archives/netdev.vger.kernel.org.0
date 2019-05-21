Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9929F2483B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 08:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfEUGlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 02:41:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34997 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfEUGlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 02:41:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id t87so8536150pfa.2
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 23:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rZ86+W0ZjsVIrEO8Snz1pgVa5nGYQZAyw36iDFXbT08=;
        b=rrM7I8+m+PHuvf8Vdj9QGZXUFJDWGa6bV450Ss+ZSGb5Mm9/f1hREugDspeID2NsoG
         u0SSWlMgSOg5O0VJuFM5sfZvx2wL5tCdO8UO+He6nFdBwOk7nrO0i3XEj/+rgG76e52v
         X8Sie0kwgEFnSFxkSO3+M0JI3ai6Fi6hoIoZaBrzi3FsIJAjlo6Zimbr+R5PLtFPmV79
         wVxrAw0fiDSWE3k+0vHmVnzSGnOr0UslDHKD4SNEssKfGRJgrTa55g7e0Okxz1eMNH1o
         cgRm4xw/73wS8X6HD4VxcehjGqIm7R4DF6RswXLGgaREULtb3lmiY7fFzbSfrzVxCNnw
         lIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rZ86+W0ZjsVIrEO8Snz1pgVa5nGYQZAyw36iDFXbT08=;
        b=pQ2hbIwR6fkoyY8ajtk8XK8uj1Iz+QH1DT5JrV1mn9znCJTXlSVNL7/pN19QnIW1La
         ib1D69jNeZGf+NPFzaj3Cb7jE7Jokmqn8hzV4MquazZGGiHNnML0QaGfkyYGwDYb49jQ
         UA/m1RGj+TJZdyQ5yckQi2BXSeiHlz9IFR9C+YoTZL4PHka8qbtNfaQej4P0VYl5yhlD
         P9uISeH0vxcUzD0C2BhtOpQyKR1LkFdeNOovMZPYgRciuM3Vc8l1MmpWdg+0OHJ6bxiT
         7kqOuJ67r0rkGuT0Eq/yviE92RPdpmQrsJmjQXA+PeOBx4LFG2cZp9eB/rMU229MbzlF
         YQ7w==
X-Gm-Message-State: APjAAAUE2TLLOS9ETo+PAM7K7u2zr8wypvGBi1tSjq7GmXgJjLYOSHc2
        +J8JA1gm19IiqFpsRdo9deyU6vvD3p4=
X-Google-Smtp-Source: APXvYqzAdiURTJkw+wL5INQCHGwebytUCxosFh0Rxy8MyZd3Ipcw6PQhyLiwIClrbMUXLI8uU5p50A==
X-Received: by 2002:a63:10d:: with SMTP id 13mr53810981pgb.176.1558420869739;
        Mon, 20 May 2019 23:41:09 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u11sm21553991pfh.130.2019.05.20.23.41.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 23:41:09 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: fib_rule_tests: use pre-defined DEV_ADDR
Date:   Tue, 21 May 2019 14:40:47 +0800
Message-Id: <20190521064047.10002-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEV_ADDR is defined but not used. Use it in address setting.
Do the same with IPv6 for consistency.

Reported-by: David Ahern <dsahern@gmail.com>
Fixes: fc82d93e57e3 ("selftests: fib_rule_tests: fix local IPv4 address typo")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 617321d3b801..a93e6b690e06 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -15,6 +15,7 @@ GW_IP6=2001:db8:1::2
 SRC_IP6=2001:db8:1::3
 
 DEV_ADDR=192.51.100.1
+DEV_ADDR6=2001:db8:1::1
 DEV=dummy0
 
 log_test()
@@ -55,8 +56,8 @@ setup()
 
 	$IP link add dummy0 type dummy
 	$IP link set dev dummy0 up
-	$IP address add 192.51.100.1/24 dev dummy0
-	$IP -6 address add 2001:db8:1::1/64 dev dummy0
+	$IP address add $DEV_ADDR/24 dev dummy0
+	$IP -6 address add $DEV_ADDR6/64 dev dummy0
 
 	set +e
 }
-- 
2.19.2

