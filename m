Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83C92A29D7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgKBLsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgKBLpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:54 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CAFC061A56
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:48 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id x7so14237713wrl.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wO3DZUe4v/2VFg7iK8pRPHz2KfePFYcH1bmhyPk8rVQ=;
        b=mxwSTCHJXfkm9QxIRzdWvvf6dxhtPXbmtDgBcU+bx+1CFUbQ75z70+OO18gi9tXNG5
         eaJtTaZq5qTYfhtyuJc0RLNtgtupNknmAfdDjt+atyOBtvn59pEWTsFT6vubLHaj1dYh
         C+ASzGBSNwAvk0fh0SSB6/okY7o5tWIPnfh9dVWJv3Q5zNJFenOFsn/orWIZ9O7veTd6
         KQ4B8mDGYo4F4bLl16h6/rU0s8oMYRhN8sBGmE7LQzrEoSEUCp/24h+nPu1Y47uBvLq8
         puQWJR0uoMjhogCNgA14CKVYiQONorlvpTu5VneJM1R1oLDnwtGbmNIDt1Xi33+vMsdR
         r8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wO3DZUe4v/2VFg7iK8pRPHz2KfePFYcH1bmhyPk8rVQ=;
        b=OBVeV1MEH/h83L3qiBP+rWbPYDfVT6rtk+sAmv0Dsy+FvShDvIOVlLTJBK8gYvq8V5
         yPTy3hR+T5UPM8TKaTLBt7qIkeHCpEIidK9WKTfAxBjRnJpC7B1B3cixQmUHtSvDarGx
         9wJmQs0I66BrEhFqAHRLBN+Ji6mvCAGkyF0z/Ih5mE5AtrswMJPymYA4itjm5AsCMtQc
         YaSjCjikTQa1Hfd4ImGaGDRRI6RuxOnpRrmvQ8KDEzjr3ly8qvjYHqmFo0xo0m7mLutr
         oRPgtpCOsqpCBya83WCvtoiXoanL3X3zhTFZ5KJHSFwP3lrPddTXQG2dHAwKzZkuPhTo
         KqPg==
X-Gm-Message-State: AOAM531W0jcr3C9sq457ZTbY89bWo+2Cr9mLvdoIawkZt3Y4pA/SxuJx
        Qm3+lxMOFURYo44oHdnXHWYuxQ==
X-Google-Smtp-Source: ABdhPJzkteUP54xGsBZR9fcdINOLUtFH7SmKsmGUmAokF70EMPtdeIkFyyWIkzCECam1TRe43qUO3A==
X-Received: by 2002:adf:fe48:: with SMTP id m8mr19497585wrs.127.1604317547698;
        Mon, 02 Nov 2020 03:45:47 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:47 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Harry Morris <h.morris@cascoda.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 23/30] net: ieee802154: ca8210: Fix incorrectly named function param doc
Date:   Mon,  2 Nov 2020 11:45:05 +0000
Message-Id: <20201102114512.1062724-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ieee802154/ca8210.c:724: warning: Function parameter or member 'cas_ctl' not described in 'ca8210_rx_done'
 drivers/net/ieee802154/ca8210.c:724: warning: Excess function parameter 'cas_ctrl' description in 'ca8210_rx_done'

Cc: Harry Morris <h.morris@cascoda.com>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wpan@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 9b3ab7acad37e..3a2824f24caa8 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -715,7 +715,7 @@ static void ca8210_mlme_reset_worker(struct work_struct *work)
 /**
  * ca8210_rx_done() - Calls various message dispatches responding to a received
  *                    command
- * @cas_ctrl: Pointer to the cas_control object for the relevant spi transfer
+ * @cas_ctl: Pointer to the cas_control object for the relevant spi transfer
  *
  * Presents a received SAP command from the ca8210 to the Cascoda EVBME, test
  * interface and network driver.
-- 
2.25.1

