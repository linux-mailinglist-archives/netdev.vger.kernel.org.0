Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DF226BC45
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgIPGLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:11:35 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:60789 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726128AbgIPGLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:11:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236692; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=30Wxt5LINfxOWQh4oSmMSj1uCTms/++Sl9cbHSypEuQ=;
 b=AIozxk0Ob3r5DwI3Tn9u7kYtVoG4ttopdEbI6G+5N2Sq5inGMnJ1vLlWt6+leioEl/L+9U2J
 QY7bwVsbvH1fhS62+0WneNnBwcDu6oDyfC3QOAgDraeCqwFdHME7L9NuqybMZt8+uhmmoXZh
 bsJqa/C8P4h8VCmnM8hs65GKZl0=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f61ac94698ee477d1bda454 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:11:32
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E9DBFC433C8; Wed, 16 Sep 2020 06:11:31 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 518ABC433CA;
        Wed, 16 Sep 2020 06:11:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 518ABC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next 1/3] rtlwifi: rtl8188ee: fix comparison pointer to
 bool
 warning in phy.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910135917.143723-2-zhengbin13@huawei.com>
References: <20200910135917.143723-2-zhengbin13@huawei.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916061131.E9DBFC433C8@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:11:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Bin <zhengbin13@huawei.com> wrote:

> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1584:14-18: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

3 patches applied to wireless-drivers-next.git, thanks.

6996e70f1fe4 rtlwifi: rtl8188ee: fix comparison pointer to bool warning in phy.c
f40adfd07418 rtlwifi: rtl8188ee: fix comparison pointer to bool warning in trx.c
916c3b969d21 rtlwifi: rtl8188ee: fix comparison pointer to bool warning in hw.c

-- 
https://patchwork.kernel.org/patch/11769245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

