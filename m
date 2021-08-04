Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6A3E08C6
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbhHDT1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 15:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240646AbhHDT1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 15:27:38 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2DFC0613D5;
        Wed,  4 Aug 2021 12:27:25 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id c24so3016210lfi.11;
        Wed, 04 Aug 2021 12:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aeX5Yd6JwKqCiwbiQzVvkp2YwIg8QqGHW1ckwfMGU2g=;
        b=ctld4TB9cbbC81xEonJWa+JT9683i6OjdFAxcdrSWNGlYbbrX+KT1WjdSQfi2G5LRE
         Ir6moEMgGnxr7NkBAD5IakXFDyLEh4BaupMmPXF8PdTa1GdZctiksynU+egnGdnakeyv
         jBjF4xAxVryUeU5cW3urruTp1TRof0PkeKqFzMt2VN7/XvTx2qwYDnKC/SUz1DwgP67t
         xca2uz3+CXcwO2XTUlVHq+MPlLhZjPnq2ZF+VtlKWZj2OMn4m5J7bmv+1j0Ht4gY9nu+
         yYBipJz46t/8Ajb6QvXh9ekLuY9aoSBC4IjjHuxxs3pa3JyVgZq3dD5S775d5hbEv3fa
         GRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aeX5Yd6JwKqCiwbiQzVvkp2YwIg8QqGHW1ckwfMGU2g=;
        b=G78oJhdDun9jr1yZQnrYrf0zOVF1PDpl44xbWdF+c/HdLSRC2X/36wubzhEV7Ml5KV
         M8CNeOk8X/DR2PZtrBqQw+PPHfA6qubDjzOpHQOf4zQETsd8iAk24tHNg9OSPxvoYfho
         Ac7VDLtJzQK1PiUlnsjZm/5jkGcIUv0XaLptxqmbvlNHfFCFA35zS3ujr+X44ZSmMDxT
         UGvc07B82ybBQhpYvVwGy2oKEjDYuyoFT9cwD3BL9Qi2pTA4j1chC/EnbUrt419necCm
         WW/H5Y1aVw7/hg2DyUmf+01qBysde1Ae41U5XqeaY0d0KqgGrFa2WkYOYAExHiOnmYoI
         gteg==
X-Gm-Message-State: AOAM53027ZBVKnprHuNh34Y8eGtlUWq1sv8RguTjnBRQeLUCDPtLtnYR
        YMfaS534pFRccFKesMdMXhQ=
X-Google-Smtp-Source: ABdhPJxc3SIa6dMQArNUj+ObQa0N7WU5zKF+oVCp1HCuFI8NrgeRQ9pNRi5fICP6vRpM8c5MB8y4Zw==
X-Received: by 2002:ac2:5938:: with SMTP id v24mr567382lfi.587.1628105243741;
        Wed, 04 Aug 2021 12:27:23 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.221])
        by smtp.gmail.com with ESMTPSA id j16sm14478ljc.71.2021.08.04.12.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 12:27:23 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <e740c0ee-dcf0-caf5-e80e-9588605a30b3@gmail.com>
 <OS0PR01MB592289FDA9AA20E5B033451E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <5a53ce65-5d6c-f7f2-861e-314869d2477d@gmail.com>
Date:   Wed, 4 Aug 2021 22:27:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB592289FDA9AA20E5B033451E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 8:57 AM, Biju Das wrote:

>> Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to
>> driver data
>>
>> On 8/2/21 1:26 PM, Biju Das wrote:
>>
>>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC
>>> are similar to the R-Car Ethernet AVB IP. With a few changes in the
>>> driver we can support both IPs.
>>>
>>> Currently a runtime decision based on the chip type is used to
>>> distinguish the HW differences between the SoC families.
>>>
>>> The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2
>>> and RZ/G2L it is 2. For cases like this it is better to select the
>>> number of TX descriptors by using a structure with a value, rather
>>> than a runtime decision based on the chip type.
>>>
>>> This patch adds the num_tx_desc variable to struct ravb_hw_info and
>>> also replaces the driver data chip type with struct ravb_hw_info by
>>> moving chip type to it.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>> v2:
>>>  * Incorporated Andrew and Sergei's review comments for making it
>> smaller patch
>>>    and provided detailed description.
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |  7 +++++
>>>  drivers/net/ethernet/renesas/ravb_main.c | 38
>>> +++++++++++++++---------
>>>  2 files changed, 31 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index 80e62ca2e3d3..cfb972c05b34 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -988,6 +988,11 @@ enum ravb_chip_id {
>>>  	RCAR_GEN3,
>>>  };
>>>
>>> +struct ravb_hw_info {
>>> +	enum ravb_chip_id chip_id;
>>> +	int num_tx_desc;

   How about leaving that field in the *struct* ravb_private? And adding the following instead:

	unsigned unaligned_tx: 1;

>>    I think this is rather the driver's choice, than the h/w feature...
>> Perhaps a rename would help with that? :-)
> 
> It is consistent with current naming convention used by the driver. NUM_TX_DESC macro is replaced by num_tx_desc and  the below run time decision based on chip type for H/W configuration for Gen2/Gen3 is replaced by info->num_tx_desc.
> 
> priv->num_tx_desc = chip_id == RCAR_GEN2 ? NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;

   .. and then:

	priv->num_tx_desc =  info->unaligned_tx ? NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;

> Please let me know, if I am missing anything,
> 
> Previously there is a suggestion to change the generic struct ravb_driver_data (which holds driver differences and HW features) with struct ravb_hw_info.

    Well, my plan was to place all the hardware features supported into the *struct* ravb_hw_info and leave all
the driver's software data in the *struct* ravb_private.

> Regards,
> Biju
[...]

MBR, Sergei
