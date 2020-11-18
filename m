Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D82B7D13
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 12:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgKRLzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 06:55:22 -0500
Received: from z5.mailgun.us ([104.130.96.5]:23340 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgKRLzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 06:55:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605700521; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7b0+e3ujnFnLFUYK1WadxMsLN+fWS1azqjsjnkke520=;
 b=Va/a0uGYwMWZXvX2RouxeHm5TswdI3+YG2GB+NAHnYX4gkZngGOFf3EBN3AE8FvoWUW8M7Ir
 w+LAGe9fzOvfLmb5fnFkA1q+xrpqQjNw/uL60QTNbQ5ducrwf741CWIZ6N9I3BxEyqVE88AL
 D8+O5ll4EKgYdWUbb6J33jHyiq8=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fb50ba8ba0e43f355d55338 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 11:55:20
 GMT
Sender: cjhuang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7277CC43461; Wed, 18 Nov 2020 11:55:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B476CC433C6;
        Wed, 18 Nov 2020 11:55:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 19:55:19 +0800
From:   Carl Huang <cjhuang@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
        bbhatt@codeaurora.org, netdev@vger.kernel.org,
        hemantk@codeaurora.org, ath11k@lists.infradead.org
Subject: Re: [PATCH] bus: mhi: Remove auto-start option
In-Reply-To: <20201118093107.GC3286@work>
References: <20201118053102.13119-1-manivannan.sadhasivam@linaro.org>
 <877dqjz0bv.fsf@codeaurora.org> <20201118093107.GC3286@work>
Message-ID: <16c430bbd5117a35496f85f4454095b9@codeaurora.org>
X-Sender: cjhuang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 17:31, Manivannan Sadhasivam wrote:
> On Wed, Nov 18, 2020 at 07:43:48AM +0200, Kalle Valo wrote:
>> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
>> 
>> > From: Loic Poulain <loic.poulain@linaro.org>
>> >
>> > There is really no point having an auto-start for channels.
>> > This is confusing for the device drivers, some have to enable the
>> > channels, others don't have... and waste resources (e.g. pre allocated
>> > buffers) that may never be used.
>> >
>> > This is really up to the MHI device(channel) driver to manage the state
>> > of its channels.
>> >
>> > While at it, let's also remove the auto-start option from ath11k mhi
>> > controller.
>> >
>> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> > [mani: clubbed ath11k change]
>> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> 
>> Thanks and feel free to take this to the immutable branch:
>> 
>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Patch applied to mhi-ath11k-immutable branch and merged into mhi-next.
> 
> Thanks,
> Mani
> 
Does net/qrtr/mhi.c need changes? I guess now net/qrtr/mhi.c needs to 
call
mhi_prepare_for_transfer() before transfer.

>> 
>> --
>> https://patchwork.kernel.org/project/linux-wireless/list/
>> 
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
