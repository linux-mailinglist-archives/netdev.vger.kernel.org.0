Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F4012927
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfECH40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:56:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfECH40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 03:56:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4D0A7611FA; Fri,  3 May 2019 07:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556870184;
        bh=aDusQfMCjBF3dgdzRMthBxZkCv+AeRrwz8Z7d1VTjKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DRWkNWGAu7exQ3h4FFMC4HoxLk3WlgQ/prXDPdGrKGq5XEuvhLMmnMIPJ1UONp8JC
         IdJpXD8luIkdRlg7tK31E6NdUm18rXc2veqcjehjof7wFxNnycWsn374j87pL4PYKx
         S5ZJI5UEoCvkrtHRpSkMAyzXyE5mlDnEnPQ304r4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 27FBB61112;
        Fri,  3 May 2019 07:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556870183;
        bh=aDusQfMCjBF3dgdzRMthBxZkCv+AeRrwz8Z7d1VTjKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ap9zuQAHsDHkRvSiCgmkJ2xd96WFTtPhOLcWJKSupjL2AXB/QnOa3Uiscn8bktcLW
         O97hFHWI9+1QUfaKMxREaqDRACQuVHq+3rgFBBnFdhz14nHSTQ/AhQDpBq1Qa/92Lo
         lzvQm+MogmNpc7fsLW72XQ3a/D8ky3sau1reA4Zk=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 03 May 2019 15:56:23 +0800
From:   Rocky Liao <rjliao@codeaurora.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Thierry Escande <thierry.escande@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        linux-bluetooth-owner@vger.kernel.org
Subject: Re: [PATCH v3 2/2] dt-bindings: net: bluetooth: Add device property
 firmware-name for QCA6174
In-Reply-To: <60C7AC89-37B6-441C-9349-BCB15717EB2C@holtmann.org>
References: <1554368908-22017-2-git-send-email-rjliao@codeaurora.org>
 <1554888476-17560-1-git-send-email-rjliao@codeaurora.org>
 <A85D7982-E000-4A5F-9927-CA36E0BA60F2@holtmann.org>
 <7e0cf9ba98260309c43d9d6e63dead6c@codeaurora.org>
 <CAL_JsqLnM4XqQTCT7VTUSmukujz0VHJoCbXMF2--RmTEx_LZww@mail.gmail.com>
 <60C7AC89-37B6-441C-9349-BCB15717EB2C@holtmann.org>
Message-ID: <17221139821fb6ee35f3119df7405401@codeaurora.org>
X-Sender: rjliao@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On 2019-04-27 13:59, Marcel Holtmann wrote:
> Hi Rob,
> 
>>>>> This patch adds an optional device property "firmware-name" to 
>>>>> allow
>>>>> the
>>>>> driver to load customized nvm firmware file based on this property.
>>>>> 
>>>>> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
>>>>> ---
>>>>> Changes in v3:
>>>>> * added firmware-name instead of nvm-postfix to specify full 
>>>>> firmware
>>>>> name
>>>>> ---
>>>>> Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 2 ++
>>>>> 1 file changed, 2 insertions(+)
>>>>> 
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>>>> b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>>>> index 824c0e2..2bcea50 100644
>>>>> --- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>>>> +++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>>>> @@ -16,6 +16,7 @@ Optional properties for compatible string
>>>>> qcom,qca6174-bt:
>>>>> 
>>>>> - enable-gpios: gpio specifier used to enable chip
>>>>> - clocks: clock provided to the controller (SUSCLK_32KHZ)
>>>>> + - firmware-name: specify the name of nvm firmware to load
>>>>> 
>>>>> Required properties for compatible string qcom,wcn3990-bt:
>>>>> 
>>>>> @@ -39,6 +40,7 @@ serial@7570000 {
>>>>> 
>>>>>             enable-gpios = <&pm8994_gpios 19 GPIO_ACTIVE_HIGH>;
>>>>>             clocks = <&divclk4>;
>>>>> +            firmware-name = "nvm_00440302.bin";
>>>>>     };
>>>> 
>>>> and how is this a firmware-name property. Wouldn’t this be more like
>>>> nvm-file or something along these lines. This really needs to be
>>>> cleared with Rob to pick the right property name.
>>>> 
>>>> Regards
>>>> 
>>>> Marcel
>>> 
>>> Hi Rob,
>>> 
>>> Are you OK to use a property name "nvm-file" or "firmware-nvm-file"?
>>> Actually we have two firmware files, one is the patch file which is
>>> common to all of the products, the other is the nvm file which is
>>> customized. Using a "nvm-file" or "firmware-nvm-file" property name
>>> would be more clear.
>> 
>> 'firmware-name' is the standard name for specifying firmware file 
>> names.
> 
> but it is not a firmware file, it is a NVM file. What happens if in
> the future they need a firmware file and a NVM file?
> 
> Regards
> 
> Marcel

We won't need to specify a rampatch firmware file in future as it's a 
same file for all the boards with same chip, only the NVM firmware file 
may have board differences. NVM file is also one of the firmware files 
so I think it should be OK to use "firmware-name" property to specify 
it.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
