Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0584D2EEF25
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbhAHJI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbhAHJI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:57 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251F1C0612FB
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:43 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id d17so13542486ejy.9
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OehcWf/fqpAy2S0ELS38TYxWj45yJVZV6WoKp4s+Or0=;
        b=jSDoGoJccePoHjoAtZZZF1UWp57GGYFLbNDO1NAUYlopIs4lZV7z2gMojkSLAjsV7Z
         NRvxZObFQExNDWzVaQjVALBxvan4XnAf3AYWULy/9KphOt2saoWUXS5R3RiP9ybQ1Vyw
         wjYBvkf0tM5oZpcWQ11KdJZOiEKxiTpCbKoopJuxubnKDfaBjCJq39AjSklyWG+TVDUM
         IISR9zGlRnithYS2N7+Q91tnOfWbUApxO/Ps7l5+JSbtxeaMpHezgJ4wNRJz+9TNIXVI
         EW0oFmfLze0R7sC1JTAcK9aluBWtejbpp+Md0V/EKJCETRXZ0Q3mB1xZEN8WfhBpdAl3
         R4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OehcWf/fqpAy2S0ELS38TYxWj45yJVZV6WoKp4s+Or0=;
        b=U8hs2tDSuqNls0aYDGvsLqW5HYva2ofKPNDNlZdR/ckMTNxXf5WDpaqKo0Bw7Kp5qK
         ONgqh8YkE0Ej4EfEdryB65wYGk7XyJ1vJrkdID3SJmcq0u1kXAwdiE5JJKPWZ36p+bEj
         yPNpLGuPFHJn9CpYrsqaZW/TI4FYrpqXSY1Zy7GfLTHIdDwtM4tGn5KiGIFgaxhrWjy4
         x0Ehwwdes2/ytRBQwxBY67Oz1kghA81shVlnb+TYTgRJvVjQ5KZq8hW5oa8a1e2NLfYK
         443fiI6S98ROG587coMDX8sj7Vi9w6Faa09UwmbWZhiyBfvVGoxnze3SNznq4sxhuujM
         KRDA==
X-Gm-Message-State: AOAM532Da+tjlJi7ugziV3Y/D/MkmWiJXIs9dtI5kqzW1kFwxw9p6pVG
        NhIOM91w8foZwhB6wTCfnxg=
X-Google-Smtp-Source: ABdhPJwGBfxQBm08VyOiTpKrb9Gr8FZWzf95bhaslDVYEFN9juxip5HdnmpmVNjwvH/KE1T/+vyQqA==
X-Received: by 2002:a17:907:98ec:: with SMTP id ke12mr1962549ejc.554.1610096861854;
        Fri, 08 Jan 2021 01:07:41 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:41 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 6/6] dpaa2-mac: remove a comment regarding pause settings
Date:   Fri,  8 Jan 2021 11:07:27 +0200
Message-Id: <20210108090727.866283-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The MC firmware takes these PAUSE/ASYM_PAUSE flags provided by the
driver, transforms them back into rx/tx pause enablement status and
applies them to hardware. We are not losing information by this
transformation, thus remove the comment.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - reworded the commit message

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3869c38f3979..69ad869446cf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -181,9 +181,6 @@ static void dpaa2_mac_link_up(struct phylink_config *config,
 	else if (duplex == DUPLEX_FULL)
 		dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
 
-	/* This is lossy; the firmware really should take the pause
-	 * enablement status rather than pause/asym pause status.
-	 */
 	if (rx_pause)
 		dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
 	else
-- 
2.29.2

