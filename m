Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2C3A7B3D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfIDGKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:10:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDGKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:10:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D482D6119D; Wed,  4 Sep 2019 06:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567577404;
        bh=F5sXdp2HFRFRyPdk3dQOYFx1vtSHFJAa+zl8mZ6v0h4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=htTJrfdL5OwahU2sPxDzyDGV1iMmr/gZDBwkllEEJXHHe65vm2SuHAIOhfaqnstmy
         6/FItbcyATdK+zkAcLN1tVr/mthZqDdocDAE+hOfNsE+9HueUbux0Jn+uQoMGo/krS
         EffivWzjqWW1UhnSuqgL/RA4iyZ3NJc2+Xu65nTk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B36460C72;
        Wed,  4 Sep 2019 06:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567577403;
        bh=F5sXdp2HFRFRyPdk3dQOYFx1vtSHFJAa+zl8mZ6v0h4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nJ/czposdCMZLkxI+okMPpLMVuHBf8ktvL36/tn0cjGJ8I1Vgam0SlnDZ8utv2HCZ
         gqLDeXrI3rXsnih23LLPDT/xrcK9K54wpM5GR9zjwcPGnAZBj/hR9X/6kyZWaq22Z6
         Sf/qV/A2YDPj1rJg0zwViE3VDq/wnjFXqwVQTI4Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B36460C72
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] carl9170: remove set but not used variable 'udev'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190702141207.47552-1-yuehaibing@huawei.com>
References: <20190702141207.47552-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <chunkeey@googlemail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190904061004.D482D6119D@smtp.codeaurora.org>
Date:   Wed,  4 Sep 2019 06:10:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/carl9170/usb.c: In function carl9170_usb_disconnect:
> drivers/net/wireless/ath/carl9170/usb.c:1110:21:
>  warning: variable udev set but not used [-Wunused-but-set-variable]
> 
> It is not use since commit feb09b293327 ("carl9170:
> fix misuse of device driver API")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

68092f9cf932 carl9170: remove set but not used variable 'udev'

-- 
https://patchwork.kernel.org/patch/11027909/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

