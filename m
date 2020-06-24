Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9EF2073A9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390895AbgFXMpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389802AbgFXMpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 08:45:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC33BC061573;
        Wed, 24 Jun 2020 05:45:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a1so2274616ejg.12;
        Wed, 24 Jun 2020 05:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0LUd1INo56iKCsw5DicOzPD1VjG9HiDFCnhmfdUAl/A=;
        b=L4jNppFe+m/IT/N+Em2WAJSwzW0sY6/ZtVYSfY8RFkFL3dJZdjPO63g6+fKgXjyFgE
         LGG5o+Wmw/r5kksZQ/mkX99UMZ1duZib8TOpaVKw9xMEx1wKjCWCNOhdrAdPIDJ1v/d2
         scuOtNLb9U4wiJst+2UymjQRHK80nS5IFLmxNwuZneiOjoF6YsHg7t5KLHRC7PBZpa1P
         6kXWMmX8N3zEXzSPHA3qC7UK6CMAS1AesUYzAy+TzjHf429PQY+D7R9Kh3BwxT/qAOhF
         AwKsKvvPMyJZ2EgwPP3V2lVKTpORinrdZLoBJOhZ04N3QggPOHNcbkwnGBxkWpL5WbVi
         C50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0LUd1INo56iKCsw5DicOzPD1VjG9HiDFCnhmfdUAl/A=;
        b=qp80e3XTbQ41SvdXobYWeWcXpUKBpZ1h24G0bvbadwX8o3/tyO6jRXmS1vvYmxV9lP
         b1pE8SogUB0HL/zKfB22sL0ENJ9BihrhNLLHbDmSmko+wzciVN7zwEHSn8wy9mdhIO05
         XjfDmrUvED2CWd9H6zJUdNWsb+6aAf/oLTxtYbtN7b7wDTECHtbeOMbKorFCR9SWMj9N
         A89VUu9GEmvDfMu+W+onpHjO9zcOIBinxk2fjoXj8YqFQP59O+1zothJwBdkP8sRu+iN
         IOc4G0ZvaPbAMH1ZgGVZR+CbwNCS+/Os79mk7AM/D0cLAI7YtgNpRDQdXb8CQ8gS5VkV
         qMQg==
X-Gm-Message-State: AOAM530OTMblJN9dFAdw2t8+9hsZgyhNoQeQFrG8zik987aEU2Xrv+C0
        YaeXsQmpMhoZOT1rKhLx/3+wabhR
X-Google-Smtp-Source: ABdhPJyGP8cyKXshNYTdtxp/lUkqB90Mcabefvc7A4g7YNomHk1D7ixN0ldzesQSJjlxmvvdt7o4UA==
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr25988916ejj.155.1593002729570;
        Wed, 24 Jun 2020 05:45:29 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o14sm5183613eja.121.2020.06.24.05.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 05:45:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org
Cc:     madalin.bucur@oss.nxp.com, camelia.groza@nxp.com,
        joakim.tjernlund@infinera.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 stable-5.4.y] Revert "dpaa_eth: fix usage as DSA master, try 3"
Date:   Wed, 24 Jun 2020 15:45:17 +0300
Message-Id: <20200624124517.3212326-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 40a904b1c2e57b22dd002dfce73688871cb0bac8.

The patch is not wrong, but the Fixes: tag is. It should have been:

	Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")

which means that it's fixing a commit which was introduced in:

git tag --contains 060ad66f97954
v5.5

which then means it should have not been backported to linux-5.4.y,
where things _were_ working and now they're not.

Reported-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v1:
Adjusted the commit message from linux-4.19.y to linux-5.4.y

Changes in v2:
Fixed the sha1sum of the reverted commit.

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6683409fbd4a..4b21ae27a9fd 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2796,7 +2796,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev->parent);
+	SET_NETDEV_DEV(net_dev, dev);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);
-- 
2.25.1

