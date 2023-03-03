Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331B06A9F96
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjCCSv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjCCSv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:51:57 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C654219;
        Fri,  3 Mar 2023 10:51:53 -0800 (PST)
Received: from [192.168.10.39] (unknown [182.179.171.187])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 75CF46602FB0;
        Fri,  3 Mar 2023 18:51:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1677869511;
        bh=6j5G1DzPfdDchQCrothO/vHHFj3+FwJJG8CYehazm/4=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=awW5Y02krkKBw8WR4fRsPzNJtePrV9cmCeVzyzfao0Xp/SWcqcF09g3bjXRL1+ixH
         QVeC8t2SvRVJt+nEjKQ2j9AnhLxzfmTEEhEwU+i/A+UZTj1Lw8rv5AhCcs8FEVvqyP
         ZTHmuQBfqsPD/BV8tDzYpeW29HeFMsuVZFntUZ2QpVunrDmYybv4y2ylE4yc5IJuTw
         bSRBJhmAGZEfd7ZDNYzLP2TDz+1G7ENv4sikDN9b7iuzSJWNvpv0o4CRw92mMz0v6w
         bV/rKusjMvfd5h8diSE3iu3afQxI2T8fVAdimJXdcicaGY//NdI9MM4+Dn10VmFBvH
         KUUbshbEsGUkQ==
Message-ID: <bc11e5ca-b259-8bfd-6d20-65eab089fbd0@collabora.com>
Date:   Fri, 3 Mar 2023 23:51:37 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qede: remove linux/version.h
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
References: <20230303125844.2050449-1-usama.anjum@collabora.com>
 <f29ae960-dea1-6754-3957-412e3c4d095c@intel.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <f29ae960-dea1-6754-3957-412e3c4d095c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/23 8:35 PM, Alexander Lobakin wrote:
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Date: Fri,  3 Mar 2023 17:58:44 +0500
> 
>> make versioncheck reports the following:
>> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
>> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
>>
>> So remove linux/version.h from both of these files.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> ---
>>  drivers/net/ethernet/qlogic/qede/qede.h         | 1 -
>>  drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 1 -
>>  2 files changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
>> index f90dcfe9ee68..6ff1bd48d2aa 100644
>> --- a/drivers/net/ethernet/qlogic/qede/qede.h
>> +++ b/drivers/net/ethernet/qlogic/qede/qede.h
>> @@ -7,7 +7,6 @@
>>  #ifndef _QEDE_H_
>>  #define _QEDE_H_
>>  #include <linux/compiler.h>
> 
> I think compiler.h is also unused, maybe this one too, while at it?'
Just checked, it is also not being used. I'll send v2.

> 
>> -#include <linux/version.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/interrupt.h>
>> diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
>> index 8034d812d5a0..374a86b875a3 100644
>> --- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
>> +++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
>> @@ -4,7 +4,6 @@
>>   * Copyright (c) 2019-2020 Marvell International Ltd.
>>   */
>>  
>> -#include <linux/version.h>
>>  #include <linux/types.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/etherdevice.h>
> 
> Thanks,
> Olek

-- 
BR,
Muhammad Usama Anjum
