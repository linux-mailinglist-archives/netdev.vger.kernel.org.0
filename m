Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0D32B5C38
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKQJwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgKQJwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:52:20 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971B9C0613CF;
        Tue, 17 Nov 2020 01:52:20 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b63so13353236pfg.12;
        Tue, 17 Nov 2020 01:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=M+dllZ9kCvWJwYa6/87jojnnkVI8Jce5fmRcthAcfzY=;
        b=QKjA2cJekw6F4iKVIbkMdtGXBgz+NCn0YwFqEoN2XKNRk2FSjBcY9otjkR1CPhIt2a
         ZDWti3kBFW9FMCAFNRINDVw2lfk0apI0rIBXNAeXZtHsz2REvA34ig+wLYfeRi/wqdbu
         1Uonfk9unIkr0MlzGk2KURP1QLtVaDd08qClMcULD0IvsS+OjmM/I94R4NWkrH4txPGX
         ITPnts2UADfLC3doTD45hPNRtPUAobqdi8FHk8TwILzCJwuBSMXKvjsiZD9dRP0Fr8BV
         kOLdZQ9tVASyWxoGqHkvuDkrJuUme4CkY85wSyXoqtrbSYJIrLvlmW6Hcay6y4HRETtE
         Helg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=M+dllZ9kCvWJwYa6/87jojnnkVI8Jce5fmRcthAcfzY=;
        b=l8wRJVwejOlAQXCjKmlj/tFTVNkOk0wp1/SJ0Wzv9bMRwIOYrvoOzTBmzJQ808CRkl
         K3eRubPpV3VsdlmuHJFaEzGPmljHOMi2Ax//qGn/8PIX/Qr27gT6gTeIhuQbniH70iVh
         UOEM+AEZHI+QGrhMLDnkhA6ojuOumlrjsNll9eWcsz5Iz4AVqW7l+sMZKbL9i0dbniFU
         fEw/6IIwOBFezqYWi3dNXHByVO81oGOQEHntA1XxcMQGYu71EhjD4vajAOil6aumFqyk
         gdocEO/mJklHpi7oUtMyh28n/LdR2XDHPH2I7kyt9rptZkHt9UqjocflZTgdf5ihAMC9
         8bRw==
X-Gm-Message-State: AOAM533ZHIBH7BnhMDLBNGwLCnmn9Boy9WWn1l2qTuKIVeOq0tOfY0S2
        9c+qB5f4tZzEuTyOcYXvDqkiXHldi/Yj
X-Google-Smtp-Source: ABdhPJyJhzOO1FajPi/pdxK6/4jSB39ngl/1r1oGEWBJI9Wsh5fborxur5j1Y42/J+uAhM81zFct5g==
X-Received: by 2002:a05:6a00:2126:b029:18b:6372:d444 with SMTP id n6-20020a056a002126b029018b6372d444mr18189364pfj.26.1605606740007;
        Tue, 17 Nov 2020 01:52:20 -0800 (PST)
Received: from Sleakybeast ([14.192.29.250])
        by smtp.gmail.com with ESMTPSA id z7sm20660554pfr.140.2020.11.17.01.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 01:52:19 -0800 (PST)
Date:   Tue, 17 Nov 2020 15:22:07 +0530
From:   Siddhant Gupta <siddhantgupta416@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mamtashukla555@gmail.com,
        himadrispandya@gmail.com
Subject: [PATCH] Documentation: networking: Fix Column span alignment
 warnings in l2tp.rst
Message-ID: <20201117095207.GA16407@Sleakybeast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix Column span alignment problem warnings in the file

Signed-off-by: Siddhant Gupta <siddhantgupta416@gmail.com>
---
 Documentation/networking/l2tp.rst | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking/l2tp.rst
index 498b382d25a0..0c0ac4e70586 100644
--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -171,7 +171,8 @@ DEBUG              N        Debug flags.
 ================== ======== ===
 Attribute          Required Use
 ================== ======== ===
-CONN_ID            N        Identifies the tunnel id to be queried.
+CONN_ID            N        Identifies the tunnel id 
+                            to be queried.
                             Ignored in DUMP requests.
 ================== ======== ===
 
@@ -208,8 +209,8 @@ onto the new session. This is covered in "PPPoL2TP Sockets" later.
 ================== ======== ===
 Attribute          Required Use
 ================== ======== ===
-CONN_ID            Y        Identifies the parent tunnel id of the session
-                            to be destroyed.
+CONN_ID            Y        Identifies the parent tunnel id 
+                            of the session to be destroyed.
 SESSION_ID         Y        Identifies the session id to be destroyed.
 IFNAME             N        Identifies the session by interface name. If
                             set, this overrides any CONN_ID and SESSION_ID
@@ -222,13 +223,12 @@ IFNAME             N        Identifies the session by interface name. If
 ================== ======== ===
 Attribute          Required Use
 ================== ======== ===
-CONN_ID            Y        Identifies the parent tunnel id of the session
-                            to be modified.
+CONN_ID            Y        Identifies the parent tunnel 
+                            id of the session to be modified.
 SESSION_ID         Y        Identifies the session id to be modified.
-IFNAME             N        Identifies the session by interface name. If
-                            set, this overrides any CONN_ID and SESSION_ID
-                            attributes. Currently supported for L2TPv3
-                            Ethernet sessions only.
+IFNAME             N        Identifies the session by interface name. If set,
+                            this overrides any CONN_ID and SESSION_ID
+                            attributes. Currently supported for L2TPv3 Ethernet sessions only.
 DEBUG              N        Debug flags.
 RECV_SEQ           N        Enable rx data sequence numbers.
 SEND_SEQ           N        Enable tx data sequence numbers.
@@ -243,10 +243,10 @@ RECV_TIMEOUT       N        Timeout to wait when reordering received
 ================== ======== ===
 Attribute          Required Use
 ================== ======== ===
-CONN_ID            N        Identifies the tunnel id to be queried.
-                            Ignored for DUMP requests.
-SESSION_ID         N        Identifies the session id to be queried.
-                            Ignored for DUMP requests.
+CONN_ID            N        Identifies the tunnel id 
+                            to be queried. Ignored for DUMP requests.
+SESSION_ID         N        Identifies the session id 
+                            to be queried. Ignored for DUMP requests.
 IFNAME             N        Identifies the session by interface name.
                             If set, this overrides any CONN_ID and
                             SESSION_ID attributes. Ignored for DUMP
-- 
2.25.1

