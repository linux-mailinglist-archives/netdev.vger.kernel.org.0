Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6731C2ADEA4
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgKJSpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:45:20 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:25940 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJSpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 13:45:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605033918; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ElUvTbVkzLm41BpUHPizEfq4Yf8HRRWIjdISp4d615A=; b=HjocSFarW44NR19QUd8IIxkJ4+Rx4g4DAoptZhYJu0bYP6u9cQxjzSIZAcQm2/wS3YsGUkeZ
 n2lz9l9gnEsqeOWvkTMCjymeQM7kQQYe8aERkUttS88jnkdbo/ZXmtyKaiFj7/YZcAskFrDe
 S+6rrnS+0ZiAKQ0rQXiv8la5Q9s=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5faadf7db8c6a84a5c6963c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:44:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AAD29C43385; Tue, 10 Nov 2020 18:44:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A10DFC433C6;
        Tue, 10 Nov 2020 18:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A10DFC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org, hemantk@codeaurora.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v10 1/2] bus: mhi: Add mhi_queue_is_full function
References: <1604424234-24446-1-git-send-email-loic.poulain@linaro.org>
        <20201105165708.31d24782@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201106051353.GA3473@work>
        <20201106080445.00588690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <B9A7A95E-BD2F-49C0-A28C-56A8E6D903AC@linaro.org>
        <20201106083918.5ea0674b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 10 Nov 2020 20:44:06 +0200
In-Reply-To: <20201106083918.5ea0674b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 6 Nov 2020 08:39:18 -0800")
Message-ID: <87a6vp59xl.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ ath11k list

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 06 Nov 2020 21:58:12 +0530 Manivannan Sadhasivam wrote:
>>>> Since you've applied now, what would you propose?  
>>>
>>> Do you need mhi_queue_is_full() in other branches, or are you just
>>> concerned about the conflicts?
>> 
>> Yes, I need this patch in mhi-next.
>> 
>>> I'm assuming the concern is just about the mhi/core patch, or would 
>>> you need to refactor something in the net driver as well?  
>> 
>> Just the mhi_queue_is_full() patch. 
>
> Okay, I think you can just apply that patch to your tree again and git
> should figure out it's a duplicate. Not optimal, because the change will
> have two hashes, but the function is trivial, shouldn't be an issue
> even if conflict happens.
>
> Will you need it in wireless (ath11k), or only in other trees?
>
> If it ends up in the wireless tree Dave or I will do the resolution when
> we pull from Kalle so it won't even appear to Linus (but then it should
> go into wireless through an immutable branch).

I think in the next few releases we need close coordination between mhi
and ath11k, both are in active development and there can be changes
which break ath11k functionality. Let's see how this goes.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
