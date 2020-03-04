Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C31790B0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 13:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbgCDM4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 07:56:31 -0500
Received: from mail-yw1-f44.google.com ([209.85.161.44]:34423 "EHLO
        mail-yw1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgCDM4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 07:56:30 -0500
Received: by mail-yw1-f44.google.com with SMTP id o186so1825447ywc.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 04:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f1APgUNTd4gCc4nd41dhht3j32lTZuA7H/Jmv2at1Vc=;
        b=m0BoeBtzQ43XrKiPYGG+7TUcgviioVK+JohiAlq9N1CJo3ra1NlGdSJO3v1ws3fdU8
         jr22p7LlpV3fVEihi+9EFXpZPiUtU2NwKPISWsl+mQr8BsSwxfVGMBzJvi08PJhLDpJh
         qRTcM0GSsAW5fjEgJRMkroBkgo0Yqmh1TJ4CsCSDDJ4UIdlTtR6jVlODFy7OlQ2hdUwW
         v04ywofoah0HWayyiW25gPwqRaRmOv79BN4Sac8j1grjwAX5qhaaDmFjZ8tFJgrUkVu3
         XXWSgVWONy2h7zsKQ+lfnWl60rGYNLvxvB34Ej5w2rRwjYHyNCfUxSP7NJkChyGWqt9+
         bnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f1APgUNTd4gCc4nd41dhht3j32lTZuA7H/Jmv2at1Vc=;
        b=hf+JCpNEDyB3ZLS+Ga2wxdL6nTp1V1fX9m7BsaOQy4ltDgZlUfulPQG8B1DjWd5EHK
         uMyCa+daB2hAkYhzFPP9ckcq4X6jgAJ6Bc+4Mpmc7adf+gPPBc5aUxKgV2TcQaRejpe6
         BE+z52Ycq/ctX0+MpnU7JacqQ0OuEiypX+FOPxjvZQdNRZzHeE/VIOTG+MABkHGIGOAz
         hj7T9/h9MRJF2v5wiwjG0968+Wvq+wwqxHAmR2CHrmrCxgWOEv/rUQzFlgXxuaq6lvJk
         3kJ64PGTG0ImuOwpfd8/aTIpluGdoPe/MbBhNWZ3nJhodwi41rpou7DSQJ9JblNwWYGy
         zrRg==
X-Gm-Message-State: ANhLgQ1F9D7tj5Nrj9U6mdR/BwZCKq/TMJehCvf6d3rJ4CoRbye+4RAa
        iFhDWx57YWuKMySXWEPHOoBITw==
X-Google-Smtp-Source: ADFU+vsTbf41ImXLEBA2SpVgWcZ5mCEibrw8AknoA9ab8WKoyzBhORlZFO3HOpAIdSzuBdrywR14tw==
X-Received: by 2002:a0d:dcc7:: with SMTP id f190mr2908408ywe.193.1583326589526;
        Wed, 04 Mar 2020 04:56:29 -0800 (PST)
Received: from mojatatu.com ([74.127.202.122])
        by smtp.gmail.com with ESMTPSA id y189sm10481104ywe.21.2020.03.04.04.56.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Mar 2020 04:56:29 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 2/2] tc-testing: updated tdc tests for basic filter with canid extended match rules
Date:   Wed,  4 Mar 2020 07:55:47 -0500
Message-Id: <1583326547-23121-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583326547-23121-1-git-send-email-mrv@mojatatu.com>
References: <1583326547-23121-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/basic.json         | 220 +++++++++++++++++++++
 1 file changed, 220 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index afb9187b46a7..e788c114a484 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -1054,5 +1054,225 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
         ]
+    },
+    {
+        "id": "b2b6",
+        "name": "Add basic filter with canid ematch and single SFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(sff 1)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(sff 0x1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "f67f",
+        "name": "Add basic filter with canid ematch and single SFF with mask",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(sff 0xaabb:0x00ff)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(sff 0x2BB:0xFF\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "bd5c",
+        "name": "Add basic filter with canid ematch and multiple SFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(sff 1 sff 2 sff 3)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(sff 0x1 sff 0x2 sff 0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "83c7",
+        "name": "Add basic filter with canid ematch and multiple SFF with masks",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(sff 0xaa:0x01 sff 0xbb:0x02 sff 0xcc:0x03)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(sff 0xAA:0x1 sff 0xBB:0x2 sff 0xCC:0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "a8f5",
+        "name": "Add basic filter with canid ematch and single EFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(eff 1)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(eff 0x1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "98ae",
+        "name": "Add basic filter with canid ematch and single EFF with mask",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(eff 0xaabb:0xf1f1)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(eff 0xAABB:0xF1F1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6056",
+        "name": "Add basic filter with canid ematch and multiple EFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(eff 1 eff 2 eff 3)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(eff 0x1 eff 0x2 eff 0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "d188",
+        "name": "Add basic filter with canid ematch and multiple EFF with masks",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(eff 0xaa:0x01 eff 0xbb:0x02 eff 0xcc:0x03)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(eff 0xAA:0x1 eff 0xBB:0x2 eff 0xCC:0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "25d1",
+        "name": "Add basic filter with canid ematch and a combination of SFF/EFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(sff 0x01 eff 0x02)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(eff 0x2 sff 0x1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "b438",
+        "name": "Add basic filter with canid ematch and a combination of SFF/EFF with masks",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'canid(sff 0x01:0xf eff 0x02:0xf)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*canid\\(eff 0x2:0xF sff 0x1:0xF\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.7.4

