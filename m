Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43A326BC0B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 07:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIPF6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 01:58:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48712 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgIPF6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 01:58:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600235889; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=xc8sLUYV3RCHabsAMS798ojdl3tDguhubfPkXc9X9Qk=;
 b=nFAj/DP/QaygU51FSXesc1Hr/fHjXDBaaMcaa9RYN16oBnI2T20je6tgMTiAH/8qzwRXVUby
 oVxLw/ezDVJj3qOYE2U/GTykNSu7pUDTZoQ1iXWp5iOxZgCHI+MB6jbET252S4ypYtex9+3Q
 SBMgBypwNk36oA1hVIfV2cCfjVg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f61a9711a08b594a9f26b5c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 05:58:09
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03E0EC433FE; Wed, 16 Sep 2020 05:58:09 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C19CAC433CA;
        Wed, 16 Sep 2020 05:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C19CAC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 28/29] brcmsmac: phytbl_lcn: Remove unused array
 'dot11lcn_gain_tbl_rev1'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-29-lee.jones@linaro.org>
References: <20200910065431.657636-29-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916055809.03E0EC433FE@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 05:58:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c:108:18: warning: unused variable 'dot11lcn_gain_tbl_rev1' [-Wunused-const-variable]
>  static const u32 dot11lcn_gain_tbl_rev1[] = {
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

2 patches applied to wireless-drivers-next.git, thanks.

f75738a09f59 brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
8f56b86d2ebe brcmsmac: phy_lcn: Remove unused variable 'lcnphy_rx_iqcomp_table_rev0'

-- 
https://patchwork.kernel.org/patch/11766809/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

