Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2049B454
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455955AbiAYMwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:52:07 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:39968 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1457437AbiAYMtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:49:51 -0500
HMM_SOURCE_IP: 172.18.0.218:48792.662813070
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-112.38.63.33 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id D15D1280029;
        Tue, 25 Jan 2022 20:37:29 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 9423f2faf0214720bbdbdc2eb317ba02 for nikolay@nvidia.com;
        Tue, 25 Jan 2022 20:37:34 CST
X-Transaction-ID: 9423f2faf0214720bbdbdc2eb317ba02
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <6f7b59b2-1d97-5257-f68b-1658cc5b7cc9@chinatelecom.cn>
Date:   Tue, 25 Jan 2022 20:37:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v9] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, huyd12@chinatelecom.cn
References: <20220125023755.94837-1-sunshouxin@chinatelecom.cn>
 <d0afa956-6852-2749-fce8-2a3e06cae556@nvidia.com>
 <8eac3258-8b2a-37eb-2a1e-6a71d5d1f859@nvidia.com>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <8eac3258-8b2a-37eb-2a1e-6a71d5d1f859@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/25 17:02, Nikolay Aleksandrov 写道:
> On 25/01/2022 10:51, Nikolay Aleksandrov wrote:
>> On 25/01/2022 04:37, Sun Shouxin wrote:
>>> Since ipv6 neighbor solicitation and advertisement messages
>>> isn't handled gracefully in bond6 driver, we can see packet
>>> drop due to inconsistency between mac address in the option
>>> message and source MAC .
>>>
>>> Another examples is ipv6 neighbor solicitation and advertisement
>>> messages from VM via tap attached to host bridge, the src mac
>>> might be changed through balance-alb mode, but it is not synced
>>> with Link-layer address in the option message.
>>>
>>> The patch implements bond6's tx handle for ipv6 neighbor
>>> solicitation and advertisement messages.
>>>
>>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>>> ---
>>>   drivers/net/bonding/bond_alb.c | 38 +++++++++++++++++++++++++++++++++-
>>>   1 file changed, 37 insertions(+), 1 deletion(-)
>>>
> [snip]
>
> Also forgot to mention, you should add a changelog between patch versions.
> You can add it below the --- marker so it won't be included in the commit
> message. Otherwise it's hard to track how the patch reached v9 and what
> changed between versions.
>
> E.g. v8 -> v9: <changed blah>
>
> Thanks,
>   Nik
>
>

Thanks your comment, I'll adjust it and send out V10 soon.


