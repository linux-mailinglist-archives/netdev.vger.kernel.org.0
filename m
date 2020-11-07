Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED6D2AA332
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 09:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgKGIHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 03:07:47 -0500
Received: from z5.mailgun.us ([104.130.96.5]:13211 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgKGIHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 03:07:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604736466; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=T1xewMLt1qGyKJOkHAAwUbdE9UigdO+tyozGpC781sE=;
 b=d5gcujGqM15YpIW4rERokIQHaCgHn1WnDlm8E/by0THLchrk/Fgexa0fuSdDhc0vUcnEBUkU
 BMILSUXxdhyjvu8CpoOtRldeKrINkmwW6Yw8x3Wi40sklf1swm9hvxr5WZI/tVCzvAQfIhVX
 B09A7KfD4SMfmWZ1FbDeTEPfKx0=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fa655aa82aad55dcb821612 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 08:07:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6B146C433C8; Sat,  7 Nov 2020 08:07:06 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E9C0EC433C8;
        Sat,  7 Nov 2020 08:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E9C0EC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 19/41] ath: regd: Provide description for
 ath_reg_apply_ir_flags's 'reg' param
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201102112410.1049272-20-lee.jones@linaro.org>
References: <20201102112410.1049272-20-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107080706.6B146C433C8@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 08:07:06 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/regd.c:378: warning: Function parameter or member 'reg' not described in 'ath_reg_apply_ir_flags'
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

aed7ee049a3e ath: regd: Provide description for ath_reg_apply_ir_flags's 'reg' param
206cd5800d8c ath: dfs_pattern_detector: Fix some function kernel-doc headers
748d250777e6 ath: dfs_pri_detector: Demote zero/half completed kernel-doc headers

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201102112410.1049272-20-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

