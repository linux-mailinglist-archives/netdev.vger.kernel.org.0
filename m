Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881C6314072
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhBHU1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbhBHU0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:26:55 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94997C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 12:26:14 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id w4so293001wmi.4
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 12:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cu/86eItD50WzpJePQxJrVBt5lX2yUHY46o34jFhPgY=;
        b=rwZcdnU39FTalsHJbf68SZJXX09roq6zBQWXbucJXoLCiG91rdNCn6BaqKkTOK4RD8
         FDcq3OCUfwpkQnmaUPkP8M/4x6+iO0hZXrSIhNle5hSgJ2i8jPP4ZTwaqFIXRgZd/Yf2
         hLvgYLnsDw7Ee/OtV2mlztCANwbtVcCZyB5Odw4wND82IW2rAmlZJ0TqPPa2TfFfImIj
         HusNHHMmtkgaAMvLiqAkL+/xLUX5+rCkvgdLQlYVrSEpig4mbRkdbQrFoXe55gYL1ypb
         ULtl9LDVHUtAbZKjf6Xnt61rfnQFx30giFGR5hUP8JqwmoM132ifFwrvugEL3fyA+i89
         HxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cu/86eItD50WzpJePQxJrVBt5lX2yUHY46o34jFhPgY=;
        b=So2IYy8AWVv6vqAf2FuoY3Hn7SFWtRX7aMPVt3Jre40fZs4rPC0H6xQNwC4xt0wl5T
         sx9JlVfRIgO9olKMb/2q32eXu2seAObVWkekNTy4YL/YxXEs+iORyl8IlH/vgAilgi6h
         nS6vNLZcBY7Kz35LaFToYfZOhdyXWiYtdBaGEwpUsdyJrWHajcKQsufEWZVMp5H1dCqh
         RLHw10kqgbpBic7Oy7VTcNimTqBGPRVEUGlDq6A9vtjKAKJBaU4+nPcxqUaU4Rt97vX1
         Ac4m9d8SKvDUecWDhdZV9KGP6zmJubaULiHO/SgwcrdpYodMfR9uRgw+t3BilC0lHfzh
         TSPQ==
X-Gm-Message-State: AOAM532awPB9jSaQwY46NOLISeamq9dxccEts3dKRT6Pjid9FA5Os+B2
        LZzwY1aWI7RUWUZ+zSraA24=
X-Google-Smtp-Source: ABdhPJx/vFIhRoiNjZH+YXRr8Cz83UhbZFFqacqWYwpq9ICYCANJmjbsFaUHrquqQ91mdGMLmz//WA==
X-Received: by 2002:a7b:c0cf:: with SMTP id s15mr467557wmh.1.1612815971963;
        Mon, 08 Feb 2021 12:26:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:f9e7:a381:9de9:80df? (p200300ea8f1fad00f9e7a3819de980df.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:f9e7:a381:9de9:80df])
        by smtp.googlemail.com with ESMTPSA id c3sm26664847wrr.6.2021.02.08.12.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 12:26:11 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] cxgb4: remove unused vpd_cap_addr
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
References: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
Message-ID: <55c53828-1071-1bdb-6a47-c1f41e3f83d1@gmail.com>
Date:   Mon, 8 Feb 2021 21:26:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is likely that this is a leftover from T3 driver heritage. cxgb4 uses
the PCI core VPD access code that handles detection of VPD capabilities.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
- resend after dropping patches 2 and 3 from the series
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 8e681ce72..314f8d806 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -414,7 +414,6 @@ struct pf_resources {
 };
 
 struct pci_params {
-	unsigned int vpd_cap_addr;
 	unsigned char speed;
 	unsigned char width;
 };
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9f1965c80..6264bc66a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3201,8 +3201,6 @@ static void cxgb4_mgmt_fill_vf_station_mac_addr(struct adapter *adap)
 	int err;
 	u8 *na;
 
-	adap->params.pci.vpd_cap_addr = pci_find_capability(adap->pdev,
-							    PCI_CAP_ID_VPD);
 	err = t4_get_raw_vpd_params(adap, &adap->params.vpd);
 	if (err)
 		return;
-- 
2.30.0



