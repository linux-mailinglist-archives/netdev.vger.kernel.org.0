Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145701D7FAB
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgERRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:08:10 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37781 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERRIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:08:10 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Qlp00LWgz1qrfg;
        Mon, 18 May 2020 19:08:08 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Qlnz6zBnz1qrhp;
        Mon, 18 May 2020 19:08:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 0sBR0ZX5XnW7; Mon, 18 May 2020 19:08:06 +0200 (CEST)
X-Auth-Info: C8Y2qSw4cFlzqmHkvxHhSlUHWIqjF91M5wKa2d1ckzc=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 18 May 2020 19:08:06 +0200 (CEST)
Subject: Re: [PATCH V6 20/20] net: ks8851: Drop define debug and pr_fmt()
To:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200517003354.233373-1-marex@denx.de>
 <20200517003354.233373-21-marex@denx.de>
 <bd3a3e31d17146965c5a0ff7228cb00ec46f4edb.camel@perches.com>
 <7447d18e-cd81-b98e-a0d9-1059b60a3cf0@denx.de>
 <a27c9079fb257b90382f3af7e071078ab5948eb2.camel@perches.com>
 <125652bf-45e6-f380-2754-628075526109@denx.de>
 <11c77ba05a8951d0c269c7f3a7b7e2695f59ebc4.camel@perches.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <d8dcad60-2953-fa52-268d-60a0cc9a58fa@denx.de>
Date:   Mon, 18 May 2020 19:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <11c77ba05a8951d0c269c7f3a7b7e2695f59ebc4.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 4:55 AM, Joe Perches wrote:
> On Sun, 2020-05-17 at 04:47 +0200, Marek Vasut wrote:
>> On 5/17/20 4:37 AM, Joe Perches wrote:
>>> On Sun, 2020-05-17 at 04:28 +0200, Marek Vasut wrote:
>>>> On 5/17/20 4:01 AM, Joe Perches wrote:
>>>>> On Sun, 2020-05-17 at 02:33 +0200, Marek Vasut wrote:
>>>>>> Drop those debug statements from both drivers. They were there since
>>>>>> at least 2011 and enabled by default, but that's likely wrong.
>>>>> []
>>>>>> diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
>>>>> []
>>>>>> -#define DEBUG
>>>>>
>>>>> Dropping the #define DEBUG lines will cause a behavior
>>>>> change for the netdev/netif_dbg uses as these messages
>>>>> will no longer be output by default.
>>>>
>>>> Is that a problem ?
>>>
>>> Dunno.  I don't use nor debug these drivers.
>>>
>>
>> I don't use those debug messages either, so it's not a problem for me.
> 
> Just mention it in the changelog please.

Or let's just drop this patch for now.

I am still waiting for a clear direction on the indirect accessors.
