Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B912E2AD0FA
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 09:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgKJIQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 03:16:35 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:57995 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgKJIQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 03:16:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604996194; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=kuvWj8eqBWR1DBhp8ZGnSxliRk/RtY1alVKAD+etVBk=; b=wdgzVKQnPDeVmuy/cNFavH3JxabsaH8DBvz4Zfw+SFvd1GLsmp4nDMG5TGIyBfCSqqCylvEx
 KQZyAYGt18pdwSodvfAhVh152XUs0HsAIuWyHKIp0XTA2Iz/Z7bitqSu6INBO4hOvwGkUKkJ
 +wE8QadTH+78Zcc/PnqWCRGhFdw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5faa4c617d4f16f92fe1ca73 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 08:16:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 04855C433C8; Tue, 10 Nov 2020 08:16:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93E7DC433C8;
        Tue, 10 Nov 2020 08:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 93E7DC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace a set of atomic_add()
References: <1604991491-27908-1-git-send-email-yejune.deng@gmail.com>
Date:   Tue, 10 Nov 2020 10:16:28 +0200
In-Reply-To: <1604991491-27908-1-git-send-email-yejune.deng@gmail.com> (Yejune
        Deng's message of "Tue, 10 Nov 2020 14:58:11 +0800")
Message-ID: <87mtzpeieb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yejune Deng <yejune.deng@gmail.com> writes:

> a set of atomic_inc() looks more readable
>
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  drivers/net/wireless/st/cw1200/bh.c  | 10 +++++-----
>  drivers/net/wireless/st/cw1200/wsm.c |  8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)

The subject prefix should be "cw1200:", but I can fix that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
