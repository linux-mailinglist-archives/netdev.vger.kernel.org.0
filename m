Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFD22448EB
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgHNLkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgHNLj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:39:59 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4717AC061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:59 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a14so8075291wra.5
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pTidTxM2W7rg3RCDPQVi6+bnqBimLuMVRDwTHQpG6MI=;
        b=sTJJo5Ao9MoWGnV5QCX1gfI+xXTHpIhbz2b7TURG/31tpUZXShHoedki9o0ukyMbcT
         WeQin7wucUIH/cENlQCAmqxLxnXtoWT3shSNCql8IQTAlO+WEVakfIOAvmd4+/nrgFIl
         mPRNqGwMafnkybiB5SOiDMAHnN9corypiRFiy4AQaqkwNH2/YpYQAReihfCZLPb0GV2K
         tZzhFMv/4jttwAc6jx3p69I3ekCKLngRwL9X2sssocNoNsQBmtUNA05oUBUBoACkZHy0
         McwdKNFkUFSlyoPzcvhNuOmZ8tbPropQ+tGinR3r4c07PZXzsigSPMHN8fPybCslnLQ+
         /0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pTidTxM2W7rg3RCDPQVi6+bnqBimLuMVRDwTHQpG6MI=;
        b=kI16VEY7gzTx6AohF4TVNMI3l19m0ImTeMJuIg/J6qxckKm4Y31yscGejlGTRdUi7p
         bOJitH05ccxrZ3+pKLDxKTWsGGf8pQocsNh0qkJKScucl0X/zUPYfnSkURbuD3J1QdQ8
         Dmf2udhZhBegKL0pXvsGo4xyhKP7y0Sxx/2Z9m37dswQUZttWTbcdfzIJttwUoQr8rku
         KSJNkWMxLgYKlPA52Brqc+4PqWGYQAtR4KGoTkiifI27ZQpURgUbiJhS6B3imy5A6Wkm
         WUor4SKwtLuIrRZgmHbcfhCENGAL0U9BPSYnnw5exXqX09fBvSxKRsWqk9ZTwom7jvsX
         s26A==
X-Gm-Message-State: AOAM530lapqBl8bC4IohI4UR0lRW2AYwZV0r57Wxd5HbeEN1JyC2SD5G
        mW/w9E+CCmQ+OhNwERdIX7DdhQ==
X-Google-Smtp-Source: ABdhPJzf2CUoe+r24OZQp0WRqevqIU05NtR3yqlbWBijFHrDWUmeueOOtpTFxEruugLoxyFvD9s9kQ==
X-Received: by 2002:adf:91a1:: with SMTP id 30mr2554293wri.29.1597405198037;
        Fri, 14 Aug 2020 04:39:58 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mike McLagan <mike.mclagan@linux.org>, netdev@vger.kernel.org
Subject: [PATCH 10/30] net: wan: dlci: Remove set but not used variable 'err'
Date:   Fri, 14 Aug 2020 12:39:13 +0100
Message-Id: <20200814113933.1903438-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wan/dlci.c: In function ‘dlci_close’:
 drivers/net/wan/dlci.c:298:8: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Mike McLagan <mike.mclagan@linux.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wan/dlci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 7bcee41905cfb..3ca4daf633897 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -295,14 +295,13 @@ static int dlci_close(struct net_device *dev)
 {
 	struct dlci_local	*dlp;
 	struct frad_local	*flp;
-	int			err;
 
 	netif_stop_queue(dev);
 
 	dlp = netdev_priv(dev);
 
 	flp = netdev_priv(dlp->slave);
-	err = (*flp->deactivate)(dlp->slave, dev);
+	(*flp->deactivate)(dlp->slave, dev);
 
 	return 0;
 }
-- 
2.25.1

