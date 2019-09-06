Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387D6ABD38
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395055AbfIFQB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35723 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395023AbfIFQBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id g7so7183036wrx.2
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dg6/UozT6g/26doWc/K024QVieT90xHL6OMYKkwJKh0=;
        b=WaR/d3Goayoi4rNGf5gI/jshLByXDh3k8po/HkSuayumo28BWxG12eT3UOHHsjsBlD
         RAfjPBoOOdubLsSLml0v1NiENXnDIpU9uekbj7h3NIzIedzSfqU8rtiky3PfXO2idgww
         6R07ApbQtibYlwMdTQO0tlN+FYnu5WRl19C195oz86r1coHkmX46cYwvOQQ3q+JtbkwH
         wKQsB++6jYg4UE2NPoLgBR8V4cCu1A28mCyt3f614NRfucsS2ggfLJBqYhq89ViS/wTf
         0iytw1mWP10/SSEruMqX2TJF0xe60fFpg+1iXkyU2XZF4ZZYnKOuyCXwqDVED4hVndCS
         pu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dg6/UozT6g/26doWc/K024QVieT90xHL6OMYKkwJKh0=;
        b=AdxKoB73UX5J1vLsrzCD04RNfuSvPFn45LLFodyiD02+jnv8GCmoY3nfxasLhOUBIK
         74cTy8P6VVhpVxuWfjeJXGn+4yjUaRYTe8OUXp4dSwNi4ZZ/YAuvVizjLDrCIVG0iIO6
         eUSV+A3HZRMXdm+WRdSopxSvsLhEMu+IzzdyqWTqMHVX0/9oOC9j+8LcXsKrq3O6oeKp
         mw54DnQajd9eE1n8QqskoS84mPTEsUXKGlCgLzeCvV1Gryc6MPepngJFHcEvIhnMGFt6
         5cLCa61PAKI/ulqYjhu9AmvtuUaXmVrgX7zCyHSxHlkNNNmDP34Lu+GIYybLbJL+2z2F
         +IFg==
X-Gm-Message-State: APjAAAVABhQtYp9LO80Z88zbRZizRqj4gln20QOmq33HjdKCAiFyWgTt
        lYa2/+QFp3U+v7I6GPPz5cooWQ==
X-Google-Smtp-Source: APXvYqx/HYtkLbZEh1DJvcHEe6Q6kjB3shDeIYKXQ+mhQt7KsgcrTqXfCMQVmTQzKS+EKNI6j8vIDQ==
X-Received: by 2002:adf:f282:: with SMTP id k2mr7693389wro.38.1567785682313;
        Fri, 06 Sep 2019 09:01:22 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:21 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 10/11] kdoc: fix nfp_fw_load documentation
Date:   Fri,  6 Sep 2019 18:01:00 +0200
Message-Id: <20190906160101.14866-11-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Fixed the incorrect prefix for the 'nfp_fw_load' function.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 0d8649024505..c8ad9b701c3e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -458,7 +458,7 @@ nfp_get_fw_policy_value(struct pci_dev *pdev, struct nfp_nsp *nsp,
 }
 
 /**
- * nfp_net_fw_load() - Load the firmware image
+ * nfp_fw_load() - Load the firmware image
  * @pdev:       PCI Device structure
  * @pf:		NFP PF Device structure
  * @nsp:	NFP SP handle
-- 
2.11.0

