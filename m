Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1463EA0AD
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhHLIi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbhHLIix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:38:53 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCC1C0613D5;
        Thu, 12 Aug 2021 01:38:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q18so241787wrm.6;
        Thu, 12 Aug 2021 01:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1G6L3GSRVFiRjFplhDibF/A1i3r5+cB+7jxsSGpzJV0=;
        b=JwWbf6hH4SOkZPTDZCuG2zbLx1DgYxV6e28Hu6AQpX8kff8TEIHJ2ueSFk5t366goi
         z3M6oEtoAU8VACit7gUg0/0QyyIy9vpJCTdtUG57y5KWXhdgzLEdXz0DUIEkxGMNKTY/
         NEseMX4y7tPoPLETtxtl79ae1jElfHdpBb5X1WLKrAqeI+sr9g9x82EaluuLq7JCA6G3
         5JctG+dstbkisNBAqIQ/MUXTexksYM7qdPUGkWHcxAw0Gy5lsvBv2mzd2Ehb+dWiJrdW
         Q5ONcQIK0M/xtCapRtftr5QB9z4unWKh9mbEezg4u3zDA9OfYMneShA2uxgSP4QXBmwv
         ePYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1G6L3GSRVFiRjFplhDibF/A1i3r5+cB+7jxsSGpzJV0=;
        b=V+3AzPZvWLMoJcWgfRpsjQQAPJAYCUs9b461a3j6TAR22wuOu8ETxnI0CjUW6B8zpZ
         /+z/nju7EWGcFs6vuPy+mLABTvJUBZYUuZjKXuDdyEwjtay6UoziVCWX6IISqGKZuKC0
         phjxRiEgfSaySvnPX3u0CC4L8cETfNw1u7vMBZF39A+V3nMKm2g1BK81Z2QSGvPiNE+h
         WkAZtohVOp7n+MbcOwFsRYvU5+VF7vADmpx7bVHlHKf2ZibYswV6Nl0cKdzlrNlcwDnb
         BC3LqXanKc7sNvi4GKzaBo+mrkUmznH1uN/KJ1wOLeUZkOQvqy0qbVlk9ODbCFuAQgl7
         VU+Q==
X-Gm-Message-State: AOAM530mXYZPvcax4+qswlGC1TNEYMopuaMjSZYc49yqJX3UcJ+E+ceJ
        xd0g+i+wWqQIPINh2BJzo+M=
X-Google-Smtp-Source: ABdhPJxMydluqcgS+I18WfKFr/telCFVDx9//iw7sXEL4Tj2VlfO+2ZGfNDBRm/4cVmIt5JnetV14g==
X-Received: by 2002:a5d:4cc6:: with SMTP id c6mr2594134wrt.383.1628757506484;
        Thu, 12 Aug 2021 01:38:26 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d76:9600:40d6:1b8e:9bb5:afdf])
        by smtp.gmail.com with ESMTPSA id 9sm1830324wmf.34.2021.08.12.01.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:38:26 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 3/3] net: dpaa_eth: remove dead select in menuconfig FSL_DPAA_ETH
Date:   Thu, 12 Aug 2021 10:38:06 +0200
Message-Id: <20210812083806.28434-4-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
References: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The menuconfig FSL_DPAA_ETH selects config FSL_FMAN_MAC, but the config
FSL_FMAN_MAC never existed in the kernel tree.

Hence, ./scripts/checkkconfigsymbols.py warns:

FSL_FMAN_MAC
Referencing files: drivers/net/ethernet/freescale/dpaa/Kconfig

Remove this dead select in menuconfig FSL_DPAA_ETH.

Fixes: 9ad1a3749333 ("dpaa_eth: add support for DPAA Ethernet")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index 626ec58a0afc..0e1439fd00bd 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -4,7 +4,6 @@ menuconfig FSL_DPAA_ETH
 	depends on FSL_DPAA && FSL_FMAN
 	select PHYLIB
 	select FIXED_PHY
-	select FSL_FMAN_MAC
 	help
 	  Data Path Acceleration Architecture Ethernet driver,
 	  supporting the Freescale QorIQ chips.
-- 
2.17.1

