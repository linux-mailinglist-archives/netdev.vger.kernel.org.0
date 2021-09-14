Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113FB40A63A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhINFy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:54:57 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:47934 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbhINFyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 01:54:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631598819; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Y0jKmufl/3kPY1ZSvF6Mf1XG2MS8H/dyzGSW4oGt8eA=; b=o187jDvYs8e7vCkRlKu16fpNtb1P0jDBGz+BCXd5mP0ChjQ/Y+W6tFOC9u5L0zjD3r0l7zX/
 F3j1MsvdlkjameuSlaElHVi16eAYOZflKldZ8wQNkUGeaPinW6RlpnEYMkXdSUOfWW53i0fN
 EBLXWbR+FkIKbJr/vPKnbTyBd7s=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 614038d9bd6681d8ed66842c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 14 Sep 2021 05:53:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 662C9C43618; Tue, 14 Sep 2021 05:53:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 701F2C4338F;
        Tue, 14 Sep 2021 05:53:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 701F2C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Len Baker <len.baker@gmx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: Replace one-element array with flexible-array member
References: <20210904114937.6644-1-len.baker@gmx.com>
        <20210912193140.GC146608@embeddedor>
        <7a9ba7d3-b5e7-00ab-3bd3-7fca476aae94@embeddedor.com>
Date:   Tue, 14 Sep 2021 08:53:21 +0300
In-Reply-To: <7a9ba7d3-b5e7-00ab-3bd3-7fca476aae94@embeddedor.com> (Gustavo A.
        R. Silva's message of "Sun, 12 Sep 2021 14:42:39 -0500")
Message-ID: <877dfj8zzi.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> On 9/12/21 14:31, Gustavo A. R. Silva wrote:
>> 
>> There is already a patch for this:
>> 
>> https://lore.kernel.org/lkml/20210823172159.GA25800@embeddedor/
>> 
>> which I will now add to my -next tree.
>
> Well, in this case I think it's much better if Kalle can take it. :)

Please don't take any ath11k patches. I have a ton of ath11k patches in
my queue and if you start taking some of them, it will cause conflicts
between trees.

Only take wireless-driver patches which I have acked, please.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
