Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6800D33D2E7
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhCPLYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhCPLYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67061C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:32 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e7so21018371edu.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kNcIxvr5K3KWWO+wJV4eXS1fCT/KzxdI1FTVgwiyVOc=;
        b=ASWswAcoJzaPqrD2nNtmQWC1XVtgb0YthPIZmMlB0bBemSZvujI2X3GZFrx12ZeAfZ
         0W01/9ZSMtSlBfCaTVBorojJMyAb99HzgGW9mWeWtype6UwCDVPFr0tcBDGwJQbx/MIz
         ocz08c4Re3ADrzzvW1OMocr0mQlAd7bqhR4EpTgS6IBWu98HqeI6EhvC1fZ+0Gy3gC9Y
         gi7rsV1yKDe7Iq/vT44yBisWpVOcPVUbyHVVz0qZT4xv1WQcHjcOAPMB2yTq2yRTSdTa
         /8vcPVdf35PKZTuZlMYRSIca6POedo9TbmmYvp5kxUHX/nUhYb8O285pLSIBLw/NStp1
         wbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kNcIxvr5K3KWWO+wJV4eXS1fCT/KzxdI1FTVgwiyVOc=;
        b=JDwMtksGkIL6REaD0zx3P94OLtk31uyPG3edzCpKKvdW0GGH4zfuhtNEcFQVogFPYP
         w2cRVoab9O194lzFg1oOiPY8XhNIQq7dIZtq6q4aXxPutwcukkMYRB6bDsKH7S7h9nTT
         8prgSN9gQpcEHi/qitkiI2PGJRBDHHpYPr0LLSaQ3miNfmjb+Ha53yOdBBW1hGFoojvb
         asujolByaWn2xjvHF/I4urnzxVO9QfDDqMrPyTZpgSzJGUypRtLg5DRjsbpIwslTzoKz
         zk/v2slCOP+gObmtau9RnlnYY9bcuyMh7Txb3xYtA2Te/zA0TeGVaef639LgnV4Ldz9B
         hZDA==
X-Gm-Message-State: AOAM5333ArvnWSF9vuTquF0e9qxioWMu80g7wn7rQVHiwwXEvRY9wJot
        x4GHCSGS10li+PLvFkzoYxL9ptt4Wno=
X-Google-Smtp-Source: ABdhPJz4lp3GVFgnAMxrrm5ssx3pQxv/8KpecJFhH0XiTsJeV6WoSBNFwa75C5cild7ofmeseU4nAg==
X-Received: by 2002:aa7:d1d0:: with SMTP id g16mr18897531edp.358.1615893869927;
        Tue, 16 Mar 2021 04:24:29 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 03/12] Documentation: networking: dsa: remove static port count from limitations
Date:   Tue, 16 Mar 2021 13:24:10 +0200
Message-Id: <20210316112419.1304230-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After Vivien's series from 2019 containing commits 27d4d19d7c82 ("net:
dsa: remove limitation of switch index value") and ab8ccae122a4 ("net:
dsa: add ports list in the switch fabric"), this is basically no longer
true.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/dsa/dsa.rst | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 17d1422ac085..3bca80a53a86 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -382,14 +382,6 @@ DSA data structures are defined in ``include/net/dsa.h`` as well as
 Design limitations
 ==================
 
-Limits on the number of devices and ports
------------------------------------------
-
-DSA currently limits the number of maximum switches within a tree to 4
-(``DSA_MAX_SWITCHES``), and the number of ports per switch to 12 (``DSA_MAX_PORTS``).
-These limits could be extended to support larger configurations would this need
-arise.
-
 Lack of CPU/DSA network devices
 -------------------------------
 
@@ -719,7 +711,6 @@ two subsystems and get the best of both worlds.
 Other hanging fruits
 --------------------
 
-- making the number of ports fully dynamic and not dependent on ``DSA_MAX_PORTS``
 - allowing more than one CPU/management interface:
   http://comments.gmane.org/gmane.linux.network/365657
 - porting more drivers from other vendors:
-- 
2.25.1

