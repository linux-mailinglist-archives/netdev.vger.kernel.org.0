Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95184612C0
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbhK2Kqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:46:46 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:41272 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351266AbhK2Koo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 05:44:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638182486; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ow487FjY5I7CBMANUFr8MtNWnol6C0MMVj75BL25XGU=;
 b=CO4tFxKgtK1g4zckmSIskkwpQIX95sAt/uHcfCDPukU4C6FNVw1NZ6e5+ObcRabmu8K+s4UI
 O2SSvFlvs/HgvWuj25lAPqg/O9Q/kYzO8z0FVKaB4W+N9lEQgexdmz2RQox+0B4aYUMMIkYr
 J5ZYcN48GDL7e6bFJ4c/f8E+DlI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 61a4ae556bacc185a596464a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Nov 2021 10:41:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4100FC4360D; Mon, 29 Nov 2021 10:41:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03649C4360D;
        Mon, 29 Nov 2021 10:41:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 03649C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: remove unneeded conversion to bool
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <d9492bb9bced106f20006edb49200926184c3763.1637739090.git.yang.guang5@zte.com.cn>
References: <d9492bb9bced106f20006edb49200926184c3763.1637739090.git.yang.guang5@zte.com.cn>
To:     davidcomponentone@gmail.com
Cc:     pkshih@realtek.com, davidcomponentone@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163818247913.17830.17538773123714172874.kvalo@codeaurora.org>
Date:   Mon, 29 Nov 2021 10:41:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

davidcomponentone@gmail.com wrote:

> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> The coccinelle report
> ./drivers/net/wireless/realtek/rtw89/debug.c:817:21-26:
> WARNING: conversion to bool not needed here
> ./drivers/net/wireless/realtek/rtw89/mac.c:3698:49-54:
> WARNING: conversion to bool not needed here
> ./drivers/net/wireless/realtek/rtw89/phy.c:1770:49-54:
> WARNING: conversion to bool not needed here
> ./drivers/net/wireless/realtek/rtw89/rtw8852a.c:1056:41-46:
> WARNING: conversion to bool not needed here
> 
> Relational and logical operators evaluate to bool,
> explicit conversion is overly verbose and unneeded.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>

There was a similar patch already applied:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=1646ce8f83b9

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/d9492bb9bced106f20006edb49200926184c3763.1637739090.git.yang.guang5@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

