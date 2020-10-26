Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA35D298EA4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780811AbgJZN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:56:49 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:30936 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1774828AbgJZN4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 09:56:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603720607; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=6WReYE7EsI0TzLP4fHRo6o5oMyKnwMkBqs5Ms1eH5XM=; b=YVpbzR1SsSWlG3V688m4DsZ5JlYHzTYFiNrB1UNdIdzhTyYZYU260Fqp1xo86fOb6rvNe4Rx
 6CzVMqJDn9dxGtSzDbdUwGVaIWZ25gmcAXHVBXE595BiDjATHy+SqnM7AORTTCuKzyIG/H/F
 hInIYP03K1Ys+WkiAu78vk11yfM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f96d5936b827c4eefbbd18f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Oct 2020 13:56:35
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C74A9C43385; Mon, 26 Oct 2020 13:56:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 520CDC433C9;
        Mon, 26 Oct 2020 13:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 520CDC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH v9 3/4] docs: Add documentation for userspace client
 interface
To:     Dan Williams <dcbw@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
References: <1603495075-11462-1-git-send-email-hemantk@codeaurora.org>
 <1603495075-11462-4-git-send-email-hemantk@codeaurora.org>
 <20201025144627.65b2324e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e92a5a5b-ac62-a6d8-b6b4-b65587e64255@codeaurora.org>
 <4e4dc63d0a0b5a820f7a70e30e29746fd6735a96.camel@redhat.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <7934e50d-72bd-f20a-54da-33f29c66c3fa@codeaurora.org>
Date:   Mon, 26 Oct 2020 07:56:33 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <4e4dc63d0a0b5a820f7a70e30e29746fd6735a96.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/2020 7:46 AM, Dan Williams wrote:
> On Mon, 2020-10-26 at 07:38 -0600, Jeffrey Hugo wrote:
>> On 10/25/2020 3:46 PM, Jakub Kicinski wrote:
>>> On Fri, 23 Oct 2020 16:17:54 -0700 Hemant Kumar wrote:
>>>> +UCI driver enables userspace clients to communicate to external
>>>> MHI devices
>>>> +like modem and WLAN. UCI driver probe creates standard character
>>>> device file
>>>> +nodes for userspace clients to perform open, read, write, poll
>>>> and release file
>>>> +operations.
>>>
>>> What's the user space that talks to this?
>>>
>>
>> Multiple.
>>
>> Each channel has a different purpose.  There it is expected that a
>> different userspace application would be using it.
>>
>> Hemant implemented the loopback channel, which is a simple channel
>> that
>> just sends you back anything you send it.  Typically this is consumed
>> by
>> a test application.
>>
>> Diag is a typical channel to be consumed by userspace.  This is
>> consumed
>> by various applications that talk to the remote device for
>> diagnostic
>> information (logs and such).
> 
> QMI too?
> Dan

Interesting question.  My product doesn't use QMI.  I would expect that 
all QMI runs through Router these days, but I am seeing some QMI 
channels in the downstream source.

Hemant, Do you know what is the usecase for the QMI0/QMI1 channels?

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
