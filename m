Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA0BBD846
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 08:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411883AbfIYGZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 02:25:38 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:47358 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404570AbfIYGZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 02:25:38 -0400
Received: from localhost.localdomain (p200300E9D742D21B26FCBF88D1F65952.dip0.t-ipconnect.de [IPv6:2003:e9:d742:d21b:26fc:bf88:d1f6:5952])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4C630C1B1A;
        Wed, 25 Sep 2019 08:25:35 +0200 (CEST)
Subject: Re: [PATCH] ieee802154: mcr20a: simplify a bit
 'mcr20a_handle_rx_read_buf_complete()'
To:     Xue Liu <liuxuenetmail@gmail.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "alex. aring" <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190920194533.5886-1-christophe.jaillet@wanadoo.fr>
 <388f335a-a9ae-7230-1713-a1ecb682fecf@datenfreihafen.org>
 <CAJuUDwtWJgo7PHJR4kBpQ9mGamTMEaPZBNOZcL3mWFwwZ-zOmw@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <7d131e76-d487-ead3-1780-6a9a7d7877a4@datenfreihafen.org>
Date:   Wed, 25 Sep 2019 08:25:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAJuUDwtWJgo7PHJR4kBpQ9mGamTMEaPZBNOZcL3mWFwwZ-zOmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 24.09.19 23:40, Xue Liu wrote:
> On Sat, 21 Sep 2019 at 13:52, Stefan Schmidt <stefan@datenfreihafen.org> wrote:
>>
>> Hello Xue.
>>
>> On 20.09.19 21:45, Christophe JAILLET wrote:
>>> Use a 'skb_put_data()' variant instead of rewritting it.
>>> The __skb_put_data variant is safe here. It is obvious that the skb can
>>> not overflow. It has just been allocated a few lines above with the same
>>> 'len'.
>>>
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>> ---
>>>   drivers/net/ieee802154/mcr20a.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
>>> index 17f2300e63ee..8dc04e2590b1 100644
>>> --- a/drivers/net/ieee802154/mcr20a.c
>>> +++ b/drivers/net/ieee802154/mcr20a.c
>>> @@ -800,7 +800,7 @@ mcr20a_handle_rx_read_buf_complete(void *context)
>>>        if (!skb)
>>>                return;
>>>
>>> -     memcpy(skb_put(skb, len), lp->rx_buf, len);
>>> +     __skb_put_data(skb, lp->rx_buf, len);
>>>        ieee802154_rx_irqsafe(lp->hw, skb, lp->rx_lqi[0]);
>>>
>>>        print_hex_dump_debug("mcr20a rx: ", DUMP_PREFIX_OFFSET, 16, 1,
>>>
>>
>> Could you please review and ACK this? If you are happy I will take it
>> through my tree.
>>
>> regards
>> Stefan Schmidt
> 
> Acked-by: Xue Liu <liuxuenetmail@gmail.com>


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
