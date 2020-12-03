Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3BF2CE0EF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgLCVh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:37:57 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:28583 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgLCVh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:37:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607031451; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=l6TLyQXo1quzH/gtjsFtzBLUwLamNB1TD1fM+yfgs8A=; b=GXnhxWE2iLL9oDfPnL1w40TE/gfZbiVHxWzvRj+U11dbfpYJR+MXXiWHERoPIL5gCWyd2Tll
 GXtWsW8zHUJWvo95Wyn14SoLOFKpeW17fWlD43O3drxceTncvJoJGL66gxYqW24aICCXB4wv
 BNcbB5nkuVsfm6nQ8twSwOknf+Q=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fc95a8135e04c51ab0c2114 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 21:37:05
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C2CFC433CA; Thu,  3 Dec 2020 21:37:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 96B51C433C6;
        Thu,  3 Dec 2020 21:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 96B51C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v14 3/4] docs: Add documentation for userspace client
 interface
To:     jhugo@codeaurora.org
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, hemantk=codeaurora.org@codeaurora.org
References: <1606877991-26368-1-git-send-email-hemantk@codeaurora.org>
 <1606877991-26368-4-git-send-email-hemantk@codeaurora.org>
 <86747d3a0e8555ee5369aaa3cb2ff947@codeaurora.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <7debf28b-e8d1-aba2-ae23-e47fa09e4f46@codeaurora.org>
Date:   Thu, 3 Dec 2020 13:37:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <86747d3a0e8555ee5369aaa3cb2ff947@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff

On 12/3/20 12:38 PM, jhugo@codeaurora.org wrote:
> On 2020-12-01 19:59, Hemant Kumar wrote:
>> MHI userspace client driver is creating device file node
>> for user application to perform file operations. File
>> operations are handled by MHI core driver. Currently
>> QMI MHI channel is supported by this driver.
>>
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> 
> Two minor nits below.  With those -
> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> 
>> ---
>>  Documentation/mhi/index.rst |  1 +
>>  Documentation/mhi/uci.rst   | 94 
>> +++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 95 insertions(+)
>>  create mode 100644 Documentation/mhi/uci.rst
>>
>> diff --git a/Documentation/mhi/index.rst b/Documentation/mhi/index.rst
>> index 1d8dec3..c75a371 100644
>> --- a/Documentation/mhi/index.rst
>> +++ b/Documentation/mhi/index.rst
>> @@ -9,6 +9,7 @@ MHI
>>
>>     mhi
>>     topology
>> +   uci
>>
>>  .. only::  subproject and html
>>
>> diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
>> new file mode 100644
>> index 0000000..9603f92
>> --- /dev/null
>> +++ b/Documentation/mhi/uci.rst
>> @@ -0,0 +1,94 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=================================
>> +Userspace Client Interface (UCI)
>> +=================================
>> +
>> +UCI driver enables userspace clients to communicate to external MHI 
>> devices
>> +like modem and WLAN. UCI driver probe creates standard character 
>> device file
>> +nodes for userspace clients to perform open, read, write, poll and 
>> release file
>> +operations. UCI device object represents UCI device file node which gets
>> +instantiated as part of MHI UCI driver probe. UCI channel object 
>> represents
>> +MHI uplink or downlink channel.
>> +
>> +Operations
>> +==========
>> +
>> +open
>> +----
>> +
>> +Instantiates UCI channel object and starts MHI channels to move it to 
>> running
>> +state. Inbound buffers are queued to downlink channel transfer ring. 
>> Every
>> +subsequent open() increments UCI device reference count as well as 
>> UCI channel
>> +reference count.
>> +
>> +read
>> +----
>> +
>> +When data transfer is completed on downlink channel, transfer ring 
>> element
>> +buffer is copied to pending list. Reader is unblocked and data is 
>> copied to
>> +userspace buffer. Transfer ring element buffer is queued back to 
>> downlink
>> +channel transfer ring.
>> +
>> +write
>> +-----
>> +
>> +Write buffer is queued to uplink channel transfer ring if ring is not
>> full. Upon
>> +uplink transfer completion buffer is freed.
>> +
>> +poll
>> +----
>> +
>> +Returns EPOLLIN | EPOLLRDNORM mask if pending list has buffers to be 
>> read by
>> +userspace. Returns EPOLLOUT | EPOLLWRNORM mask if MHI uplink channel 
>> transfer
>> +ring is not empty. Returns EPOLLERR when UCI driver is removed.
> 
> ring is not empty.  When the uplink channel transfer ring is non-empty, 
> more
> data may be sent to the device. Returns EPOLLERR when UCI driver is 
> removed.
Done
> 
>> +
>> +release
>> +-------
>> +
>> +Decrements UCI device reference count and UCI channel reference count 
>> upon last
>> +release(). UCI channel clean up is performed. MHI channel moves to 
>> disable
>> +state and inbound buffers are freed.
> 
> Decrements UCI device reference count and UCI channel reference count. 
> Upon last
> release() UCI channel clean up is performed. MHI channel moves to disable
> state and inbound buffers are freed.
Done.
> 
>> +
>> +Usage
>> +=====
>> +
>> +Device file node is created with format:-
>> +
>> +/dev/<mhi_device_name>
>> +
>> +mhi_device_name includes mhi controller name and the name of the MHI 
>> channel
>> +being used by MHI client in userspace to send or receive data using MHI
>> +protocol.
>> +
>> +There is a separate character device file node created for each channel
>> +specified in MHI device id table. MHI channels are statically defined 
>> by MHI
>> +specification. The list of supported channels is in the channel list 
>> variable
>> +of mhi_device_id table in UCI driver.
>> +
>> +Qualcomm MSM Interface(QMI) Channel
>> +-----------------------------------
>> +
>> +Qualcomm MSM Interface(QMI) is a modem control messaging protocol 
>> used to
>> +communicate between software components in the modem and other 
>> peripheral
>> +subsystems. QMI communication is of request/response type or an 
>> unsolicited
>> +event type. libqmi is userspace MHI client which communicates to a 
>> QMI service
>> +using UCI device. It sends a QMI request to a QMI service using MHI 
>> channel 14
>> +or 16. QMI response is received using MHI channel 15 or 17 
>> respectively. libqmi
>> +is a glib-based library for talking to WWAN modems and devices which 
>> speaks QMI
>> +protocol. For more information about libqmi please refer
>> +https://www.freedesktop.org/wiki/Software/libqmi/
>> +
>> +Usage Example
>> +~~~~~~~~~~~~~
>> +
>> +QMI command to retrieve device mode
>> +$ sudo qmicli -d /dev/mhi0_QMI --dms-get-model
>> +[/dev/mhi0_QMI] Device model retrieved:
>> +    Model: 'FN980m'
>> +
>> +Other Use Cases
>> +---------------
>> +
>> +Getting MHI device specific diagnostics information to userspace MHI 
>> diagnostic
>> +client using DIAG channel 4 (Host to device) and 5 (Device to Host).

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
