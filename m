Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A61729FB1A
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgJ3CQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:16:14 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:32810 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ3CQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 22:16:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604024173; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=LRMgOFZbItBqfHE6rw+IhX6ADhrLY1wYvZCBR3GV4N0=; b=T1tjjevsXJ7QN/gV8gKMONYGB0+YeSiZN+9jUSR8dkJsRMpFo7crplifFSrIyQH4pkpOrVsR
 HzpQOlSikcVStTlwPDc+veVG30W/5zu3s2P0GKEsehOs3UZwUZX2OdHcN1mAZ3ZxoepyrPwb
 b8GyDbdx4+AiZP8lIm+9AGrplIY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f9b776d1df7f5f83c818584 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 30 Oct 2020 02:16:13
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4357DC433FE; Fri, 30 Oct 2020 02:16:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1AEACC433C9;
        Fri, 30 Oct 2020 02:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1AEACC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v10 3/4] docs: Add documentation for userspace client
 interface
To:     Randy Dunlap <rdunlap@infradead.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1604007647-32163-1-git-send-email-hemantk@codeaurora.org>
 <1604007647-32163-4-git-send-email-hemantk@codeaurora.org>
 <6f508e54-a170-8409-886c-a882b6fd5f63@infradead.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <cc3055e5-9522-aeaa-4b29-e4f811b832a8@codeaurora.org>
Date:   Thu, 29 Oct 2020 19:16:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6f508e54-a170-8409-886c-a882b6fd5f63@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 10/29/20 2:51 PM, Randy Dunlap wrote:
> Hi,
> 
> On 10/29/20 2:40 PM, Hemant Kumar wrote:
>> MHI userspace client driver is creating device file node
>> for user application to perform file operations. File
>> operations are handled by MHI core driver. Currently
>> Loopback MHI channel is supported by this driver.
>>
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
>> ---
>>   Documentation/mhi/index.rst |  1 +
>>   Documentation/mhi/uci.rst   | 83 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 84 insertions(+)
>>   create mode 100644 Documentation/mhi/uci.rst
> 
> 
>> diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
>> new file mode 100644
>> index 0000000..fe901c4
>> --- /dev/null
>> +++ b/Documentation/mhi/uci.rst
>> @@ -0,0 +1,83 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=================================
>> +Userspace Client Interface (UCI)
>> +=================================
>> +
> 
> 
> Lots of TLAs.
> 
>> +
>> +read
>> +----
>> +
>> +When data transfer is completed on downlink channel, TRE buffer is copied to
>> +pending list. Reader is unblocked and data is copied to userspace buffer. TRE
>> +buffer is queued back to downlink channel transfer ring.
> 
> What is TRE?
Transfer Ring Element
i will add that in small bracket inline.
> 
>> +
>> +Usage
>> +=====
>> +
>> +Device file node is created with format:-
>> +
>> +/dev/mhi_<controller_name>_<mhi_device_name>
>> +
>> +controller_name is the name of underlying bus used to transfer data. mhi_device
>> +name is the name of the MHI channel being used by MHI client in userspace to
>> +send or receive data using MHI protocol.
>> +
>> +There is a separate character device file node created for each channel
>> +specified in mhi device id table. MHI channels are statically defined by MHI
> 
>                  MHI
> unless it is a variable name, like below: mhi_device_id
Done.
> 
>> +specification. The list of supported channels is in the channel list variable
>> +of mhi_device_id table in UCI driver.
>> +
> 
>> +Other Use Cases
>> +---------------
>> +
>> +Getting MHI device specific diagnostics information to userspace MHI diag client
> 
>                                                                          diagnostic client
Done.
> 
>> +using DIAG channel 4 (Host to device) and 5 (Device to Host).
>>
> 
> thanks.
> 

Thanks for reviewing it. Let me fix it and re-upload.

Thanks,
Hemant

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
