Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89A66431C5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiLETRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiLETRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:17:03 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D37264AC;
        Mon,  5 Dec 2022 11:15:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670267721; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=NP/gnuKezwin1OHhYsmf2ATZliiOCtNCFKoXTYzLH7BFyOXHMSzChcl0T1Aq6Pk013EOTEhIPVieqJNyp/ZJg6CkUw2KbYe8Yo64vRDV1jNfsHr8MQrm2pCXhKvILdIveTXCkSv4z8oUySkngPWB9Aj+wkEduOwp5bjcBSAy3CI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670267721; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=lfH3IahUHjmYwDm63oJKTTzFOCu7YAYcClnY9WZt9/M=; 
        b=FXv3K4z7UYzBQRGqigcbQsO6xLWN3XHlu+cOWnwRJOjJu1SFe0oJKDsZYueickpcKAvjBEPiXvqafpZvFtlVADDaBNIpaqvIoAaUqMJRQ7woVTe1iw1V4ivnPHuxXQBvvTiyLYF5wCwoE1GkelmMU17vheDC+7Hb2B8/5bj3YT0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1670267721;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=lfH3IahUHjmYwDm63oJKTTzFOCu7YAYcClnY9WZt9/M=;
        b=dsN8wK9uZkXcvK0LcXsBL/whokUfqHcwWsBtyrf7LCsT70tQrOkp9jhT1L/vza5v
        hhbPaQrT8B7iBg2bkmYRsZ7tdVz2tSl7Eonp9P1UorLvtWlwa4jXRRLcpZ+Ik+CZbb0
        IhoZEhANl+xsjiDyuKj7y4imOoyytUA0lMvhMrwc=
Received: from [192.168.100.172] (86.121.172.71 [86.121.172.71]) by mx.zohomail.com
        with SMTPS id 1670267720324784.9784413037605; Mon, 5 Dec 2022 11:15:20 -0800 (PST)
Message-ID: <84ce6297-5aff-4d6e-8d31-da3f25dc8690@arinc9.com>
Date:   Mon, 5 Dec 2022 22:15:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5/5] powerpc: dts: remove label = "cpu" from DSA
 dt-binding
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Rob Herring <robh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-6-arinc.unal@arinc9.com>
 <87a647s8zg.fsf@mpe.ellerman.id.au> <20221201173902.zrtpeq4mkk3i3vpk@pali>
 <20221201234400.GA1692656-robh@kernel.org>
 <20221202193552.vehqk6u53n36zxwl@pali>
 <20221204185924.a4q6cifhpyxaur6f@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20221204185924.a4q6cifhpyxaur6f@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4.12.2022 21:59, Vladimir Oltean wrote:
> Hi Pali,
> 
> On Fri, Dec 02, 2022 at 08:35:52PM +0100, Pali Rohár wrote:
>> On Thursday 01 December 2022 17:44:00 Rob Herring wrote:
>>> On Thu, Dec 01, 2022 at 06:39:02PM +0100, Pali Rohár wrote:
>>>> I was told by Marek (CCed) that DSA port connected to CPU should have
>>>> label "cpu" and not "cpu<number>". Modern way for specifying CPU port is
>>>> by defining reference to network device, which there is already (&enet1
>>>> and &enet0). So that change just "fixed" incorrect naming cpu0 and cpu1.
>>>>
>>>> So probably linux kernel does not need label = "cpu" in DTS anymore. But
>>>> this is not the reason to remove this property. Linux kernel does not
>>>> use lot of other nodes and properties too... Device tree should describe
>>>> hardware and not its usage in Linux. "label" property is valid in device
>>>> tree and it exactly describes what or where is this node connected. And
>>>> it may be used for other systems.
>>>>
>>>> So I do not see a point in removing "label" properties from turris1x.dts
>>>> file, nor from any other dts file.
>>>
>>> Well, it seems like a bit of an abuse of 'label' to me. 'label' should
>>> be aligned with a sticker or other identifier identifying something to a
>>> human. Software should never care what the value of 'label' is.
>>
>> But it already does. "label" property is used for setting (initial)
>> network interface name for DSA drivers. And you can try to call e.g.
>> git grep '"cpu"' net/dsa drivers/net/dsa to see that cpu is still
>> present on some dsa places (probably relict or backward compatibility
>> before eth reference).
> 
> Can you try to eliminate the word "probably" from the information you
> transmit and be specific about when did the DSA binding parse or require
> the 'label = "cpu"' property for CPU ports in any way?

As Jonas (on CC) pointed out, I only see this being used in the swconfig 
b53 driver which uses the label to identify the cpu port.

https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/generic/files/drivers/net/phy/b53/b53_common.c;h=87d731ec3e2a868dc8389f554b1dc9ab42c30be2;hb=HEAD#l1508

Maybe this got into DSA dt-bindings unchecked before it was decided to 
move forward with DSA instead of swconfig on Linux.

Arınç
