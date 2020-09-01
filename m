Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5AD258B35
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIAJPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:15:44 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:39289 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIAJPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:15:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598951743; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=gKLR5YQP1vuukFEnkzMGvPLi7tNNyUCzrmI4vA0NnFg=;
 b=uNIBFhx18GoAsXKrxdFZ8F6jJnuQ2hCkSyp4n53N6TfxmsbrIH0ujxLLwHj9YYGxDmA1xDsq
 jEn0fmZDLdNCVJ3/aDsceB9AKlBHqhSLRSG5cFEahOdv9OUirgR+YTbzmhDZkwW6z48DgOR0
 piZ78914q05K05JPE8jHsl7bs1Y=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f4e113d4ba82a82fd7fceec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:15:41
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3974FC433C6; Tue,  1 Sep 2020 09:15:41 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85550C433CA;
        Tue,  1 Sep 2020 09:15:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85550C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/32] wireless: marvell: mwifiex: sdio: Move 'static
 const
 struct's into their own header file
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200821071644.109970-2-lee.jones@linaro.org>
References: <20200821071644.109970-2-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901091541.3974FC433C6@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:15:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Only include these tables in the 1 source file they are used.
> 
> Fixes hundreds of W=1 warnings!
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/net/wireless/marvell/mwifiex/main.h:59,
>  from drivers/net/wireless/marvell/mwifiex/main.c:22:
>  drivers/net/wireless/marvell/mwifiex/sdio.h:705:41: warning: ‘mwifiex_sdio_sd8801’ defined but not used [-Wunused-const-variable=]
>  705 | static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
>  | ^~~~~~~~~~~~~~~~~~~
> 
>  NB: There were 100's of these - snipped for brevity.
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Cc: Xinming Hu <huxinming820@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I don't think static const variables should be in a .h file. Wouldn't
sdio.c be the right place for these? At least from a quick look I got
that impression.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11728301/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

