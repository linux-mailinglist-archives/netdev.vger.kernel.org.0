Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6D519F7D1
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgDFOWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:22:25 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:12839 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728334AbgDFOWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:22:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586182944; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2Vn7X1cSpiflRFN1VreX4R0Trwz919PTZIn7s9PwGt0=;
 b=ADGM7KyII0yoAwp+DbwGAqKRb2rUjeB//k8tww9BGM0UmngDVnHKdozjSZ4HSZd4+cVWYPU1
 n2Ui9xn9YeaDwIjTpzTjO1JG8NFrocGGWVsgi+Gri/QPCMGs2zpiD5pSs4TW6s973LhTb1xo
 fxlnkwBgx7/TXKAg8P2tZmZjBMc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b3b0f.7f31281d6618-smtp-out-n03;
 Mon, 06 Apr 2020 14:22:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB6BFC43636; Mon,  6 Apr 2020 14:22:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 206BBC433F2;
        Mon,  6 Apr 2020 14:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 206BBC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix compiler warnings without CONFIG_THERMAL
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200403083414.31392-1-yuehaibing@huawei.com>
References: <20200403083414.31392-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <pradeepc@codeaurora.org>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200406142207.CB6BFC43636@smtp.codeaurora.org>
Date:   Mon,  6 Apr 2020 14:22:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/ath/ath11k/thermal.h:45:1:
>  warning: no return statement in function returning non-void [-Wreturn-type]
> drivers/net/wireless/ath/ath11k/core.c:416:28: error:
>  passing argument 1 of 'ath11k_thermal_unregister' from incompatible pointer type [-Werror=incompatible-pointer-types]
> 
> Add missing return 0 in ath11k_thermal_set_throttling,
> and fix ath11k_thermal_unregister param type.
> 
> Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers.git, thanks.

c9be1a642a7b ath11k: fix compiler warnings without CONFIG_THERMAL

-- 
https://patchwork.kernel.org/patch/11472105/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
