Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A79387FF6
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 20:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351680AbhERSyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 14:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbhERSyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 14:54:31 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D496C061573;
        Tue, 18 May 2021 11:53:13 -0700 (PDT)
Received: from [2a04:4540:1402:9c00:2d8:61ff:fef0:a7c3]
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1lj4q3-0000KY-6N; Tue, 18 May 2021 20:53:07 +0200
Subject: Re: linux-next: Tree for May 18 (drivers/net/dsa/qca8k.c)
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <785e9083-174e-5287-8ad0-1b5b842e2282@infradead.org>
 <20210518164348.vbuxaqg4s3mwzp4e@skbuf> <YKP6YNUyo1K0ojqQ@lunn.ch>
From:   John Crispin <john@phrozen.org>
Message-ID: <bb88febd-19e8-6569-45d3-b0973bb89bfb@phrozen.org>
Date:   Tue, 18 May 2021 20:53:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKP6YNUyo1K0ojqQ@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.05.21 19:33, Andrew Lunn wrote:
>> Would something like this work?
>>
>> -----------------------------[ cut here ]-----------------------------
>> >From 36c0b3f04ebfa51e52bd1bc2dc447d12d1c6e119 Mon Sep 17 00:00:00 2001
>> From: Vladimir Oltean <olteanv@gmail.com>
>> Date: Tue, 18 May 2021 19:39:18 +0300
>> Subject: [PATCH] net: mdio: provide shim implementation of
>>   devm_of_mdiobus_register
>>
>> Similar to the way in which of_mdiobus_register() has a fallback to the
>> non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
>> a shim for the device-managed devm_of_mdiobus_register() which calls
>> devm_mdiobus_register() and discards the struct device_node *.
>>
>> In particular, this solves a build issue with the qca8k DSA driver which
>> uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> This should be O.K.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> Thanks
>      Andrew

Just did a x86 build with the patch applied and it completed ...

Acked-by: John Crispin <john@phrozen.org>

