Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAC746090E
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 19:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbhK1SvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 13:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhK1StX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 13:49:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F416C061574
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 10:46:07 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a18so31755399wrn.6
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 10:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=BvrdRu7CpTK02nLPvxqfVEBas+3apI+lNY84EOP2k/8=;
        b=YsHQCTihtW+tD9wORNOWw1uRuhXNfU/HxJbwRRZD2+hrDDytYCYLMniDvNLc+SmKKC
         CUSe/CmihbmBAhdxlqU8Ppg5tSOG/UHVRTbORXG2gcSWcvMlEZ01nXgeMIMQreGd/3XI
         tU/dAZjHSMyUR0NAzERbFuwMyVM+AKFf0nlq6gtK9xvupnJaj/r6hWyX7J7EgZLqe0zS
         zeyrJfywpz61SvoyebizEdXMUTN8cVeb9k0rjDQhB8qXvi+fwlsXZ/TVVlgtIo0UbUgE
         gcBY0Z6DKNUzCiYUrVaHO3IGeGJ2nceflDvh+T14hEeR3Pss4X4PbheitB2k8f+ecdIn
         BbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=BvrdRu7CpTK02nLPvxqfVEBas+3apI+lNY84EOP2k/8=;
        b=Zw0WZlfsRivBMKfhAw0rnJ5nCfs5Zlk6gsVXph9DhJB4hDCvx3WYjiIFSW0HslfEgX
         25d2xwdddilI5nZ9COdlGQtDVHwKFm475F9Ma7TG6nqELzqWiJHDs8JWj/ldFtWBG1cy
         w41zAaGjHP+Q4GUgKz7/D9Oh/rGNCukju6VvtQy9cE2ExOkz3+9YjuxfrY8uLwSFaSe3
         dHu9mEDiXem+qHWDiQsj4GmFnAoA5SbHiHa/6TZhw20rd81GhH5YluYXYYHGs08z0/KX
         KR04TM5cyJG/bD3FktQMBccOD3GIEnEbpm1SLG6cQnYVvCKXlX2NzWSjJpLbt2vpWDFI
         ua2w==
X-Gm-Message-State: AOAM532gxQPVluSj9oZtmQDjLfzSb5uUYsTluR5OB/7iEKFTXi58mwZn
        d8vdf9oHTvuVEwe2/tPrkBsr8XIUaIg=
X-Google-Smtp-Source: ABdhPJzIR+CZYjXTyOvu+JrlbXO/GL5bJwCevWAIGYmgbwe+Mnw2nokQ2tOaZkjSpgLRJiyTEqDBjw==
X-Received: by 2002:a5d:5244:: with SMTP id k4mr27783562wrc.77.1638125165872;
        Sun, 28 Nov 2021 10:46:05 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:f5fa:c180:5ee3:5045? (p200300ea8f1a0f00f5fac1805ee35045.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:f5fa:c180:5ee3:5045])
        by smtp.googlemail.com with ESMTPSA id az15sm12005237wmb.0.2021.11.28.10.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 10:46:05 -0800 (PST)
Message-ID: <c1bab067-00ba-f6b5-f683-709f1d5b09a9@gmail.com>
Date:   Sun, 28 Nov 2021 19:45:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] stmmac: remove ethtool driver version info
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think there's no benefit in reporting a date from almost 6 yrs ago.
Let ethtool report the default (kernel version) instead.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         | 1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 689f3cdb2..4f5292cad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -10,7 +10,6 @@
 #define __STMMAC_H__
 
 #define STMMAC_RESOURCE_NAME   "stmmaceth"
-#define DRV_MODULE_VERSION	"Jan_2016"
 
 #include <linux/clk.h>
 #include <linux/hrtimer.h>
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index eead45369..164dff5ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -290,7 +290,6 @@ static void stmmac_ethtool_getdrvinfo(struct net_device *dev,
 		strlcpy(info->bus_info, pci_name(priv->plat->pdev),
 			sizeof(info->bus_info));
 	}
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
-- 
2.34.1

