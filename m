Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA11A258FEB
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgIAOLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:11:16 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:16711 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728158AbgIANQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:16:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598966179; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=IxhaiARGy6S7cCA9/XiPB7/BjFCpZnTIv0Ugb7vuLHY=;
 b=jjalySsxQCu07wovUF2z/It2Vi1okjDOmcDGI0A32Ufr5PgkYadxCYYOHnCbkjs8uZ7gZd+6
 FgZ/TXjosoKBiveUVArYH0wzkP8jkvNAnoH4bcAiFTDy9oHkWnezaCAdYT5xAHWDTam3IR0Z
 3HFThDh//iANMEb1cR6y0zf35/Y=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f4e49704f13e63f040dd7a5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 13:15:28
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2FCE3C43391; Tue,  1 Sep 2020 13:15:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83E78C433C9;
        Tue,  1 Sep 2020 13:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 83E78C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [11/30] zd1211rw: zd_chip: Correct misspelled function argument
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200826093401.1458456-12-lee.jones@linaro.org>
References: <20200826093401.1458456-12-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901131528.2FCE3C43391@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 13:15:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1385: warning: Function parameter or member 'status' not described in 'zd_rx_rate'
>  drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1385: warning: Excess function parameter 'rx_status' description in 'zd_rx_rate'
> 
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

9 patches applied to wireless-drivers-next.git, thanks.

bb4b2c8ba39d zd1211rw: zd_chip: Correct misspelled function argument
e769ab5359cb brcmfmac: fwsignal: Finish documenting 'brcmf_fws_mac_descriptor'
b95451e02e1c wlcore: debugfs: Remove unused variable 'res'
64403dc35cb7 rsi: rsi_91x_sdio: Fix a few kernel-doc related issues
8cea7f1c8813 hostap: Remove unused variable 'fc'
2307d0bc9d8b wl3501_cs: Fix a bunch of formatting issues related to function docs
0e25262bc367 rtw88: debug: Remove unused variables 'val'
73ffcd404a7e rsi: rsi_91x_sdio_ops: File headers are not good kernel-doc candidates
2d4a48d1f92b prism54: isl_ioctl: Remove unused variable 'j'

-- 
https://patchwork.kernel.org/patch/11737731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

