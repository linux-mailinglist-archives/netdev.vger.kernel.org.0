Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799822CB42C
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 06:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgLBFAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 00:00:50 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:14169 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgLBFAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 00:00:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606885225; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=cOrj0U2V5xokVHCW6VO47cLLL1EXLUmFRN39hfQ29NE=; b=jXgMfZT7pC/MfOYBkZ2XLw8HO1Y5X1m8AKihr6Z9i0f1Y6b+la1DV0OPLxmxijURgo4x9Nyi
 qUbmCiQ4V1Maus/ftzWeybv2MVSGLiJITt761Hc+LS3OmZI8M9yQ8PD4rMM59F6mLlBjuudf
 S0YHpo+q0+z1vc+by+jhBv3WaZ8=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-west-2.postgun.com with SMTP id
 5fc71f4cf653ea0cd852c9dd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 04:59:56
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30D53C43463; Wed,  2 Dec 2020 04:59:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46029C433C6;
        Wed,  2 Dec 2020 04:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46029C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
 <20201201120302.474d4c9b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <817a4346-efb7-cfe5-0678-d1b60d06627d@codeaurora.org>
 <20201201185506.77c4b3df@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <f22eaead-fd25-8b20-7ca1-ae3f535347d4@codeaurora.org>
Date:   Tue, 1 Dec 2020 21:59:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201201185506.77c4b3df@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/2020 7:55 PM, Jakub Kicinski wrote:
> On Tue, 1 Dec 2020 13:48:36 -0700 Jeffrey Hugo wrote:
>> On 12/1/2020 1:03 PM, Jakub Kicinski wrote:
>>> On Tue, 1 Dec 2020 12:40:50 -0700 Jeffrey Hugo wrote:
>>>> On 12/1/2020 12:29 PM, Jakub Kicinski wrote:
>>>>> On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:
>>>>>> This patch series adds support for UCI driver. UCI driver enables userspace
>>>>>> clients to communicate to external MHI devices like modem and WLAN. UCI driver
>>>>>> probe creates standard character device file nodes for userspace clients to
>>>>>> perform open, read, write, poll and release file operations. These file
>>>>>> operations call MHI core layer APIs to perform data transfer using MHI bus
>>>>>> to communicate with MHI device. Patch is tested using arm64 based platform.
>>>>>
>>>>> Wait, I thought this was for modems.
>>>>>
>>>>> Why do WLAN devices need to communicate with user space?
>>>>>       
>>>>
>>>> Why does it matter what type of device it is?  Are modems somehow unique
>>>> in that they are the only type of device that userspace is allowed to
>>>> interact with?
>>>
>>> Yes modems are traditionally highly weird and require some serial
>>> device dance I don't even know about.
>>>
>>> We have proper interfaces in Linux for configuring WiFi which work
>>> across vendors. Having char device access to WiFi would be a step
>>> back.
>>
>> So a WLAN device is only ever allowed to do Wi-Fi?  It can't also have
>> GPS functionality for example?
> 
> No, but it's also not true that the only way to implement GPS is by
> opening a full on command/packet interface between fat proprietary
> firmware and custom user space (which may or may not be proprietary
> as well).

Funny, that exactly what the GPS "API" in the kernel is, although a bit 
limited to the specifics on the standardized GPS "sentences" and not 
covering implementation specific configuration.

> 
>>>> However, I'll bite.  Once such usecase would be QMI.  QMI is a generic
>>>> messaging protocol, and is not strictly limited to the unique operations
>>>> of a modem.
>>>>
>>>> Another usecase would be Sahara - a custom file transfer protocol used
>>>> for uploading firmware images, and downloading crashdumps.
>>>
>>> Thanks, I was asking for use cases, not which proprietary vendor
>>> protocol you can implement over it.
>>>
>>> None of the use cases you mention here should require a direct FW -
>>> user space backdoor for WLAN.
>>
>> Uploading runtime firmware, with variations based on the runtime mode.
>> Flashing the onboard flash based on cryptographic keys.  Accessing
>> configuration data.  Accessing device logs.  Configuring device logs.
>> Synchronizing the device time reference to Linux local or remote time
>> sources.  Enabling debugging/performance hardware.  Getting software
>> diagnostic events.  Configuring redundancy hardware per workload.
>> Uploading new cryptographic keys.  Invalidating cryptographic keys.
>> Uploading factory test data and running factory tests.
>>
>> Need more?
> 
> This conversation is going nowhere. Are you trying to say that creating
> a common Linux API for those features is impossible and each vendor
> should be allowed to add their own proprietary way?
> 
> This has been proven incorrect again and again, and Wi-Fi is a good
> example.
> 
> You can do whatever you want for GPS etc. but don't come nowhere near
> networking with this attitude please.
> 

No I'm saying (and Bjorn/Mani by the looks of things), that there is 
commonality in the core features - IP traffic, Wi-Fi, etc but then there 
are vendor specific things which are either things you don't actually 
want in the kernel, don't want the kernel doing, or have little 
commonality between vendors such that attempting to unify them gains you 
little to nothing.

Over in the networking space, I can see where standardization is plenty 
useful.

I can't speak for other vendors, but a "modem" or a "wlan" device from 
Qualcomm is not something that just provides one service.  They tend to 
provide dozens of different functionalities, some of those are 
"standardized" like wi-fi where common wi-fi interfaces are used. 
Others are unique to Qualcomm.

The point is "wlan device" is a superset of "wi-fi".  You seem to be 
equating them to be the same in a "shoot first, ask questions later" manner.

This series provides a way for userspace to talk to remote MHI "widgets" 
for usecases not covered elsewhere.  Those "widgets" just happen to 
commonly provide modem/wlan services, but ones that don't are not excluded.

Regarding not coming near networking, I'd like to remind you it was you 
that decided to come over here to the non-networking area and try to 
make this about networking.

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
