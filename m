Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C67E30E88D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhBDAeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhBDAea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 19:34:30 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8DEC061573;
        Wed,  3 Feb 2021 16:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=BG5xo57883wZFg8LT27wpBNLDvItg9xhNzOkMkfoe78=; b=qnVs1N+XmTfCeuJFXLBv1CEQ/f
        Swrxm7740kgfWXderYwwkfa7mlqKgktEJtO9OD5n+jNpkuC4aZnw4LFMpzN7LmO4pAFThuc75vLUk
        i12t76pBsj8R/Sj1qb9zXfGjp1NsCvhjzL4vOWrtEK6h866ZW6WvUhX9VF7B/XhGGemfusuvJutWq
        2WQgX6XNrm9yOWvNx4buJfjr6Co7nex3BEhsGMtZb6jLc5bB6KTD0hUOVP0gJjhOwwTmZTmvBLW8L
        7h51zYZmfYkX8pZ1h7v2PBz0K8jmfJVXvfvGFKjmP0xr+7muc+ONSuufBP10BZN/uPJ8hxWNb6Azj
        46JoVBig==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Sac-0004GE-Aj; Thu, 04 Feb 2021 00:33:42 +0000
Subject: Re: [PATCH] rt2x00: remove duplicate word in comment
To:     wengjianfeng <samirweng1979@163.com>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210203063850.15844-1-samirweng1979@163.com>
 <6bf90f62-f14e-9c4a-748b-4923fcae9bef@infradead.org>
 <20210204083007.000069d2@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1ee1b354-0550-3fd8-f547-10827b3974ad@infradead.org>
Date:   Wed, 3 Feb 2021 16:33:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210204083007.000069d2@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 4:30 PM, wengjianfeng wrote:
> On Wed, 3 Feb 2021 07:16:17 -0800
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> On 2/2/21 10:38 PM, samirweng1979 wrote:
>>> From: wengjianfeng <wengjianfeng@yulong.com>
>>>
>>> remove duplicate word 'we' in comment
>>>
>>> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
>>> ---
>>>  drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
>>> b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c index
>>> c861811..7158152 100644 ---
>>> a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c +++
>>> b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c @@ -179,7
>>> +179,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
>>>  	 * Make room for new data. There are 2 possibilities
>>>  	 * either the alignment is already present between
>>>  	 * the 802.11 header and payload. In that case we
>>> -	 * we have to move the header less then the iv_len
>>> +	 * have to move the header less then the iv_len
>>
>> s/then/than/
>>
>>>  	 * since we can use the already available l2pad bytes
>>>  	 * for the iv data.
>>>  	 * When the alignment must be added manually we must
>>>
>>
>>
> 
> Hi Randy,
>    So you means add it for byte alignment, right? if yes,just ignore
>    the patch. thanks.

No, I mean that there is a typo there also: "then" should be changed to "than"
while you are making changes.

thanks.
-- 
~Randy

