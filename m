Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D5926BC0F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 07:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIPF7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 01:59:14 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:25252 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIPF7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 01:59:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600235949; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=C0C37npPCN55+6wEu2tkPUH6VnxnK0eHBljTZq1BIuw=;
 b=N8Da8Jj8qmgDilcLo8OXZUxLb0P2F4Q9GLdihMLedAupv4WGF3sTL/egArXtGIjAJ3vqXUY4
 F7DhL+FAQothRAn0kKaBX8c+fLf8rlrWu9+xlFTFlbEkT17Osw9JRlreSsK6Mbs8ourdMy0U
 lF6YGajcqRdBBrVrv9Kvz67kigM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f61a994cd8edf15d7afc4c9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 05:58:44
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE720C433F0; Wed, 16 Sep 2020 05:58:44 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7B879C433C8;
        Wed, 16 Sep 2020 05:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7B879C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmsmac: phytbl_lcn: Eliminate defined but not used
 'dot11lcn_gain_tbl_rev1'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910140505.1168317-1-yanaijie@huawei.com>
References: <20200910140505.1168317-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yanaijie@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916055844.CE720C433F0@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 05:58:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> This addresses the following gcc warning with "make W=1":
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c:108:18:
> warning: ‘dot11lcn_gain_tbl_rev1’ defined but not used
> [-Wunused-const-variable=]
>   108 | static const u32 dot11lcn_gain_tbl_rev1[] = {
>       |                  ^~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

43c1a70bfa04 brcmsmac: phy_lcn: Remove unused variable 'lcnphy_rx_iqcomp_table_rev0'

-- 
https://patchwork.kernel.org/patch/11769341/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

