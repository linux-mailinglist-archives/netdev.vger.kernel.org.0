Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BF1273B9F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgIVHTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:19:39 -0400
Received: from z5.mailgun.us ([104.130.96.5]:32438 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbgIVHTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 03:19:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600759178; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=e1niNsfroTOYWV2Z9XJLXBOL64oYjfMu3tY9jBAHDSs=;
 b=V2OfgVPhuJ4tkTRGd2V289aRNjTaIemmr3/+68WxDxR8I4/QFFYZImc6LYQr9lhpT8dr6JmH
 mktnezaVhgRzq2Uc9JbtofvXFRabcn4ygBL8DSsLJte72HVDGcqhhPDPSXxUrlphRT3e2cZy
 600WaEp5VgZCpsh/MFg8l8sIRHY=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f69a55e0049ea5816db24ef (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Sep 2020 07:18:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 333EDC43382; Tue, 22 Sep 2020 07:18:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 341A3C433CB;
        Tue, 22 Sep 2020 07:18:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 341A3C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8723be: use true,false for bool variable
 large_cfo_hit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200919074437.3459305-1-yanaijie@huawei.com>
References: <20200919074437.3459305-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200922071854.333EDC43382@smtp.codeaurora.org>
Date:   Tue, 22 Sep 2020 07:18:54 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> This addresses the following coccinelle warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:1155:27-47: WARNING:
> Comparison of 0/1 to bool variable
> drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:1156:3-23: WARNING:
> Assignment of 0/1 to bool variable
> drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:1159:3-23: WARNING:
> Assignment of 0/1 to bool variable
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

dd7a3a331f5d rtlwifi: rtl8723be: use true,false for bool variable large_cfo_hit

-- 
https://patchwork.kernel.org/patch/11786683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

