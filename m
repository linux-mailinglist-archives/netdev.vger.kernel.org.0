Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F31299A5D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404688AbgJZXXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:23:23 -0400
Received: from z5.mailgun.us ([104.130.96.5]:27173 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404594AbgJZXXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:23:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603754600; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=rkfjILLJaxqI/obAVbh6rCzjEuv5Rj8NXWFQMUhMDc4=; b=phiKLzY4m2vC1c+w6K6hhfPdBPxH8cMSzW4YUwZ8kXghl+q4Jnsz8Ei6/80hjL9ZqsAtmoWp
 adHJA7F+OQ5yna0SRU/NDGvWutOHR+PIVy1xRBDkUtyps4gB2sbOiR1d16FTfJwMBXViXAUl
 qpgvmz8TrVzpkbKKle8eWiUGiTM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f975a217c1cca52db63b21a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Oct 2020 23:22:09
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03DA2C433CB; Mon, 26 Oct 2020 23:22:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F037CC433C9;
        Mon, 26 Oct 2020 23:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F037CC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v9 3/4] docs: Add documentation for userspace client
 interface
To:     Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
References: <1603495075-11462-1-git-send-email-hemantk@codeaurora.org>
 <1603495075-11462-4-git-send-email-hemantk@codeaurora.org>
 <20201025144627.65b2324e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e92a5a5b-ac62-a6d8-b6b4-b65587e64255@codeaurora.org>
 <20201026155617.350c45ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <b7d2f4d9-6755-c099-07f7-f503b97c9f09@codeaurora.org>
Date:   Mon, 26 Oct 2020 16:22:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201026155617.350c45ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 10/26/20 3:56 PM, Jakub Kicinski wrote:
> On Mon, 26 Oct 2020 07:38:46 -0600 Jeffrey Hugo wrote:
>> On 10/25/2020 3:46 PM, Jakub Kicinski wrote:
>>> On Fri, 23 Oct 2020 16:17:54 -0700 Hemant Kumar wrote:
>>>> +UCI driver enables userspace clients to communicate to external MHI devices
>>>> +like modem and WLAN. UCI driver probe creates standard character device file
>>>> +nodes for userspace clients to perform open, read, write, poll and release file
>>>> +operations.
>>>
>>> What's the user space that talks to this?
>>
>> Multiple.
>>
>> Each channel has a different purpose.  There it is expected that a
>> different userspace application would be using it.
>>
>> Hemant implemented the loopback channel, which is a simple channel that
>> just sends you back anything you send it.  Typically this is consumed by
>> a test application.
>>
>> Diag is a typical channel to be consumed by userspace.  This is consumed
>> by various applications that talk to the remote device for diagnostic
>> information (logs and such).
>>
>> Sahara is another common channel that is usually used for the multistage
>> firmware loading process.
> 
> Thanks for the info, are there any open source tests based on the
> loopback channel (perhaps even in tree?)
> 
> Since that's the only channel enabled in this set its the only one
> we can comment on.
> 
i am not aware of any open source tests based on loopback channel. My 
testing includes multiple sessions of echo, cat etc using adb to confirm 
what is sent is received back. Loic is using UCI driver for his use case 
too.

Loic, in case you have any use case (which is part of open source) which 
can use UCI driver, pls share that info ?

I think as soon as UCI becomes part of the tree, more and more channels 
would get added to the driver having open source code for that from 
other folks in community (Loic would be one of them i guess).

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
