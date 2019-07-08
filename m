Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1243461B35
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 09:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfGHHZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 03:25:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46652 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfGHHZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 03:25:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so11153613wru.13
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 00:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lCaSEeMFnhbVIobyvJo3DfxumLlxHpD765VDSsYl93w=;
        b=bMUerKkPidvIsaTdoGKiCZ6nso8JTqIny1FjGjNu0sB1MO3e5f+bjJhNdFjN4d++Hu
         Czd2uessXBtSelE0h1r76htvEn7kUx4IqZQSld5npEeem+IVy0CpSLlNVPyE52sSU7D9
         7DZstKMHTppDjUzwIJn7W/vjWYjWW4gQrat/zgJe3PhQ+fDj0a5xXJ1t5YfU5f4BloDM
         qKgJ/OGRlacVbkU5jFgeTqxJrvBNFSzM02rbmkX5+blMSfu10KCkHCzVLAGaJA0PyOUd
         +7HN60/fn7L6XXTIUhq3nBO/jZctTgdsiYGphVQ+Uz6PcG8yGFxcJ8/EtzIRMDu44UlF
         xnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lCaSEeMFnhbVIobyvJo3DfxumLlxHpD765VDSsYl93w=;
        b=BKPOa/efVzxAzMvr78X9d5SYw4/9O+n+s8yqw2iZdSVrQfnjbJAoz700p/JCsee8lB
         LMRa7VmHqWVnPcybcEEHFIVd8GeJ/TXXIt5hVEMcfaJhwuCxbUpofkZqdD7AB7etiUqA
         7U+gqHMPabg17ounTl47iklUkXzSXrnP/exZQswHyrsdW04sXV5qgHNqmhRZIQ3V/V13
         UzovnIDEJqx1E3rV+72UEHWfFAWG3Rd0MndRBVlg3Xg+I2X/OGgbB/jNYoEU729xvylY
         nyErPAtYjotxdyReZbJLyeVb3xA2xcGs8tM82zh5q0Xw9iOz8cWbDo8lRc+aAkckTz8+
         Lljg==
X-Gm-Message-State: APjAAAXI6CXS521MsLPqBlLt3m+GbvTcRDyN2Mlzyi+LwhGSKJ+/HACR
        480xsfWQhU1QngguoZSmyuPjiL5Z1Vo=
X-Google-Smtp-Source: APXvYqzcLrP6sC4fqPFgtEIjiDjZevNUnVAswHQspHzqtme5Bvhp6SLxaMyQoS3iHfqN4oI/QsXu9Q==
X-Received: by 2002:adf:82a8:: with SMTP id 37mr17506848wrc.332.1562570744621;
        Mon, 08 Jul 2019 00:25:44 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id h11sm14288461wro.73.2019.07.08.00.25.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 08 Jul 2019 00:25:43 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] net: netsec: Sync dma for device on buffer allocation
Date:   Mon,  8 Jul 2019 10:25:41 +0300
Message-Id: <1562570741-25108-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cd1973a9215a ("net: netsec: Sync dma for device on buffer allocation")
was merged on it's v1 instead of the v3.
Merge the proper patch version

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f6e261c6a059..460777449cd9 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -743,9 +743,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 	 */
 	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
 	dma_dir = page_pool_get_dma_dir(dring->page_pool);
-	dma_sync_single_for_device(priv->dev,
-				   *dma_handle - NETSEC_RXBUF_HEADROOM,
-				   PAGE_SIZE, dma_dir);
+	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);
 
 	return page_address(page);
 }
-- 
2.20.1

