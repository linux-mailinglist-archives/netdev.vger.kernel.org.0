Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFF82CC70A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgLBTw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:52:29 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:12661 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387809AbgLBTw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:52:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606938724; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=LgX5i1QHZI3wQmIzxB7xFGVYPc8Nw0EBGfijpsbTvHQ=;
 b=G0WO168JCo4i+Vpe5Iq4k1yueNzMyaBJM2da/Ik5JFdAQ3cl6dlznF8494FcrYy570x+wjAH
 vT6no2hLKBMyyTVFueVq0UV0SnuzShuXfaetQbSpVptJMOlm/gDcIdRuBoCVpUVtOBTn6rTv
 2rtwG0JQfkUPtrWYZzYS25eZl5M=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fc7f047f4482b01c4cb0e4d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 19:51:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9B99CC43463; Wed,  2 Dec 2020 19:51:33 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 41F5CC433C6;
        Wed,  2 Dec 2020 19:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 41F5CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/17] ath: regd: Provide description for
 ath_reg_apply_ir_flags's 'reg' param
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201126133152.3211309-10-lee.jones@linaro.org>
References: <20201126133152.3211309-10-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202195133.9B99CC43463@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 19:51:33 +0000 (UTC)
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

Failed to apply:

error: patch failed: drivers/net/wireless/ath/regd.c:360
error: drivers/net/wireless/ath/regd.c: patch does not apply
stg import: Diff does not apply cleanly

3 patches set to Changes Requested.

11933863 [09/17] ath: regd: Provide description for ath_reg_apply_ir_flags's 'reg' param
11933871 [11/17] ath: dfs_pattern_detector: Fix some function kernel-doc headers
11933859 [12/17] ath: dfs_pri_detector: Demote zero/half completed kernel-doc headers

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201126133152.3211309-10-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

