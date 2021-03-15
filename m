Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E83B33ADCA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCOImJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:42:09 -0400
Received: from z11.mailgun.us ([104.130.96.11]:59014 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhCOIli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 04:41:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615797698; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9Yz2prTldpg06djW1uSjsLo9RAV7sQVLS2v0kM5ni7Y=; b=atA8sXeHxcX6RGvxpdgJVQE0UOw2nSN9ITssYVkya2hmjSy2/KqqjCMdhZvlTDrU13sBt2Yx
 D03Yp1vwAcOUS3MGkt2Px3z9Ic3SdEjT3RAPjCcEnGf6woyqoIMjts05e4AT1Ia8vQEXNohj
 jCXYPGq4zdA7KMAVZTosRS+CfPM=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 604f1dc05d70193f8863aebc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 08:41:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 24727C43461; Mon, 15 Mar 2021 08:41:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C5D0C43463;
        Mon, 15 Mar 2021 08:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2C5D0C43463
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Aditya Srivastava <yashsri421@gmail.com>, siva8118@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] rsi: fix comment syntax in file headers
References: <20210314201818.27380-1-yashsri421@gmail.com>
        <CAKXUXMzH-cUVeuCT6eM_0iHzgKpzvZUPO6pKNpD0yUp2td09Ug@mail.gmail.com>
Date:   Mon, 15 Mar 2021 10:41:30 +0200
In-Reply-To: <CAKXUXMzH-cUVeuCT6eM_0iHzgKpzvZUPO6pKNpD0yUp2td09Ug@mail.gmail.com>
        (Lukas Bulwahn's message of "Mon, 15 Mar 2021 09:01:56 +0100")
Message-ID: <87a6r4u7ut.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:

> On Sun, Mar 14, 2021 at 9:18 PM Aditya Srivastava <yashsri421@gmail.com> wrote:
>>
>> The opening comment mark '/**' is used for highlighting the beginning of
>> kernel-doc comments.
>> There are files in drivers/net/wireless/rsi which follow this syntax in
>> their file headers, i.e. start with '/**' like comments, which causes
>> unexpected warnings from kernel-doc.
>>
>> E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
>> causes this warning:
>> "warning: wrong kernel-doc identifier on line:
>>  * Copyright (c) 2018 Redpine Signals Inc."
>>
>> Similarly for other files too.
>>
>> Provide a simple fix by replacing the kernel-doc like comment syntax with
>> general format, i.e. "/*", to prevent kernel-doc from parsing it.
>>
>
> Aditya, thanks for starting to clean up the repository following your
> investigation on kernel-doc warnings.
>
> The changes to all those files look sound.
>
> However I think these ten patches are really just _one change_, and
> hence, all can be put into a single commit.

I agree, this is one logical change to a single driver so one patch will
suffice. I think for cleanup changes like this one patch per driver is a
good approach.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
