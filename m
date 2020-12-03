Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400972CD843
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgLCNy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgLCNy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:54:57 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3855BC061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:54:11 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lt17so3603741ejb.3
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dZoNrIv6luoppB1moIu/G1luuav3IB0WKtYk1t6susw=;
        b=LYpEWPHfDqrC9YwMQyshIiEjce5BcSItpSX5YhpOE93vLaQOCbU1pk9guDLImSsk0Z
         pMpFdEKwJ8vLScBG/V+uihhfM5vqEVlWRSEHTPaXNF51AWdbJhk8DGFnzNU32M1O/XmJ
         wJnpOCPn8FsutWmSsbNIU3GJuRKkpaHswo4Obca6j3o//RbIZHJH0JYb1FCLOEIJAtqI
         ePsxmobQGeI39y0hskIzLGrfDvg345cXgv9yJi5B4qZccI5Rs8VlFgFF875PuFrKFZ/3
         W7vAiGqk7jiZql/C7puS0MFB7PKaDaSP9fiZ0lDwT52XYx0E3jjlPwFO1CY8B1xpiGI9
         GJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dZoNrIv6luoppB1moIu/G1luuav3IB0WKtYk1t6susw=;
        b=hj169u/nDoXIJyHXcw5hAAhm5syA4XIItS9Tfc+r9KlPIA7A/1wLsE/6l//OohAZxI
         XcRGKExM5FQ21Y0lkWTVdK++LDR1/6KD5cTAWid4v63N7/h/jVX0qTjXLIHP/c7KVOWT
         9WYTVnmJszkoiPddVpR1eksbMbr2iyKlnjMsPsOh0Q+3TOXcWmDs8tEOYWLCNqUqJ7QO
         eGxqoNsTD/6ViGyNU1/8hczROwPtv+mzueXCCXk/0b572Ih4ZS7H9tfEZ4mh82M1QnfW
         1Idu3ijHLeoXB0UGLDFBdQXu3oE9RdciPOFkChJT3lVBOC2mWV6UECYGkl/UL0Fe/Vxl
         OKyA==
X-Gm-Message-State: AOAM5306yKqFhiiMa31e+BzlKAfkk8nsnpW89iTe3ADJqf0+5uZfVHPf
        +rEuXsngFSAYS1doAlMcKPlBnw==
X-Google-Smtp-Source: ABdhPJwkVsPCSb91iSsgKGmzw52TfBcLend+JNm0Mk1QVeEMF5+Fsfi3yi3Ceu5PxGSut6zgHwpH5Q==
X-Received: by 2002:a17:906:b2d1:: with SMTP id cf17mr2656808ejb.281.1607003649968;
        Thu, 03 Dec 2020 05:54:09 -0800 (PST)
Received: from [10.8.0.46] (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id u19sm912447ejg.16.2020.12.03.05.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 05:54:09 -0800 (PST)
Subject: Re: [PATCH 2/4] net: freescale/fman-port: remove direct use of
 __devm_request_region
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201202161600.23738-1-patrick.havelange@essensium.com>
 <20201202161600.23738-2-patrick.havelange@essensium.com>
 <AM6PR04MB3976E5A576C3E1AA157DA711ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Patrick Havelange <patrick.havelange@essensium.com>
Message-ID: <6e64e64d-0bbe-bab6-72a1-db6a304858f6@essensium.com>
Date:   Thu, 3 Dec 2020 14:54:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB3976E5A576C3E1AA157DA711ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03 09:44, Madalin Bucur wrote:
>> -----Original Message-----
>> From: Patrick Havelange <patrick.havelange@essensium.com>
>> Sent: 02 December 2020 18:16
>> To: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
>> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: Patrick Havelange <patrick.havelange@essensium.com>
>> Subject: [PATCH 2/4] net: freescale/fman-port: remove direct use of
>> __devm_request_region
>>
>> This driver was directly calling __devm_request_region with a specific
>> resource on the stack as parameter. This is invalid as
>> __devm_request_region expects the given resource passed as parameter
>> to live longer than the call itself, as the pointer to the resource
>> will be stored inside the internal struct used by the devres
>> management.
>>
>> In addition to this issue, a related bug has been found by kmemleak
>> with this trace :
>> unreferenced object 0xc0000001efc01880 (size 64):
>>    comm "swapper/0", pid 1, jiffies 4294669078 (age 3620.536s)
>>    hex dump (first 32 bytes):
>>      00 00 00 0f fe 4a c0 00 00 00 00 0f fe 4a cf ff  .....J.......J..
>>      c0 00 00 00 00 ee 9d 98 00 00 00 00 80 00 02 00  ................
>>    backtrace:
>>      [<c000000000078874>] .alloc_resource+0xb8/0xe0
>>      [<c000000000079b50>] .__request_region+0x70/0x1c4
>>      [<c00000000007a010>] .__devm_request_region+0x8c/0x138
>>      [<c0000000006e0dc8>] .fman_port_probe+0x170/0x420
>>      [<c0000000005cecb8>] .platform_drv_probe+0x84/0x108
>>      [<c0000000005cc620>] .driver_probe_device+0x2c4/0x394
>>      [<c0000000005cc814>] .__driver_attach+0x124/0x128
>>      [<c0000000005c9ad4>] .bus_for_each_dev+0xb4/0x110
>>      [<c0000000005cca1c>] .driver_attach+0x34/0x4c
>>      [<c0000000005ca9b0>] .bus_add_driver+0x264/0x2a4
>>      [<c0000000005cd9e0>] .driver_register+0x94/0x160
>>      [<c0000000005cfea4>] .__platform_driver_register+0x60/0x7c
>>      [<c000000000f86a00>] .fman_port_load+0x28/0x64
>>      [<c000000000f4106c>] .do_one_initcall+0xd4/0x1a8
>>      [<c000000000f412fc>] .kernel_init_freeable+0x1bc/0x2a4
>>      [<c00000000000180c>] .kernel_init+0x24/0x138
>>
>> Indeed, the new resource (created in __request_region) will be linked
>> to the given resource living on the stack, which will end its lifetime
>> after the function calling __devm_request_region has finished.
>> Meaning the new resource allocated is no longer reachable.
>>
>> Now that the main fman driver is no longer reserving the region
>> used by fman-port, this previous hack is no longer needed
>> and we can use the regular call to devm_request_mem_region instead,
>> solving those bugs at the same time.
>>
>> Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
>> ---
>>   drivers/net/ethernet/freescale/fman/fman_port.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c
>> b/drivers/net/ethernet/freescale/fman/fman_port.c
>> index d9baac0dbc7d..354974939d9d 100644
>> --- a/drivers/net/ethernet/freescale/fman/fman_port.c
>> +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
>> @@ -1878,10 +1878,10 @@ static int fman_port_probe(struct platform_device
>> *of_dev)
>>
>>   	of_node_put(port_node);
>>
>> -	dev_res = __devm_request_region(port->dev, &res, res.start,
>> -					resource_size(&res), "fman-port");
>> +	dev_res = devm_request_mem_region(port->dev, res.start,
>> +					  resource_size(&res), "fman-port");
>>   	if (!dev_res) {
>> -		dev_err(port->dev, "%s: __devm_request_region() failed\n",
>> +		dev_err(port->dev, "%s: devm_request_mem_region() failed\n",
>>   			__func__);
>>   		err = -EINVAL;
>>   		goto free_port;
>> --
>> 2.17.1
> 
> Hi Patrick,
> 
> please send a fix for the issue, targeting the net tree, separate from the
> other change you are trying to introduce. We need a better explanation for
> the latter and it should go through the net-next tree, if accepted.

Hello,

I've resent the series with a cover letter having a bit more 
explanations. I think all the patches should be applied on net, as they 
are linked to the same issue/resolution, and are not independent.

BR,

Patrick H.
