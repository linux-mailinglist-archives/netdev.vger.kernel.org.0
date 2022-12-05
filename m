Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914496428BC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiLEMsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiLEMru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:47:50 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988B2273B;
        Mon,  5 Dec 2022 04:47:46 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 0EEE56601DEB;
        Mon,  5 Dec 2022 12:47:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1670244464;
        bh=IX5+K1rvElPGfl6ayfERS9NPL9dQCiYw7XQDBInKEz8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fFPkiPGfeySh6X8ZoJnx7dFwSc32Woq7Me11PLLB+sprLgTD4njuPtQOZWDYOiCZU
         9u4FqjLPyXF7tRv0zJTpo+q3FTCgyq07C3uEiaDJdq7CJt9HgkP6Z4i8ino05LwUUl
         rDPR+2565rCOACH4tdU7SzaOodt/LWoFcRWRt0xS+kkJUU6cctKLK7CD8HETX0cHcq
         7Uo4qz9AauL3IzA6vWnxHpBZvPptbGFfiUZ3PKaMzI/sJSgq8Bh4RI6sGPSdr9AZlh
         7sAyzKaz39pFEca9cBE2RnaMAe5HRF+A4JrxlcjZ6cGw9da5DFdO5L2uAxusQ/c2CI
         s4IeZKrN/CFIQ==
Message-ID: <4411cfd9-7286-32fd-2032-622caa099e91@collabora.com>
Date:   Mon, 5 Dec 2022 13:47:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v1 01/13] net: wwan: tmi: Add PCIe core
Content-Language: en-US
To:     =?UTF-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     =?UTF-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        "linuxwwan@mediatek.com" <linuxwwan@mediatek.com>,
        =?UTF-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        =?UTF-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?UTF-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        =?UTF-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        =?UTF-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        =?UTF-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?UTF-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        =?UTF-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>,
        =?UTF-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?UTF-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
 <20221122111152.160377-2-yanchao.yang@mediatek.com>
 <1cca2790-5805-b4fc-f8e8-2c490db487f6@collabora.com>
 <e7d3bfeed57157e8859a24f501b7efb74e21f0f9.camel@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <e7d3bfeed57157e8859a24f501b7efb74e21f0f9.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 05/12/22 13:40, Yanchao Yang (杨彦超) ha scritto:
> On Thu, 2022-11-24 at 12:06 +0100, AngeloGioacchino Del Regno wrote:
>> Il 22/11/22 12:11, Yanchao Yang ha scritto:
>>> From: MediaTek Corporation <linuxwwan@mediatek.com>
>>>
>>> Registers the TMI device driver with the kernel. Set up all the
>>> fundamental
>>> configurations for the device: PCIe layer, Modem Host Cross Core
>>> Interface
>>> (MHCCIF), Reset Generation Unit (RGU), modem common control
>>> operations and
>>> build infrastructure.
>>>
>>> * PCIe layer code implements driver probe and removal, MSI-X
>>> interrupt
>>> initialization and de-initialization, and the way of resetting the
>>> device.
>>> * MHCCIF provides interrupt channels to communicate events such as
>>> handshake,
>>> PM and port enumeration.
>>> * RGU provides interrupt channels to generate notifications from
>>> the device
>>> so that the TMI driver could get the device reset.
>>> * Modem common control operations provide the basic read/write
>>> functions of
>>> the device's hardware registers, mask/unmask/get/clear functions of
>>> the
>>> device's interrupt registers and inquiry functions of the device's
>>> status.
>>>
>>> Signed-off-by: Ting Wang <ting.wang@mediatek.com>
>>> Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
> 
> Hello Angelo,
> 
>> Hello Yanchao,
>> thanks for the patch! However, there are some things to improve...
>>
>> First of all, you have to signoff (in your name) all patches that you
>> send.
> 
> Thank your suggestion. Fix it next version (add Signed-off-by: Yanchao
> Yang <yanchao.yang@mediatek.com> for all patches)
>> Check below for more comments...
>>
>>> ---

..snip.. :-)

There's a misunderstanding here: when I write

"..snip.."

I mean "I'm snipping out lines of code for which I have no comments, or
for which comments are redundant"

I do that to increase readability of reviews and decrease the size of the
mail that's going out, nothing else.

>>
>>> +	u32 (*read32)(struct mtk_md_dev *mdev, u64 addr);
>>
>> ..snip..
> 
> do you mean we should remove read function wrapper?

No, that's fine.

Regards,
Angelo
