Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A626BC1F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIPGEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:04:53 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64937 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgIPGEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:04:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236292; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=R2IHMLDiWyfY84TcC3501vqXBFM0pmylV+vKcP7lZqw=;
 b=QFVNLUBeb62tczqigfj10oUD1q2aBfSjXKxim/CGnd4CSt05BehhWgmEvIH91sfAifadrf09
 TWGMo5JMcqwnCQwPN5YzLR6VL/7cNMZuNexPsx3Xqsc3kKYIIkkakN2Jqy6mogjzRd/3tGsQ
 CYsawoc0MTybha2rLnhUI7mFNFg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f61aaf754e87432beda1aa5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:04:39
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A24D4C433C8; Wed, 16 Sep 2020 06:04:38 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C97BDC433CA;
        Wed, 16 Sep 2020 06:04:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C97BDC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmsmac: phytbl_lcn: Remove unused variable
 'dot11lcn_gain_tbl_rev1'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910040043.30008-1-yuehaibing@huawei.com>
References: <20200910040043.30008-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916060438.A24D4C433C8@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:04:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c:108:18: warning: ‘dot11lcn_gain_tbl_rev1’ defined but not used [-Wunused-const-variable=]
>  static const u32 dot11lcn_gain_tbl_rev1[] = {
>                   ^~~~~~~~~~~~~~~~~~~~~~
> 
> commit ebcfc66f56a4 ("brcmsmac: phytbl_lcn: Remove unused array 'dot11lcnphytbl_rx_gain_info_rev1'")
> left behind this, remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Already fixed by Lee.

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11766485/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

