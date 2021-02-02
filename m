Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C556730B7DD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhBBGaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:30:22 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:12549 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231888AbhBBGaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:30:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612247394; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=4KlQGFrN5Le7PICSqsAOoAQBLupf944xN1JaRxy8alw=; b=lN8MxApJ13Q0xYXzJ8Ru9S9RKcSNq2Op7rn3jIK87tjVNMTInR/FNDy7NnBMTOD9Z36W9A8N
 8NQSb03YAaLVRr/sKEEg9Dl0R9Nq/ZLYrsdx98pVS6AwzynmG0LAgI7pR8Gm1xTRt5Y0a3To
 At/UpQ/nS/7G6NN4Zec9zoNHROE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6018f159ab96aecb9fcdb019 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Feb 2021 06:29:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8A1BBC433C6; Tue,  2 Feb 2021 06:29:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 984D5C433ED;
        Tue,  2 Feb 2021 06:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 984D5C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list\:REALTEK WIRELESS DRIVER \(rtw88\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH] rtw88: 8821c: Add RFE 2 support
References: <20200805084559.30092-1-kai.heng.feng@canonical.com>
        <c0c336d806584361992d4b52665fbb82@realtek.com>
        <9330BBA5-158B-49F1-8B7C-C2733F358AC1@canonical.com>
        <CAAd53p6SA5gG8V27eD1Kh1ik932Kt8KzmYjLy33pOkw=QPKgpA@mail.gmail.com>
Date:   Tue, 02 Feb 2021 08:29:40 +0200
In-Reply-To: <CAAd53p6SA5gG8V27eD1Kh1ik932Kt8KzmYjLy33pOkw=QPKgpA@mail.gmail.com>
        (Kai-Heng Feng's message of "Thu, 7 Jan 2021 14:38:42 +0800")
Message-ID: <871rdz7zjf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> On Wed, Aug 5, 2020 at 7:24 PM Kai-Heng Feng
> <kai.heng.feng@canonical.com> wrote:
>>
>> Hi Tony,
>>
>> > On Aug 5, 2020, at 19:18, Tony Chuang <yhchuang@realtek.com> wrote:
>> >
>> >> 8821CE with RFE 2 isn't supported:
>> >> [   12.404834] rtw_8821ce 0000:02:00.0: rfe 2 isn't supported
>> >> [   12.404937] rtw_8821ce 0000:02:00.0: failed to setup chip efuse info
>> >> [   12.404939] rtw_8821ce 0000:02:00.0: failed to setup chip information
>> >>
>> >
>> > NACK
>> >
>> > The RFE type 2 should be working with some additional fixes.
>> > Did you tested connecting to AP with BT paired?
>>
>> No, I only tested WiFi.
>>
>> > The antenna configuration is different with RFE type 0.
>> > I will ask someone else to fix them.
>> > Then the RFE type 2 modules can be supported.
>>
>> Good to know that, I'll be patient and wait for a real fix.
>
> It's been quite some time, is support for RFE type 2 ready now?

It looks like this patch should add it:

https://patchwork.kernel.org/project/linux-wireless/patch/20210202055012.8296-4-pkshih@realtek.com/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
