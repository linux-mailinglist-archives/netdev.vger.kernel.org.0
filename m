Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE08225557B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgH1Hlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 03:41:39 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:34924 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728001AbgH1Hli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 03:41:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598600497; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=mZd4az/p4FmBgUWML4ZQBopjKpxj4NlCZjT6BNlLexk=; b=tVXPHHRws/FdCJzIflZAqWIZs9Mij1biTv5O67/yL9Xcsu5VTdRUTdQv1t8WYfjpa49p/5R2
 XA9Zxo5ocTMzVevOQJP+g9VaiJm9vuM/g9l1BsW9dn9DyJqoxDw8xi+IUoUGEufVTjqLva08
 E7C2D8DANLLDOo5eY6EUUJ9blto=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f48b5304b620c27d30c28ec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 28 Aug 2020 07:41:36
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF5E8C433AF; Fri, 28 Aug 2020 07:41:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E0134C433CA;
        Fri, 28 Aug 2020 07:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E0134C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Steve deRosier <derosier@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linuxarm@huawei.com, mauro.chehab@huawei.com,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Maital Hahn <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
        <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com>
Date:   Fri, 28 Aug 2020 10:41:29 +0300
In-Reply-To: <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com>
        (Steve deRosier's message of "Thu, 27 Aug 2020 08:48:30 -0700")
Message-ID: <873647kyja.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steve deRosier <derosier@gmail.com> writes:

> On Tue, Aug 25, 2020 at 10:49 PM Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org> wrote:
>>
>> This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
>> with it applied, WiFi stops working, and the Kernel starts printing
>> this message every second:
>>
>>    wlcore: PHY firmware version: Rev 8.2.0.0.242
>>    wlcore: firmware booted (Rev 8.9.0.0.79)
>>    wlcore: ERROR command execute failure 14
>
> Only if NO firmware for the device in question supports the `KEY_IGTK`
> value, then this revert is appropriate. Otherwise, it likely isn't.
>  My suspicion is that the feature that `KEY_IGTK` is enabling is
> specific to a newer firmware that Mauro hasn't upgraded to. What the
> OP should do is find the updated firmware and give it a try.
>
> AND - since there's some firmware the feature doesn't work with, the
> driver should be fixed to detect the running firmware version and not
> do things that the firmware doesn't support.  AND the firmware writer
> should also make it so the firmware doesn't barf on bad input and
> instead rejects it politely.
>
> But I will say I'm making an educated guess; while I have played with
> the TI devices in the past, it was years ago and I won't claim to be
> an expert. I also am unable to fix it myself at this time.
>
> I'd just rather see it fixed properly instead of a knee-jerk reaction
> of reverting it simply because the OP doesn't have current firmware.

Yeah, a proper fix for this is of course better but if there's no fix,
say within the next week or so, let's revert this. A new version of the
patch implementing IGTK, with proper feature detection, can be always
added later.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
