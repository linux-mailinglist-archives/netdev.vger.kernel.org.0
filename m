Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56293E79DC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbfJ1UQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:16:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35231 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfJ1UQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:16:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id x6so2170817pln.2;
        Mon, 28 Oct 2019 13:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=fEA7ooZYsW9f2zsWHFTpKrN6BsLkB7vzBQpHQTnjp1g=;
        b=cQc7oeQ5ZHHkhhNd/b2s2mMhmIWL4si/YBpDjg0ls7NS0kw4C5qbe9Xg4xuM9GBEHZ
         tNqxWL7jNPAXcp+KB92ZOFFyvPVMHyOYAXWBOXLw0lHlAFNSvcraloKaljVwXmicI5o8
         IszvneXrtDv0PaXxKU2wmu4Il5q/JwPZWmI//YrTlSEF9WCqNJfMmL14JxINgWdS2bEc
         0iJjNTYuxqn29HXTZiQZPq6wv8wFZlNuQljZ5gSQCg2L48elxhjPYrj+qWQMGaJ6d2cI
         lLndTXQncj3I5ea34BbS42PWjvloHX69xQP0110TB/DkBOazZBGKkh4UywxgkhL7BsAa
         GWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=fEA7ooZYsW9f2zsWHFTpKrN6BsLkB7vzBQpHQTnjp1g=;
        b=MDXJm4eIeXORxJEH1waTnZXYVLcDB962GSV8IjhFF76mGtZDszwPdfqPj+yb0WTT32
         045rHH8SU9X0Q1CIF0OGF9Ctyg4Tvjt5zm0DjbQi+H5KwbeZ/PN07L17dB+p07vLcOD7
         ojSDnlKbpmcQsO/0pCLgzOkHPrkunmDDFrHlLdk6WxlIGBH6xH9Lg9sYaT1b+7KJhfLT
         gfCFhBOrsUQl0m1SFHECJpH+j7lrrk6bAiAQuKHyc2W2HFNjo8pctIQzPgMnIDOofnuR
         CKHZik+Sx+itRqnCMrpKld+kniVTs4fXtRrXFgYGARDyalO1G3A9aRwSGsSOQtz/N8/E
         BzNQ==
X-Gm-Message-State: APjAAAXJLgV0wX+83FOUl9EQikCoPAx/XZpJkeI0fQ0z2lWcbseLjMiz
        xbBxZRRlsuIHoI6BfTnJ4U0=
X-Google-Smtp-Source: APXvYqwL6B1acZKmR+QwXEDv5axLbGxnYEyX8uPTqAO+ePZ8S2BQvgEVHFOeOmUJoeRmXexCmdjdAw==
X-Received: by 2002:a17:902:b489:: with SMTP id y9mr21206837plr.9.1572293803186;
        Mon, 28 Oct 2019 13:16:43 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id i187sm12988692pfc.177.2019.10.28.13.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:16:42 -0700 (PDT)
Date:   Tue, 29 Oct 2019 01:46:35 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     michael.chan@broadcom.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] broadcom: bnxt: Fix use true/false for bool
Message-ID: <20191028201634.GA29069@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use true/false for bool type in bnxt_timer function.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4a8cf620a0c..8cdf71f8824d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10004,7 +10004,7 @@ static void bnxt_timer(struct timer_list *t)
 
 	if (bp->link_info.phy_retry) {
 		if (time_after(jiffies, bp->link_info.phy_retry_expires)) {
-			bp->link_info.phy_retry = 0;
+			bp->link_info.phy_retry = false;
 			netdev_warn(bp->dev, "failed to update phy settings after maximum retries.\n");
 		} else {
 			set_bit(BNXT_UPDATE_PHY_SP_EVENT, &bp->sp_event);
-- 
2.20.1

