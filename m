Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AA8656524
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 22:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiLZVYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 16:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiLZVYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 16:24:51 -0500
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5696610FB
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 13:24:48 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NgrQj4ZknzMqNY5;
        Mon, 26 Dec 2022 22:24:45 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NgrQh6DhwzMppL7;
        Mon, 26 Dec 2022 22:24:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1672089885;
        bh=CQRg1XvyqHQkoGMl7AC7PUYFJxNFyGTAtH2hnB5ZPU4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=n62tLGjZkMXhYCThuFRidZvkEhv9kyYTj6iXt5mBqDCjHYGzXxsQRdLPfHzhH0vnp
         e1Nre+wNnlZe9JDnC9csOoFCJoTPW2kpZIM/sx471tSRmtpoXOQ8tdDKxgcg3tut+D
         fmw6YEmgUklMWm80bOpsNnUHeCfrdJGYRBDyVP1s=
Message-ID: <6a1c9471-6fb3-792d-1e9b-d78884162ef5@digikod.net>
Date:   Mon, 26 Dec 2022 22:24:43 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH] landlock: Allow filesystem layout changes for domains
 without such rule type
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net>
 <20221117185509.702361-1-mic@digikod.net>
 <fb9a288a-aa86-9192-e6d7-d6678d740297@digikod.net>
 <4b23de18-2ae9-e7e3-52a3-53151e8802f9@huawei.com>
 <fd4c0396-af56-732b-808b-887c150e5e6b@digikod.net>
 <dc0de995-00dc-9dd7-a783-f57b2c274cb2@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <dc0de995-00dc-9dd7-a783-f57b2c274cb2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/12/2022 04:10, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/28/2022 11:23 PM, Mickaël Salaün пишет:
>>
>> On 28/11/2022 04:04, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 11/18/2022 12:16 PM, Mickaël Salaün пишет:
>>>> Konstantin, this patch should apply cleanly just after "01/12 landlock:
>>>> Make ruleset's access masks more generic". You can easily get this patch
>>>> with https://git.kernel.org/pub/scm/utils/b4/b4.git/
>>>> Some adjustments are needed for the following patches. Feel free to
>>>> review this patch.
>>        Do you have this patch online? Can I fetch it from your repo?
>>
>> You can cherry-pick from here: https://git.kernel.org/mic/c/439ea2d31e662
> 
> Hi Mickaёl.
> 
> Sorry for the delay. I was a bit busy with another task. Now I'm
> preparing a new patch.
> 
> I tried to apply your one but I got an error opening this the link : Bad
> object id: 439ea2d31e662.
> 
> Could please check it?

Try this link: 
https://git.kernel.org/mic/c/439ea2d31e662e586db659a9f01b7dd55848c035
I pushed it to the landlock-net-v8.1 branch.
