Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9B27BF6E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgI2Ia7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:30:59 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:10312 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbgI2Ia6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 04:30:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601368257; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=cgyRCysa2FWaoTRZSuzlCiwZbNxWNk1GU5BpMdq2hOA=;
 b=eBVA5KhzhE9GiDoSxW0Z51SfshtPMu0HKpqncZqOpwZAPUov89IkzW6sLc4nHLholfO2GQP8
 iIadfLIvVSsvg41AiYf0s4eDCPaApMJwzae5UrIX25xjwMiI4QQZee4Tkrbwho+dEtQl5Plu
 w14LcMuB6zirO9MX9g77MzYm5kY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f72f0c1aada82eaa45e8e6e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 08:30:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E664FC433C8; Tue, 29 Sep 2020 08:30:56 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7F61C433CA;
        Tue, 29 Sep 2020 08:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A7F61C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] ath9k: Remove set but not used variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1600831531-8573-1-git-send-email-liheng40@huawei.com>
References: <1600831531-8573-1-git-send-email-liheng40@huawei.com>
To:     Li Heng <liheng40@huawei.com>
Cc:     <ath9k-devel@qca.qualcomm.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200929083056.E664FC433C8@smtp.codeaurora.org>
Date:   Tue, 29 Sep 2020 08:30:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Heng <liheng40@huawei.com> wrote:

> This addresses the following gcc warning with "make W=1":
> 
> drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1331:18: warning:
> ‘ar9580_1p0_pcie_phy_clkreq_enable_L1’ defined but not used [-Wunused-const-variable=]
> 
> drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1338:18: warning:
> ‘ar9580_1p0_pcie_phy_clkreq_disable_L1’ defined but not used [-Wunused-const-variable=]
> 
> drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1345:18: warning:
> ‘ar9580_1p0_pcie_phy_pll_on_clkreq’ defined but not used [-Wunused-const-variable=]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Li Heng <liheng40@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e2f1ceb81758 ath9k: Remove set but not used variable

-- 
https://patchwork.kernel.org/patch/11793845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

