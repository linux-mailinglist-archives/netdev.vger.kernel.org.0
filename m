Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B326BC1C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIPGEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:04:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64937 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIPGEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:04:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236277; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=VgFebId3auB33K7tE5xP4EvXL7YZHYz+oP3jsKum9Vg=;
 b=i0srInjrc1mD+hLXtO5rLMLrEyEkndFSiPtVxglu5Pwv9Fx+NyY/EaVM6FgGExjeQCXu558L
 Ou7JjuQLxkKfjfrYbETQkt3hpPdgYd2TAjVWzgai7Tx437Xn9mNurOhoEkf7C+XsdLIWB60v
 acBy8Z3L/YO4Dx2aorcPttHacA4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f61aaca238e1efa370a7c1a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:03:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 089B8C433CA; Wed, 16 Sep 2020 06:03:54 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8DF7C433CA;
        Wed, 16 Sep 2020 06:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8DF7C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmsmac: phy_lcn: Remove unused variable
 lcnphy_rx_iqcomp_table_rev0
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910035600.21736-1-yuehaibing@huawei.com>
References: <20200910035600.21736-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <lee.jones@linaro.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916060354.089B8C433CA@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:03:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:361:25: warning: ‘lcnphy_rx_iqcomp_table_rev0’ defined but not used [-Wunused-const-variable=]
>  struct lcnphy_rx_iqcomp lcnphy_rx_iqcomp_table_rev0[] = {
>                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> commit 38c95e0258a0 ("brcmsmac: phy_lcn: Remove a bunch of unused variables")
> left behind this, remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Already fixed by Lee

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11766483/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

