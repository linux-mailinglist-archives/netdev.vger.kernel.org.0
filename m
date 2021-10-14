Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F178942D84C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhJNLiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhJNLiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 07:38:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E345EC061753
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 04:36:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g25so18465443wrb.2
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 04:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U4ipNp1A1LkMViR5fSWkLGWj7ewgxV9un8v72sPWhJc=;
        b=DItIv86tnWADRqJzyKzy+oAcUa2ya/iQpu1rwxuulp2coeAPnD/mho9YrUfGb+ty+A
         Ti/+YvHte5NH9CdBkLxOEFhercMmkFrOCgr0QW4ZJcl4zvk3hf1I9ka6oz9iY87yhXtc
         YJJg7eB4SQUamwGVH3dBPpY0thQ5mwlx+azcKG0KfsleorNRgGHpbRc2wrvyqWkbuTNK
         ZTMKokfuOjmtIjQ5kqtk0TpRqhU7Pwpf8SCjW7eUH+GHtfHQFxCC2FU6Qr/MJIAW3oOx
         0NE22OSmm2e+y/VD4EKxZjN909xkrWNIW6G9EercCpQjxFGWosV/PZKI08rGKWEk2jJC
         hjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U4ipNp1A1LkMViR5fSWkLGWj7ewgxV9un8v72sPWhJc=;
        b=VRMzSHdKtoQbaaVqKR3Pe4t9ssZhzC/A5uTybhD71fBW1f9RMSUEMx/H1X4QxNrmmJ
         b/pXeAL25YJH3XRnMVtmDzp8t4Ufgzv5CBth19pZPRt2MT/LTFOy6wKLzTULYBf7kEUz
         yuS6WUhhMMqEg3EuolQii8skdbjFOmuwmNlSbIWhTBdoyDC7kD3sQogI2PC0w+BVd9QF
         wqlGPDwMdiggMBIq125NCHhSF+fDlc7mvaajE28t12n3pOvAqyYHqdWXUWKHVTehCR3H
         InvWddtkHqsfxWZMFOqYY4NIn6waoobFTp2SdhSmlp57eFvVFZRpW5N38rnkKWaFeYT4
         0o2g==
X-Gm-Message-State: AOAM532MuHCvsSvtS8oHGvAcuok+5PKtPHKCUQTym8gf0YxT+eGBsp6x
        Qs//82e0ZL76/0d+DOacHW/cRQ==
X-Google-Smtp-Source: ABdhPJzT+LXujsr3qpAYh2Qv2HXhFIwBYT8OJSpU1B7hW6sUiYucP3cOYtMJmYa4GK+BbZxExtRdpw==
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr5337436wmi.122.1634211372424;
        Thu, 14 Oct 2021 04:36:12 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id g2sm2199373wrb.20.2021.10.14.04.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 04:36:12 -0700 (PDT)
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot
 environment NVMEM provider
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        U-Boot Mailing List <u-boot@lists.denx.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luka Kovacic <luka.kovacic@sartura.hr>
References: <20211013232048.16559-1-kabel@kernel.org>
 <629c8ba1-c924-565f-0b3c-8b625f4e5fb0@linaro.org>
 <20211014120601.133e9a84@dellmb>
 <857c27a6-5c4b-e0ed-a830-35762799613f@linaro.org>
 <20211014125526.10d4861b@dellmb>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <d2c0d673-440d-9e58-82b4-a73740a9c180@linaro.org>
Date:   Thu, 14 Oct 2021 12:36:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014125526.10d4861b@dellmb>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/10/2021 11:55, Marek Behún wrote:
> On Thu, 14 Oct 2021 11:30:13 +0100
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
> 
>> On 14/10/2021 11:06, Marek Behún wrote:
>>> On Thu, 14 Oct 2021 09:26:27 +0100
>>> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
>>>    
>>>> On 14/10/2021 00:20, Marek Behún wrote:
>>>>> Add device tree bindings for U-Boot environment NVMEM provider.
>>>>>
>>>>> U-Boot environment can be stored at a specific offset of a MTD
>>>>> device, EEPROM, MMC, NAND or SATA device, on an UBI volume, or in
>>>>> a file on a filesystem.
>>>>>
>>>>> The environment can contain information such as device's MAC
>>>>> address, which should be used by the ethernet controller node.
>>>>>       
>>>>
>>>> Have you looked at
>>>> ./Documentation/devicetree/bindings/mtd/partitions/nvmem-cells.yaml
>>>> ?
>>>
>>> Hello srini,
>>>
>>> yes, I have. What about it? :)
>>>
>>> That binding won't work for u-boot-env, because the data are stored
>>> in a different way. A cell does not have a constant predetermined
>>> offset on the MTD.
>>
>> Can't you dynamically update the nodes before nvmem-provider is
>> registered?
> 
> Are you talking about dynamically updating nvmem-cell OF nodes, adding
> reg properties with actual offsets and lengths found after parsing?

Yes, atleast for the nodes that are defined in the dt.

> 
>>> The variables are stored as a sequence of values of format
>>> "name=value", separated by '\0's, for example:
>>>     board=turris_mox\0ethaddr=00:11:22:33:44:55\0bootcmd=run
>>> distro_bootcmd\0.... Chaning lengths of values of variables, or
>>> deleting variables, moves the data around. Integers and MAC
>>> addresses are stored as strings, and so on.
>>
>> Do you already have a provider driver for handing this.
> 
> Not yet, I will send the proposal together with a driver in next
> round.
> 
>> How is pre parsing cell info and post processing data planned to be
>> handled?
> 
> My plan was to read the variables from the u-boot-env partition, create
> a nvmem-cell for each variable, and then pair the ones mentioned in
> device tree with their DT nodes, and post-process according to type
Adding cells using nvmem_cell_info should work. I think pairing the one 
with DT entries is something that is missing. Currently nvmem_cell_info 
does not have device_node pointer may be that is something that could be 
added to help here.


> (post-processing would be done only for those mentioned in device tree,
> others would be left as strings).
> 
>> Currently in nvmem core we do check for "reg" property for each cell,
>> unless the provider driver is adding/updating dt entries dynamically
>> before registering nvmem provider
> 
> I don't think updaring DT entries dynamically is a correct solution at
> all. Is this done in Linux? Updating device properties is something
> different, but changing DT properties seems wrong to me.
> 
>> It will not work as it is. Alteast this is what I suggested in similar
>> case where cell information is in tlv format.
> 
> Hmm. OK, I shall try to implement a driver for this and then will
> return to you.

Sounds good.

> 
>> Secondly mac-address seems to be delimited, we recently introduced
>> post processing callback for provider driver [1], which should help
>> in this case.
> 
> Cool, I shall use that.
yes, please it should show up in 5.16 anyway.

> 
>> If the nvmem-cell names are standard like "mac-address" then you do
>> not need to add a new "type" binding to cell too, you can do
>> post-processing based on name.
> 
> I plan to add functions
>    of_nvmem_get_mac_address()
>    nvmem_get_mac_address()
we already have nvmem_get_mac_address() in  ./net/ethernet/eth.c that 
looks for mac-address.

--srini
> which would look at (in this order):
>    mac-address, address, mac-address-backup
> We have to keep the name "address" for backwards compatibility with one
> driver that uses this (drivers/net/ethernet/ni/nixge.c)
> 
> Thanks.
> 
> Marek
> 
