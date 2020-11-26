Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C632C55EB
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390525AbgKZNjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390368AbgKZNjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:39:05 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB09C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:04 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id g14so2148400wrm.13
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=asMRiFXnX8bIejsGLdsKd//d7tf76QwNOuS+l2qSTCE=;
        b=zW7MMznPCETTHz4zROspqv2du3yYqsKX1Nfw0azktaP1HEVWUt3rMdVPlaq6yXMbas
         3yhr+cEAE3vWmkLa004JLlNztUcdiKLbHZX/WXD8OecqJaKU6rRdTr6KDwoTkxL3CNVO
         Hooa3JFwUyXKWcKVkVSPkM/see7T/+iT4C7uYPUhc1sKNCz8imewjTl8rkB6saX5y1DG
         xng30XCWW/ZPK5fflNXYYEHQxD8AmjRPSeOnBXjtkN6b0bd3oAHshuPsqWmy2fY+rpli
         lvsH3xtIxn2vT0ihIIc5DmsRf+yHHQeNPDHo2BOF78pRHtZqFTwoKteElv+IdzaQeBoW
         CHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asMRiFXnX8bIejsGLdsKd//d7tf76QwNOuS+l2qSTCE=;
        b=KUKbffCbb1O025dQSr5bpr/PgE/ehmKOHcs7zuxxnpoSYpnj16BZ+jeH+6GzAqncuH
         hTfsa/BhhZyTtmzWCpgbcl+gPDcDuxGlflGOhDZWLamXlN+4W5Md5EX6Hi2vb/J8UQmZ
         2jE4Xxea/GH7zsDxSPE8zGi75CLov/mt3PwaemfIVRUVGBTpQXq/z/62hAGlU3qLobqp
         pWXDqMWrmR/txxG9XwcTqdXPjvBXHurS7XsKGGtIEOCbVS1qmdmDBehnXbHJrLwj9wXp
         p9bSSvs1nnI12XpDBUIBGzxlGBN/0fe9ZVD+g6PX6L8BGBQrpFNpltfYfZpnj6rsLkgL
         o6aw==
X-Gm-Message-State: AOAM533FzJTXWIwfnuKwi2CV/pGvAVdho5K14fJXGRpu3n8EZFLr04eO
        zBeulGjvgr7vCaEMY8CuLJNuHTcLjT85b1Ce
X-Google-Smtp-Source: ABdhPJzl4D8fEEpQ2tRn+/Qdw0W+XFDT2YGhmLvOlXBtJXOVwoqzejps9snDILVpDq6S1uQGjbdsEA==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr3778199wrp.27.1606397943010;
        Thu, 26 Nov 2020 05:39:03 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id s133sm7035825wmf.38.2020.11.26.05.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:39:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org
Subject: [PATCH 4/8] net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en' parameter
Date:   Thu, 26 Nov 2020 13:38:49 +0000
Message-Id: <20201126133853.3213268-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133853.3213268-1-lee.jones@linaro.org>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/ti/am65-cpts.c:736: warning: Function parameter or member 'en' not described in 'am65_cpts_rx_enable'
 drivers/net/ethernet/ti/am65-cpts.c:736: warning: Excess function parameter 'skb' description in 'am65_cpts_rx_enable'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 5dc60ecabe561..9caaae79fc957 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -727,7 +727,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp)
 /**
  * am65_cpts_rx_enable - enable rx timestamping
  * @cpts: cpts handle
- * @skb: packet
+ * @en: enable
  *
  * This functions enables rx packets timestamping. The CPTS can timestamp all
  * rx packets.
-- 
2.25.1

