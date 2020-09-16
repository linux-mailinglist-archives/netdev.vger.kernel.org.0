Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3526BC29
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIPGHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:07:52 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48380 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgIPGHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:07:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236472; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=PjDPPtDXwEfTn0V8emtHYytm7C14QTX7ob6r1/GtgjU=;
 b=GUgyy6LIdGKcdQyaOoWdpqm64uerHAuPVEsQXw+iLaPZkyy8Q6tHO8caxoJR/20x/UN11QEZ
 I/5PzJfEGoJuLQJQEjS00xokf+uNDrX8ErWGxta1pHcYhkcdsjc5GdFkDc00qWBAg6w2J65/
 yBicBBy7t1UMXU4wlLsDipNOLeE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f61ab75698ee477d1bbcf51 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:06:45
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9232EC433F1; Wed, 16 Sep 2020 06:06:45 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93CE2C433C8;
        Wed, 16 Sep 2020 06:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 93CE2C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmsmac: phy_lcn: Eliminate defined but not used
 'lcnphy_rx_iqcomp_table_rev0'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910140455.1168174-1-yanaijie@huawei.com>
References: <20200910140455.1168174-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <lee.jones@linaro.org>, <yanaijie@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916060645.9232EC433F1@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:06:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> This addresses the following gcc warning with "make W=1":
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:361:25:
> warning: ‘lcnphy_rx_iqcomp_table_rev0’ defined but not used
> [-Wunused-const-variable=]
>   361 | struct lcnphy_rx_iqcomp lcnphy_rx_iqcomp_table_rev0[] = {
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Already fixed.

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11769331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

