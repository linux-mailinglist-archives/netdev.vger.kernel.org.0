Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC49A2ED3A7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbhAGPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhAGPjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:39:01 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117F1C0612FC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 07:37:48 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ga15so10305307ejb.4
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 07:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFp2y4A6EWADRzME0Z9sl6GkREM6Ipuc4MBaPZwFHvI=;
        b=nzt6iGvOdztCyBJnpBeFufUdTNh+garGrjNym1yqJRk28JjgBTE6xskygIoRwJBXuw
         3gYs4ptXSJcOK8eibbqsoT/p/g36fV5j3Z3OcvOFS3nrwIGpj0OWCJYF1IDRa5a4E11d
         ZH21+b5g3Lp6r9Lgk9RaH05/9kzVn4d+rvA8pvKhpo4ltorknGTxdCbMNHuDz4W248oI
         uNEjYH+cFX/g4rQQajF/qb8PkLM/0CrbWT9ePLMNhqW639cKtYvHyXw1evbPR5xMSBmX
         RzDJh9UgZnteE+lQNHk8DpRBywwrvWWaE1G+9qIkxWBVE2zVoyM0UyPudsVPThnOilk3
         maAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFp2y4A6EWADRzME0Z9sl6GkREM6Ipuc4MBaPZwFHvI=;
        b=lGVA2MEf/CiOQ+s7qWH9IU4IRDrh2bGZvjm10TzFtDBz2Fmtd68EKJseLeZqwznTCp
         xrk6hNIdFwlAMT4mmpCtH+8Mr4Dq11PGsip639IIzOmsv1SBcYt0dRkfNkbtWiignMNm
         UEFjcpVwTw/8YHQ8AeW8gwVULMJoAGjjNyP0MZNvvHOxP72n2NcWeMnukyo1X1pDR/D3
         3jXhw/JXsQw8Zpymy3y346ET4+abLULhdetqqgL2yc/PVt2E207dGvEv27X8R6nhwIZc
         WrQevWRKy7CvP/ZWPlg6JkA0yqBa7abjqYc1nYJSMwVuTPdc+z0V27yq8vECbd/hKlKx
         aHyg==
X-Gm-Message-State: AOAM5331PN6j6miIUzyZ6ZwGDv8fr5uhed4nny5DvJeKnuKKxkDhmxNg
        7MId9rFWBpc1fqyfkgTGRGc=
X-Google-Smtp-Source: ABdhPJwXv3RbQG3XMInvyEnhbs3CMmW2oJjK2ZDtgDDKZCHzNsNHgAD5EA/BB9YZoz76Bg7EItLoTA==
X-Received: by 2002:a17:906:4050:: with SMTP id y16mr6366409ejj.537.1610033866745;
        Thu, 07 Jan 2021 07:37:46 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z9sm2574898eju.123.2021.01.07.07.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 07:37:46 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 6/6] dpaa2-mac: remove a comment regarding pause settings
Date:   Thu,  7 Jan 2021 17:36:38 +0200
Message-Id: <20210107153638.753942-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107153638.753942-1-ciorneiioana@gmail.com>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The pause settings are not actually lossy since the MC firmware was does
is to transform back these pause/asym-pause flags into rx/tx pause
enablement status. We are not losing information by this transformation,
thus remove the comment.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 40aa81eb3c4b..f76adbe8c32b 100644
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

