Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEE26BF983
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 11:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCRK61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 06:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCRK60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 06:58:26 -0400
X-Greylist: delayed 96400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Mar 2023 03:58:24 PDT
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7349442BF9;
        Sat, 18 Mar 2023 03:58:23 -0700 (PDT)
Received: from maxwell ([93.223.194.227]) by mrelayeu.kundenserver.de
 (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis) id
 1MXp1O-1q0fR01Vro-00Y9ju; Sat, 18 Mar 2023 11:57:54 +0100
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-2-jh@henneberg-systemdesign.com>
 <20230317222117.3520d4cf@kernel.org>
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2 1/2] net: stmmac: Premature loop termination
 check was ignored on rx
Date:   Sat, 18 Mar 2023 09:38:12 +0100
In-reply-to: <20230317222117.3520d4cf@kernel.org>
Message-ID: <87sfe2gwd2.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:11TGBtoqQjv+AJTAzJp+aQPfKm5rdzxYF31OXmoE/4m7y/QexHZ
 a/Qu1irPDxWE50evrxAPbgyV65Ku3G/NBM0wBQX8gpH9tyJIsPDRwAxtGoCIVBuuGlVakRZ
 q54FiRVg1uhcpkpmkHYynHIzgq8kMGWetNcGZwf2RGqWOMHdua28cermriWvuLd1+ujek69
 mPYfghvopY88jwrVg5yMw==
UI-OutboundReport: notjunk:1;M01:P0:umlFYN5+QSM=;ad9WRdUhgzgSHdgR75UnVHH/2SI
 l0Gvrt/FRR5lgIpZN/DaLLQIc2a6D7wGp7+9M3r0glOoVqdyfo2jsTng0jDJFf5yzzafJR2bT
 p4aE1JL2SO2epTwW3COaOdI9v24fc35C6OAkDCRr3mrTTfaeokraXmEkjpjSJ0ibb6JObo6Hr
 pXrhQhyfBx8SU8fcWt9Zn139byMV5JcKsuthCH7I8CMctA16eFnJJcXGshYt7D+sTJ55UOM+t
 ug2tFI/033WBFSq/0M3RKVSICzc4ALIEL8LZ3n+pBPPsKy7ffD3QcgS5dwfyMjza7kza5Wmak
 AB0XHnNU0WMgfKbVnegzomooNhF8qt+/aJdP+rXZhcigulE6Y5S8HSxDdLvvr7pLdgpzd1/7K
 yFTO/EgI+o3vp7QdgcrYeJTx4bbaSpE5+lDJHSp8pxi8NrpAIclT3f+JPyhNQEEhi6SXVxYD5
 ttWMEndjLBf4Kn86iOxGfDYd6lE4sZl79kuIN66WxZn/yb7X7cPIOm2aHHni+E0aKWcAYFajm
 hXk8Rs18LHyhjLGoFd25MrqhgfgDNYBW7nQusyOzh+p4RvuEwifD1FFvCLoiBgW1B9QLTnpZI
 Txdh0HI8uVGeD1xwVSmW6URZoGdxjnCeGoB8Lg0ExsTCI1nB/BuKtqGSJFKsoXwFpSFyPygo2
 xPlZqKXn4m6a/tZqbPeKKj7JsgRtu1eW62IyIwl5cw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 16 Mar 2023 08:59:39 +0100 Jochen Henneberg wrote:
>> The premature loop termination check makes sense only in case of the
>> jump to read_again where the count may have been updated. But
>> read_again did not include the check.
>> 
>> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
>> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index e4902a7bb61e..ea51c7c93101 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>>  			len = 0;
>>  		}
>>  
>> +read_again:
>>  		if (count >= limit)
>>  			break;
>
> Are you sure? Can you provide more detailed analysis?
> Do you observe a problem / error in real life or is this theoretical?

This is theoretical, I was hunting another bug and just stumbled over
the check which is, I think you agree, pointless right now. I did not
try to force execute that code path.

>
> As far as I can tell only path which jumps to read_again after doing
> count++ is via the drain_data jump, but I can't tell how it's
> discarding subsequent segments in that case..
>
>> -read_again:
>>  		buf1_len = 0;
>>  		buf2_len = 0;
>>  		entry = next_entry;

Correct. The read_again is triggered in case that the segment is not the
last segment of the frame:

		if (likely(status & rx_not_ls))
			goto read_again;

So in case there is no skb (queue error) it will keep increasing count
until the last segment has been found with released device DMA
ownership. So skb will not change while the goto loop is running, the
only thing that will change is that subsequent segments release device
DMA ownership. The dirty buffers are then cleaned up from
stmmac_rx_refill().

I think the driver code is really hard to read I have planned to cleanup
things later, however, this patch simply tries to prevent us from
returning a value greater than limit which could happen and would
definitely be wrong.
