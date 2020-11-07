Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70862AA689
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgKGQDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:03:31 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:49794 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgKGQDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 11:03:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765009; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=zhW9Fd9ECWVPXgVZt9v7ksfzG/0je0jsdG/rHWmN6bI=;
 b=MNmwTaiOj7ZtOBkySJG+k97nCRRIhWwu8USOH0XsaWgVDXvS8ge6mu2lAbbh1OrWM3jAuB8U
 z9yH7R6ckhHKCafZqUXXlhw8/Gm5h7oEO+TXgN5VvCUDrV8Rx4NCLnkRFTQFqssJazHYaZNW
 azpaJ4rI/CypMBFr8ScPf1Jvafs=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fa6c53cf8c560b580b7f694 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:03:08
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A9A9C433C9; Sat,  7 Nov 2020 16:03:07 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBB2CC433C8;
        Sat,  7 Nov 2020 16:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBB2CC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [02/41] rsi: rsi_91x_usb: Fix some basic kernel-doc issues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201102112410.1049272-3-lee.jones@linaro.org>
References: <20201102112410.1049272-3-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107160307.5A9A9C433C9@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:03:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/rsi/rsi_91x_usb.c:26: warning: cannot understand function prototype: 'u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL; '
>  drivers/net/wireless/rsi/rsi_91x_usb.c:88: warning: Function parameter or member 'endpoint' not described in 'rsi_write_multiple'
>  drivers/net/wireless/rsi/rsi_91x_usb.c:88: warning: Excess function parameter 'addr' description in 'rsi_write_multiple'
>  drivers/net/wireless/rsi/rsi_91x_usb.c:320: warning: Function parameter or member 'ep_num' not described in 'rsi_rx_urb_submit'
>  drivers/net/wireless/rsi/rsi_91x_usb.c:320: warning: Function parameter or member 'mem_flags' not described in 'rsi_rx_urb_submit'
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

2 patches applied to wireless-drivers-next.git, thanks.

f21e6c5822f2 rsi: rsi_91x_usb: Fix some basic kernel-doc issues
63636b385e39 rsi: rsi_91x_usb_ops: Source file headers are not good candidates for kernel-doc

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201102112410.1049272-3-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

