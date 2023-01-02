Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5778965AF17
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 10:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjABJyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 04:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjABJyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 04:54:50 -0500
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E092BC;
        Mon,  2 Jan 2023 01:54:49 -0800 (PST)
Received: from iva8-3a65cceff156.qloud-c.yandex.net (iva8-3a65cceff156.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2d80:0:640:3a65:ccef])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 6AF605F0A0;
        Mon,  2 Jan 2023 12:54:47 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b5b0::1:24] (unknown [2a02:6b8:b081:b5b0::1:24])
        by iva8-3a65cceff156.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ksRUK61QoiE1-uYx9gRYe;
        Mon, 02 Jan 2023 12:54:46 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672653286; bh=TGzNlxppQdtMMzHwRUHhkNSEJQx7YR1su8g+aEl16r0=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=kwwxRPn2liOBFLhdlv3vTnXNXrnm5gz4qjU3s1e1NPl1dkjrCgrom1ICzD8biLz1/
         nz/hCzkHwdSnFX8YapM+oVR5ZXK8wFqf0ATdXWI6An8nqpRnfeusodJ1jjsrhalp68
         6f0dp11HgQGSnW0Y/2tpeoZe5hp9f/Y2Mwa7WxR0=
Authentication-Results: iva8-3a65cceff156.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <41d2beff-e705-933f-f6a0-cf8995107e5c@yandex-team.ru>
Date:   Mon, 2 Jan 2023 12:54:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RESEND PATCH net v1] drivers/net/bonding/bond_3ad: return when
 there's no aggregator
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221226084353.1914921-1-d-tatianin@yandex-team.ru>
 <20221229182227.5de48def@kernel.org>
 <a09b374f-45e3-9228-4846-80f655cf3caa@yandex-team.ru>
 <20221230195529.67a5266a@kernel.org>
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <20221230195529.67a5266a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/22 6:55 AM, Jakub Kicinski wrote:
> On Fri, 30 Dec 2022 11:44:02 +0300 Daniil Tatianin wrote:
>> On 12/30/22 5:22 AM, Jakub Kicinski wrote:
>>> On Mon, 26 Dec 2022 11:43:53 +0300 Daniil Tatianin wrote:
>>>> Otherwise we would dereference a NULL aggregator pointer when calling
>>>> __set_agg_ports_ready on the line below.
>>>
>>> Fixes tag, please?
>> Looks like this code was introduced with the initial git import.
>> Would that still be useful?
> 
> yessir, the point is to let backporters know how far the bug goes.
> The initial import is our local equivalent of infinity, for all
> practical purposes.
Gotcha, thanks for letting me know!
