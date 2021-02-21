Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74A2320DFD
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhBUVgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhBUVfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7223C061794
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:11 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id u20so25384045ejb.7
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UqFesGulIMwJDkH9ePR4lANvy3siG3rdUdqpoeTimIQ=;
        b=XH5qKMhEwrNBrXO7xMINN6IsRnE7ZJImZz4LCp/Ld6TT+87qWJlemCAs/+sv8FehOv
         iViAaWuOYpFt43IhTeWvvIfP+DeSH5j+a/g7sr2Izr2QdQHKtx7j8GcN80YLosioOvmF
         vrxpYN+M0rb0HBGun/JxX8b2DZMn7Ab0uvBgEaIBKV2tIHUvOJI2bq8ODCDZnKvoPRI1
         KRlqDf9zOxTszTdloCtD4SdIfsjjQDRuGs3OJKbZYQnB8x3NtuRD5ViK4yS/tk8db8VF
         zHsd7awEK1UGaI/hn91r2NHBQ0WYGNl2nZwFNQ5gaSCaDXBlMNvRKAwO1Kx8dp7Hkqqi
         YmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UqFesGulIMwJDkH9ePR4lANvy3siG3rdUdqpoeTimIQ=;
        b=nIaLJEcdtIpr1v7SwiJ0Fw7w3Ww8OQrfTF6mHnulYxypSJLmTf7lIQDZc1tL7g/W/s
         8/x+yB/gb9yPlGslNcG+l64iLHR+iYxKTI9mr37i8IwGQ1zOZgD0RLTFRfLDxIU+CXX5
         VRSyBfb97MtHxp+lvira2bh4eOxA1FuuARoH7Tkh9P4kPvH3irnpo1jteEBld2mGwXEz
         nhJJVHb8UevN51vd74fdKkhVdQZ3g8xnOTrlLmElYUGkNTny6kex148LXeP3veoGSSZJ
         BkHAt9YCr32nW5KJarU2F48JeesooXV097lAy5uO/7xH50ecM7+qC70OEb8jl5IA6v4a
         zHjw==
X-Gm-Message-State: AOAM530Y30sAKmgvWRIAiU1TFUmJoH3cRAjI3pqQNNb/KdDU1GlNFm4P
        kMix+UOTcFpIMhsWU5Prl9dRRIpyFQI=
X-Google-Smtp-Source: ABdhPJzjSDF6ToLk/OXqc4lKHVLbKpmsQ4UxqsQoAYKjDCs1kkMUGhsm9QANxqnGBgzLR75TW/sTKg==
X-Received: by 2002:a17:906:68e:: with SMTP id u14mr17473095ejb.380.1613943250344;
        Sun, 21 Feb 2021 13:34:10 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:10 -0800 (PST)
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
Subject: [RFC PATCH net-next 05/12] Documentation: networking: dsa: remove TODO about porting more vendor drivers
Date:   Sun, 21 Feb 2021 23:33:48 +0200
Message-Id: <20210221213355.1241450-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On one hand, the link is dead and therefore useless.

On the other hand, there are always more drivers to port, but at this
stage, DSA does not need to affirm itself as the driver model to use for
Ethernet-connected switches (since we already have 15 tagging protocols
supported and probably more switch families from various vendors), so
there is nothing actionable to do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 8fb0ceff3418..19ce5bb0a7a4 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -677,5 +677,3 @@ Other hanging fruits
 
 - allowing more than one CPU/management interface:
   http://comments.gmane.org/gmane.linux.network/365657
-- porting more drivers from other vendors:
-  http://comments.gmane.org/gmane.linux.network/365510
-- 
2.25.1

