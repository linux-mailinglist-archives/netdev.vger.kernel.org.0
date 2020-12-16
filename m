Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4234B2DC121
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgLPNWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 08:22:23 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:54634 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgLPNWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 08:22:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608124917; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=dlbrynf84dvX8jOV45UJ087GRtlBhIoPyp1S27UWkAI=; b=hFVctFmdnudZyQNrZs8S+G7mNR34jdHVJgYAriUi+RvGtNuc+CTKmup/1Zu70OnHF9Itj4uB
 CyItK7eOnncGAsBC85enBGRX87KjFz9PPDOMWeA/yowMBDl2/b6CSAmMzm774UpIoTymR80D
 jdzhsLnErdINp7qOYKiyKY0xt10=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fda09d80564dfefcdabbbdd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Dec 2020 13:21:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4A2AFC433ED; Wed, 16 Dec 2020 13:21:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C2A7C433CA;
        Wed, 16 Dec 2020 13:21:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3C2A7C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless -next] brcmfmac: Delete useless kfree code
References: <20201216130350.13815-1-zhengyongjun3@huawei.com>
Date:   Wed, 16 Dec 2020 15:21:23 +0200
In-Reply-To: <20201216130350.13815-1-zhengyongjun3@huawei.com> (Zheng
        Yongjun's message of "Wed, 16 Dec 2020 21:03:50 +0800")
Message-ID: <871rfpyjho.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> writes:

> The parameter of kfree function is NULL, so kfree code is useless, delete it.
> Therefore, goto expression is no longer needed, so simplify it.
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c  | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

You forgot to CC linux-wireless, please resend as v2

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
