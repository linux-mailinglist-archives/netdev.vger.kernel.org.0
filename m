Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A91320DF9
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhBUVfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhBUVes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:34:48 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A72C06178A
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:07 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id e13so22856499ejl.8
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1IpLJbP5ciwR6SMBLis+whJOXKeaI6W/OneiV4n/9jo=;
        b=SGKVwIom1x2WQ14lWlfc5n7xdraES6n4DpaRzx5GimcrLarAVxQ1Gs1xx25wxec3qK
         7Yc0YN6dBMV7Q9p1+hIo5iVAH6S/GwhFmviICmInV2xxCW0sYFSOArrfLP17nyy5n7xf
         HLK21rPZBcA4wG05wAhFV59RFSSLSswiEggzhHd903w5zZhw/SdoE0ORib4WNtwcve1Q
         jd3bif7kjdXWN3a9pyNC2bNAL69+Z/Z0jtI5FEoETaSF3mXmT/r1Pvt/JHaP9oF9BxD6
         2wqNpF+oqJvhneeTXt50LvfEX31H7iW27kVXbNdwo53s8fY0rFIhdnFQJ2Zq0w/cCPJi
         1RlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1IpLJbP5ciwR6SMBLis+whJOXKeaI6W/OneiV4n/9jo=;
        b=UtXAk+5ti44kpc1kJz92WJl54zqFIDgGkg5gzDD2QQ3V0yJDWRoXSdLcj7IikxLoPE
         A/xoEJO2fnsEydEk2PmBhAOB/9VcY/XgaQImVEaAn6+KoOKpy9yBfsxtXAxjOYm1twnO
         GDaUuOLrByQImbj26UsKkJsVn+UUN3lIY4dOf4xOvDza/6/Lln/zAwsS8N1IMDiN5qei
         IAK0itdiInMSOBRUYd7TEVqbs0oGOfjt8tL4Z+oRNk0tnq5NxBgaOnj5p9gxb78lffAE
         4gHQ99ouQd8pJfvimB9B0cF1483cBSXA4zkQqIDZS3Wk75Gzf3InyM01Yui2qg0/nO04
         OBkw==
X-Gm-Message-State: AOAM533DWF30bjOKde0Gjp9gl0uoycVqq9JeQHlxn0K0Gtv+op5+SvCe
        7rlCwjtPe56nYhI5wHXsTH8plVmZuSQ=
X-Google-Smtp-Source: ABdhPJxAmGTt7X0z4rC7Gw+BBYPZV5u6FGPPfsMKUYsfw5HSk7z1OlzOuDds9f4HIeZwOWsoOIDw5w==
X-Received: by 2002:a17:906:ad3:: with SMTP id z19mr16436817ejf.350.1613943246441;
        Sun, 21 Feb 2021 13:34:06 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 01/12] Documentation: networking: update the graphical representation
Date:   Sun, 21 Feb 2021 23:33:44 +0200
Message-Id: <20210221213355.1241450-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
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

