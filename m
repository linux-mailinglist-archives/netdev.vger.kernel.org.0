Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8E92548C4
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgH0PMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:12:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:58101 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbgH0Lkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:40:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598528436; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=w7fCvr48yy18hQcvWfj5BBx2HYb6MogSv84HemZHdz0=; b=xJXyfR+FRBdQ25BfsxCTCCWm+Pk4ZY7hv2ia1NBQ3qXvwO8xdtAd0wFsXoctOAH4mm1sI4XB
 v7q2xT23pcJ7ORnOj43St3QQX7XreVGACsbCb1UqTMOIQtEzgQiRVoMaTaEtlUpQ1SbWB81L
 pqHcG2CHmf8Jn0CFJ0XdxBCIqjw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f479baa630b177c47077e2f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 11:40:26
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2DE8BC43391; Thu, 27 Aug 2020 11:40:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 59F14C433CA;
        Thu, 27 Aug 2020 11:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 59F14C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 12/30] wireless: ath: wil6210: wmi: Correct misnamed function parameter 'ptr_'
References: <20200826093401.1458456-13-lee.jones@linaro.org>
        <20200826155625.A5A88C433A1@smtp.codeaurora.org>
        <20200827063559.GP3248864@dell> <20200827074100.GX3248864@dell>
Date:   Thu, 27 Aug 2020 14:40:21 +0300
In-Reply-To: <20200827074100.GX3248864@dell> (Lee Jones's message of "Thu, 27
        Aug 2020 08:41:00 +0100")
Message-ID: <877dtkb9lm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Thu, 27 Aug 2020, Lee Jones wrote:
>
>> On Wed, 26 Aug 2020, Kalle Valo wrote:
>> 
>> > Lee Jones <lee.jones@linaro.org> wrote:
>> > 
>> > > Fixes the following W=1 kernel build warning(s):
>> > > 
>> > >  drivers/net/wireless/ath/wil6210/wmi.c:279: warning: Function
>> > > parameter or member 'ptr_' not described in 'wmi_buffer_block'
>> > >  drivers/net/wireless/ath/wil6210/wmi.c:279: warning: Excess
>> > > function parameter 'ptr' description in 'wmi_buffer_block'
>> > > 
>> > > Cc: Maya Erez <merez@codeaurora.org>
>> > > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > > Cc: "David S. Miller" <davem@davemloft.net>
>> > > Cc: Jakub Kicinski <kuba@kernel.org>
>> > > Cc: linux-wireless@vger.kernel.org
>> > > Cc: wil6210@qti.qualcomm.com
>> > > Cc: netdev@vger.kernel.org
>> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> > 
>> > Failed to apply:
>> > 
>> > error: patch failed: drivers/net/wireless/ath/wil6210/wmi.c:266
>> > error: drivers/net/wireless/ath/wil6210/wmi.c: patch does not apply
>> > stg import: Diff does not apply cleanly
>> > 
>> > Patch set to Changes Requested.
>> 
>> Are you applying them in order?
>> 
>> It may be affected by:
>> 
>>  wireless: ath: wil6210: wmi: Fix formatting and demote
>> non-conforming function headers
>> 
>> I'll also rebase onto the latest -next and resubmit.
>
> I just rebased all 3 sets onto the latest -next (next-20200827)
> without issue.  Not sure what problem you're seeing.  Did you apply
> the first set before attempting the second?

I can't remember the order, patchwork sorts them based on the order they
have been submitted and that's what I usually use.

Do note that there's a separate tree for drivers in
drivers/net/wireless/ath:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/

And it takes a week or two before patches go to linux-next.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
