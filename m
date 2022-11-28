Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637CD63B316
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiK1U0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiK1U0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:26:36 -0500
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6598D2A716
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:26:35 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NLcST6gX3zMq1bD;
        Mon, 28 Nov 2022 21:26:33 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NLcST1y5Zz3k;
        Mon, 28 Nov 2022 21:26:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669667193;
        bh=YqcNXrKaAlxhqionIjbyNsZo++LGjCpVcQspBlaq0Ms=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=u8y1cgqTfGdQe9v+kJbCD3WkHMclZy4FXsYWb/FCa0e5zg6lCweakavpXVcs3V5Je
         4D9iwrxe5CwicIklKLeRtP7BuEYYG9YO1cGW2qCU5pnGyMdrRclsg1HEFxh4woHAAP
         x4/IqWYRkAk9QuKm75OesXQci+E+u6NhQVzPzdu0=
Message-ID: <3e799f21-85f9-1b1d-c65e-3f9c7e4708aa@digikod.net>
Date:   Mon, 28 Nov 2022 21:26:32 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 11/12] samples/landlock: Add network demo
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-12-konstantin.meskhidze@huawei.com>
 <2ff97355-18ef-e539-b4c1-720cd83daf1d@digikod.net>
 <a25b23f5-ad58-8374-249e-84ec0177e74a@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <a25b23f5-ad58-8374-249e-84ec0177e74a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/11/2022 03:49, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/16/2022 5:25 PM, Mickaël Salaün пишет:
>>
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>> This commit adds network demo. It's possible to allow a sandboxer to
>>> bind/connect to a list of particular ports restricting network
>>> actions to the rest of ports.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---

[...]

>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_BIND_TCP;
>>> +	}
>>> +	/* Removes connect access attribute if not supported by a user. */
>>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>>> +	if (!env_port_name) {
>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>> +	}
>>> +	ruleset_attr.handled_access_net &= access_net_tcp;
>>
>> There is no need for access_net_tcp.
> 
>     Do you mean to delete this var?

Yes
