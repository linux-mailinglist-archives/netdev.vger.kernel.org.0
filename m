Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5738B30EACE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhBDDSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhBDDSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:18:07 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D8C061573;
        Wed,  3 Feb 2021 19:17:27 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c1so1493344qtc.1;
        Wed, 03 Feb 2021 19:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XIF2R1gf7/D55jJobbj4vCUVH6wlL3iIiTcu/eGTGlA=;
        b=i2FwZ6V50UJ95FjGqmx6etQnqbrSDDKDox0Q+OfrN7gwRLADB/v1b6IUOEyMakk76I
         RvARaT6B7babk+JWXswixYR7r5d6PDivVOj2CJmhP8tuxNS+3rLZVgOZbTYmHeVOgxW6
         MI69iHJM/GNSD4sTmoch4YI9ynTqlXENFeWZifwrLWa9XaF9/4t5qMEqlM6LRbIKZ9zv
         S862qcx7eHsqOTW0DJqUWOmTLPqGCRaygq42i+3bwKBGNmqDPeG2J/jyTzGJJo/pPJV/
         mzP4JziGSKzbGeQEmwCFZaxsBWKH6c89HRQX47ecIGLK1zurZF3AFai+KM7mu7n48nvE
         pIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XIF2R1gf7/D55jJobbj4vCUVH6wlL3iIiTcu/eGTGlA=;
        b=pYEzG9N5NiOYqJo4W8M687NOSuecO1t7D9a9/APTCM/QUUcq3RHm/BIOCTXrpH4yG9
         rDXisOuO76SmDeIM7E8LCVH6aaq92N/7CBq2wsb6xuD6ZXo5x1nucvi73ldUv+h7wMyQ
         edarVOOuF2+uNR8rHs+0ej1qn2xrVHzR/oI9ja+wxcR2RoCjW0NVTvY2z1BVt9cdVWLH
         cjdLo9Og1D+msph9n1fmGsthh7vcw3KkbWUa+4IC9ez9O9CHn/70ZiPMPYDXiAP23M7t
         jOgkUEhWocUT/bfG6aWE9QqhxhTVTBHVOsAccIaIZBj9fU1u5r9f7Gss3gVoXu8r1wUV
         d8ow==
X-Gm-Message-State: AOAM530zLx4zh8lm6/FYYHRxI9hvqvGTa6HTLjl7Z6+dZr2LjoVOVonC
        o63cKpqM8bqC54wTO+9/p08=
X-Google-Smtp-Source: ABdhPJxpeu3KwM+f74V1GHy2bWEkRqBGuCu6LVPTjbh9blqOXkpJTt1ryGH7zmnJr+GWBq4SBdrlfg==
X-Received: by 2002:ac8:7453:: with SMTP id h19mr5421463qtr.354.1612408646846;
        Wed, 03 Feb 2021 19:17:26 -0800 (PST)
Received: from localhost.localdomain ([138.199.13.179])
        by smtp.gmail.com with ESMTPSA id s129sm3846469qkh.37.2021.02.03.19.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 19:17:25 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V3] drivers: net: ethernet: i825xx: Fix couple of spellings in the file ether1.c
Date:   Thu,  4 Feb 2021 08:46:48 +0530
Message-Id: <20210204031648.27300-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



s/initialsation/initialisation/
s/specifiing/specifying/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
Changes from V2:
   Adjust and make changes which are obvious as per Randy's suggestions

 drivers/net/ethernet/i825xx/ether1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index a0bfb509e002..c612ef526d16 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -20,7 +20,7 @@
  * 1.02	RMK	25/05/1997	Added code to restart RU if it goes not ready
  * 1.03	RMK	14/09/1997	Cleaned up the handling of a reset during the TX interrupt.
  *				Should prevent lockup.
- * 1.04 RMK	17/09/1997	Added more info when initialsation of chip goes wrong.
+ * 1.04 RMK	17/09/1997	Added more info when initialisation of chip goes wrong.
  *				TDR now only reports failure when chip reports non-zero
  *				TDR time-distance.
  * 1.05	RMK	31/12/1997	Removed calls to dev_tint for 2.1
@@ -117,7 +117,7 @@ ether1_outw_p (struct net_device *dev, unsigned short val, int addr, int svflgs)
  * Some inline assembler to allow fast transfers on to/off of the card.
  * Since this driver depends on some features presented by the ARM
  * specific architecture, and that you can't configure this driver
- * without specifiing ARM mode, this is not a problem.
+ * without specifying ARM mode, this is not a problem.
  *
  * This routine is essentially an optimised memcpy from the card's
  * onboard RAM to kernel memory.
--
2.26.2

