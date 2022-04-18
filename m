Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFEE505EE8
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 22:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiDRUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 16:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiDRUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 16:34:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC1130576
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 13:31:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g20so18726649edw.6
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 13:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kquNecLZZYH6hu6MW6FOPghOVPjT10WSvbwKReYwUVQ=;
        b=T4YRQs95h8RDu2w64gRA/14V0dPhE2Shbqr7yo/BpKD8RXat3Lnxrpk4Dz448sFKvD
         WMIqDb8gc5MLsZkqlODenPLW4Q3VgFzdtApuAHkcIJlXUf3kUORiYbQ7+CFjz3wJsSOj
         +XTZW84zmOVBEu35DSCjLxhJopkXOehpC7tBB+X5m1gJPQkJZOzJVrp/kAQ07kdVrJYe
         yosVQf1Qq51aM4ScHQnF1rH4iy0BH81WjScY8YJm+vOfqo6Eyy5uPNsT4aQ22gSKXMGK
         KjE65ds2xYUrd0vtxn5g7EPnnyRLibBlFBsAJtX5L15RBf+7LrdFDd7cfHd3f5E5jetR
         ROpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kquNecLZZYH6hu6MW6FOPghOVPjT10WSvbwKReYwUVQ=;
        b=QO4sqKk+3ET3jiFA4vDlSQd4IKqv3OW3LX51kG3kqVs0hUI/Nf9cQvG3npDtHYygtb
         UA7B1s7gUiGLk1oVeAJcqiEpQKMXjXw0ApNCamg+heImDyy7YncYzPhYjdkcdw7jTBtg
         4K13idBKl2kAQTylWyufVHMkNrjS/wMllrPnLUZPP9ME+/heoFNg5yApgW+3LDVKjTsE
         aTVUgRSFFqN+HDk90pFzt1dMwqX93iCwH5sFf33HK3+F5si8k2crZ0MjIjkBu7m1qSAA
         8nLJqtSd3hdQT+2t4hyPvwQYUwGS2zr2Hpj8sI49uM/RnnKXeLK9XwivNHg1sbyaelQT
         rpSA==
X-Gm-Message-State: AOAM530SPPrcpG2toWB8E/+9GaTDZl71CFJkeC+2LHu2HPZTG1WWCWtG
        GC8lhTx44b8RR7OMQaH10r8YKPXHb2Q/ZA==
X-Google-Smtp-Source: ABdhPJzNhOnZDRZQ8BgWJdi5TlCbfEM8JqMsr+SmSGaZ5Ccayuu5cOTok453AZLHK8vL8d+DxyurxA==
X-Received: by 2002:a05:6402:2809:b0:423:e123:5e40 with SMTP id h9-20020a056402280900b00423e1235e40mr8446804ede.84.1650313890729;
        Mon, 18 Apr 2022 13:31:30 -0700 (PDT)
Received: from localhost (91-113-2-155.adsl.highway.telekom.at. [91.113.2.155])
        by smtp.gmail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm7763758eda.2.2022.04.18.13.31.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 13:31:30 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 1/2] man: 'allow to' -> 'allow one to'
Date:   Mon, 18 Apr 2022 22:31:27 +0200
Message-Id: <20220418203128.747915-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

Lintian warnings:

I: iproute2: typo-in-manual-page usr/share/man/man8/tc-ctinfo.8.gz line 61 "allow to" "allow one to"
I: iproute2: typo-in-manual-page usr/share/man/man8/tc-netem.8.gz line 70 "allow to" "allow one to"
I: iproute2: typo-in-manual-page usr/share/man/man8/tc-netem.8.gz line 90 "allow to" "allow one to"
I: iproute2: typo-in-manual-page usr/share/man/man8/tc-pedit.8.gz line 307 "allow to" "allow one to"
I: iproute2: typo-in-manual-page usr/share/man/man8/tc-skbmod.8.gz line 66 "allow to" "allow one to"
I: iproute2: typo-in-manual-page usr/share/man/man8/tc-vlan.8.gz line 48 "allow to" "allow one to"
I: iproute2: typo-in-manual-page usr/share/man/man8/tc.8.gz line 346 "allow to" "allow one to"
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
Lintian nags me, so it's only fair that I then nag you

 man/man8/tc-ctinfo.8 | 2 +-
 man/man8/tc-netem.8  | 4 ++--
 man/man8/tc-pedit.8  | 2 +-
 man/man8/tc-skbmod.8 | 2 +-
 man/man8/tc-vlan.8   | 2 +-
 man/man8/tc.8        | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/man/man8/tc-ctinfo.8 b/man/man8/tc-ctinfo.8
index 5b761a8f..efa2eeca 100644
--- a/man/man8/tc-ctinfo.8
+++ b/man/man8/tc-ctinfo.8
@@ -58,7 +58,7 @@ Specify the conntrack zone when doing conntrack lookups for packets.
 zone is a 16bit unsigned decimal value.
 Default is 0.
 .IP CONTROL
-The following keywords allow to control how the tree of qdisc, classes,
+The following keywords allow one to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
 .RS
 .TP
diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
index 63ccc2a3..21775854 100644
--- a/man/man8/tc-netem.8
+++ b/man/man8/tc-netem.8
@@ -67,7 +67,7 @@ NetEm \- Network Emulator
 
 .SH DESCRIPTION
 NetEm is an enhancement of the Linux traffic control facilities
-that allow to add delay, packet loss, duplication and more other
+that allow one to add delay, packet loss, duplication and more other
 characteristics to packets outgoing from a selected network
 interface. NetEm is built using the existing Quality Of Service (QOS)
 and Differentiated Services (diffserv) facilities in the Linux
@@ -87,7 +87,7 @@ Delay and jitter values are expressed in ms while correlation is percentage.
 
 .SS distribution
 allow the user to choose the delay distribution. If not specified, the default
-distribution is Normal. Additional parameters allow to consider situations in
+distribution is Normal. Additional parameters allow one to consider situations in
 which network has variable delays depending on traffic flows concurring on the
 same path, that causes several delay peaks and a tail.
 
diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index b9d5a44b..2ea42929 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -304,7 +304,7 @@ allows one to exclude bits from being changed. Supported only for 32 bits fields
 or smaller.
 .TP
 .I CONTROL
-The following keywords allow to control how the tree of qdisc, classes,
+The following keywords allow one to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
 .RS
 .TP
diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index 52eaf989..646a7e63 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -63,7 +63,7 @@ Used to mark ECN Capable Transport (ECT) IP packets as Congestion Encountered (C
 Does not affect Non ECN-Capable Transport (Non-ECT) packets.
 .TP
 .I CONTROL
-The following keywords allow to control how the tree of qdisc, classes,
+The following keywords allow one to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
 .RS
 .TP
diff --git a/man/man8/tc-vlan.8 b/man/man8/tc-vlan.8
index eee663fa..e199c9ae 100644
--- a/man/man8/tc-vlan.8
+++ b/man/man8/tc-vlan.8
@@ -45,7 +45,7 @@ outer-most VLAN encapsulation. The
 .IR PUSH " and " MODIFY
 modes require at least a
 .I VLANID
-and allow to optionally choose the
+and allow one to optionally choose the
 .I VLANPROTO
 to use.
 
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index 4338572a..d9d80964 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -343,7 +343,7 @@ band is not stopped prior to dequeuing a packet.
 .TP
 netem
 Network Emulator is an enhancement of the Linux traffic control facilities that
-allow to add delay, packet loss, duplication and more other characteristics to
+allow one to add delay, packet loss, duplication and more other characteristics to
 packets outgoing from a selected network interface.
 .TP
 pfifo_fast
-- 
2.34.1

