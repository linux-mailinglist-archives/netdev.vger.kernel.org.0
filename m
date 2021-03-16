Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322C833D2E3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhCPLYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhCPLYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87301C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:29 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ox4so55859340ejb.11
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+sscrZfx852jdNoCdkU3M4svDACOXt6VG5XQsbu8SBk=;
        b=O+NzD7sgGrMlSQZojqClgNh/ql4M6olEgNSYzk5wRmIWt2wQQ+VW1gZNu51Q+IzNC8
         SYI5WJgHi8nTBBY5bM+2Db7h/WZl/t7sL9KkaRHv8VST1oMC+XtmtuGiFvyVv25UMlWf
         LJao5Lei0bKSvHwE/GCtqv6mQj1alIp8lCL+ktqTDU1Uinfw4d/nMcBLRXoyjOAYSsR5
         ORIAXf4BnHUfgic6eKWJTquMVqt7o0j15kmQ9KW0uDt9u/Rdf8g6DT2QujbX9HyKy7hU
         XHmzvl6WI7tfjIRqJLeiGVSjxxD5B96QYwtQ/vjvsXkW2+vrHv1MxrqIKyvv7ATJihjj
         b3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+sscrZfx852jdNoCdkU3M4svDACOXt6VG5XQsbu8SBk=;
        b=Gnw7Z+ZhyGcB0aIeXM+oSk1iI+S2mi/MRJx9HrJEtgRWWTxj9lYKXaEiqqq36IePoH
         01LLts8fUH1h57hZJMoqKl0+wT/ZJlLKDAcI6AqD6fCZuday3VXNOzEOg9rZJlL3T7zf
         whNR1Pd/r4CrVz4ec7d4oYs4gmGYzf1o4XblTzU3Dbx8XM4aJoP8oaY60l4BKDu9ewJT
         D/jBtxRMuHK87GXt3x6dIUYOSqT60DGm0VTHJeJthTUwOkfkPFf213MinWXCUX8KTl0/
         BWCVtZEsLlyvLjYAQKyzjpehDGhJmEIpNZmEwLiheqx1xisANAaM9xiJ4cMOsNZwNvYT
         o3bg==
X-Gm-Message-State: AOAM533b2ltbP9w1T1oBq8dQB9IiDqQpuQljed7TtXdH9XeTHfkZhPXb
        yyGIofFZJGA9yzKu/BWjaEkw5MD4Gxg=
X-Google-Smtp-Source: ABdhPJwzXV9eE6ALr5VgdKFY8V8VwWLlS7tryzrvVudYtCfSaHDOQ8lQsf71nDJD+ZIvyWX5DrQzfw==
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr26219861ejc.326.1615893868002;
        Tue, 16 Mar 2021 04:24:28 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 01/12] Documentation: networking: update the graphical representation
Date:   Tue, 16 Mar 2021 13:24:08 +0200
Message-Id: <20210316112419.1304230-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

While preparing some slides for a customer presentation, I found the
existing high-level view to be a bit confusing, so I modified it a
little bit.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 Documentation/networking/dsa/dsa.rst | 45 +++++++++++++++++-----------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index e9517af5fe02..e20fbad2241a 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -172,23 +172,34 @@ Graphical representation
 Summarized, this is basically how DSA looks like from a network device
 perspective::
 
-
-                |---------------------------
-                | CPU network device (eth0)|
-                ----------------------------
-                | <tag added by switch     |
-                |                          |
-                |                          |
-                |        tag added by CPU> |
-        |--------------------------------------------|
-        |            Switch driver                   |
-        |--------------------------------------------|
-                  ||        ||         ||
-              |-------|  |-------|  |-------|
-              | sw0p0 |  | sw0p1 |  | sw0p2 |
-              |-------|  |-------|  |-------|
-
-
+                Unaware application
+              opens and binds socket
+                       |  ^
+                       |  |
+           +-----------v--|--------------------+
+           |+------+ +------+ +------+ +------+|
+           || swp0 | | swp1 | | swp2 | | swp3 ||
+           |+------+-+------+-+------+-+------+|
+           |          DSA switch driver        |
+           +-----------------------------------+
+                         |        ^
+            Tag added by |        | Tag consumed by
+           switch driver |        | switch driver
+                         v        |
+           +-----------------------------------+
+           | Unmodified host interface driver  | Software
+   --------+-----------------------------------+------------
+           |       Host interface (eth0)       | Hardware
+           +-----------------------------------+
+                         |        ^
+         Tag consumed by |        | Tag added by
+         switch hardware |        | switch hardware
+                         v        |
+           +-----------------------------------+
+           |               Switch              |
+           |+------+ +------+ +------+ +------+|
+           || swp0 | | swp1 | | swp2 | | swp3 ||
+           ++------+-+------+-+------+-+------++
 
 Slave MDIO bus
 --------------
-- 
2.25.1

