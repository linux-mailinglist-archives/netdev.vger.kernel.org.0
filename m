Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A210A21BCDA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgGJSSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgGJSSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:18:17 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A900C08C5DC;
        Fri, 10 Jul 2020 11:18:17 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 0698EBC117;
        Fri, 10 Jul 2020 18:18:12 +0000 (UTC)
Subject: Re: [PATCH] MAINTAINERS: XDP: restrict N: and K:
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Joe Perches <joe@perches.com>,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, mchehab+huawei@kernel.org,
        robh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200709194257.26904-1-grandmaster@al2klimov.de>
 <d7689340-55fc-5f3f-60ee-b9c952839cab@iogearbox.net>
 <19a4a48b-3b83-47b9-ac48-e0a95a50fc5e@al2klimov.de>
 <7d4427cc-a57c-ca99-1119-1674d509ba9d@iogearbox.net>
 <a2f48c734bdc6b865a41ad684e921ac04b221821.camel@perches.com>
 <875zavjqnj.fsf@toke.dk>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <458f6e74-b547-299a-4255-4c1e20cdba1b@al2klimov.de>
Date:   Fri, 10 Jul 2020 20:18:12 +0200
MIME-Version: 1.0
In-Reply-To: <875zavjqnj.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 10.07.20 um 18:12 schrieb Toke Høiland-Jørgensen:
> Joe Perches <joe@perches.com> writes:
> 
>> On Fri, 2020-07-10 at 17:14 +0200, Daniel Borkmann wrote:
>>> On 7/10/20 8:17 AM, Alexander A. Klimov wrote:
>>>> Am 09.07.20 um 22:37 schrieb Daniel Borkmann:
>>>>> On 7/9/20 9:42 PM, Alexander A. Klimov wrote:
>>>>>> Rationale:
>>>>>> Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
>>>>>> which has nothing to do with XDP.
>> []
>>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>> []
>>>>>> @@ -18708,8 +18708,8 @@ F:    include/trace/events/xdp.h
>>>>>>    F:    kernel/bpf/cpumap.c
>>>>>>    F:    kernel/bpf/devmap.c
>>>>>>    F:    net/core/xdp.c
>>>>>> -N:    xdp
>>>>>> -K:    xdp
>>>>>> +N:    (?:\b|_)xdp(?:\b|_)
>>>>>> +K:    (?:\b|_)xdp(?:\b|_)
>>>>>
>>>>> Please also include \W to generally match on non-alphanumeric char given you
>>>>> explicitly want to avoid [a-z0-9] around the term xdp.
>>>> Aren't \W, ^ and $ already covered by \b?
>>>
>>> Ah, true; it says '\b really means (?:(?<=\w)(?!\w)|(?<!\w)(?=\w))', so all good.
>>> In case this goes via net or net-next tree:
>>
>> This N: pattern does not match files like:
>>
>> 	samples/bpf/xdp1_kern.c
>>
>> and does match files like:
>>
>> 	drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
>>
>> Should it?
> 
> I think the idea is that it should match both?
In *your* opinion: Which of these shall it (not) match?

> 
> -Toke
> 
