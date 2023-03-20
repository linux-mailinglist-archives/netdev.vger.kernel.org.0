Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFA6C0CD3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjCTJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCTJMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:12:15 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF2712F3D;
        Mon, 20 Mar 2023 02:12:12 -0700 (PDT)
Received: from maxwell ([109.42.113.5]) by mrelayeu.kundenserver.de (mreue010
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1N1x6X-1qc2JF1po9-012FOD; Mon, 20
 Mar 2023 10:11:36 +0100
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-2-jh@henneberg-systemdesign.com>
 <20230317222117.3520d4cf@kernel.org>
 <87sfe2gwd2.fsf@henneberg-systemdesign.com>
 <20230318190125.175b0fea@kernel.org>
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
Date:   Mon, 20 Mar 2023 10:04:54 +0100
In-reply-to: <20230318190125.175b0fea@kernel.org>
Message-ID: <87r0tj23eh.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:tKJ0B9oTVyS1ml3UhWUrS3OK4UsHl+6Uz5UYfd2v2NzIMMMLzFx
 NWbpSN1jEiYRdXnOGkWutm9rF+J9kVeNJJDr2vGVteLJRBjBlamV5mRuVBUrzpucl+xflwf
 G1iD6q/Z3ypO2q7A6DXokVxlUsF4dQQBw/D6sytO7nVLdWBDzkd5NX2PtU2pGO+6DH31v/k
 A1VN0p6lnH3kCIWCO5LMw==
UI-OutboundReport: notjunk:1;M01:P0:Z2lW1P+dd9A=;WneYJpRDoZhZC3HUgHBM4TYZS1x
 BzlBOgkelPt88QxkeIfVk/AblHPQpJWDN3tew8b5a8OUzNBMtLoOowE0iNO7inhnHm4+nRRLA
 B67bjBUL0kGaQNtnMCPDpsybDor04Jl0bK4iyzeJ1DytfoAair9IGT4PhNt6AjwrfHZVStECO
 M+KF4bik1cs2OMyfMOIjoSbzI7jjAvm2BaJOs237zFWDUW+rPRV6PChRomo/XYnMC11+cLV10
 72byDSQe/gvVFPsvBqV6LAWpCDsRTUpsrsp8pQEHPkjL06Dz3MVf5x90EAhxUk9FJ+HvHHPar
 EI7wpHQ6YFG7BIYPzxZ0xqW6b/kOIGpyyHfFnQ0wxmpafRFcM5dhddXH9oil97GUvFd61r3AH
 RvGcUBBD/J+Vign4TZP8sjic9kvqToU1RuAYY3ETWnXXhDTsnjyl+FellF7U/XAVUQSI4pWF7
 CxL0iEFWkk7PtulnvmDgZCwHCbTS4ObGm+kdUqfVfsXHEXfdy1yOkQH7hP6l/9gs+ByIBqXPM
 dSD48hRFT5NNESvW3EN7PwLvEu8TZGXWYif9WPzFyW262AIseRGyOpWHDHA+VehzCoLUr8U3T
 EUTcXTgDGlWjT9Uqe/iDlb9D63jk7fOOuhDl+NqbeSVwOE3/0HTV1v9Lj8LlHRYdXJXnzccak
 wdYY0pPIxXgSjoNZAb0lTkXPQYYfBLN8fXKGCy1SMA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Sat, 18 Mar 2023 09:38:12 +0100 Jochen Henneberg wrote:
>> > Are you sure? Can you provide more detailed analysis?
>> > Do you observe a problem / error in real life or is this theoretical?  
>> 
>> This is theoretical, I was hunting another bug and just stumbled over
>> the check which is, I think you agree, pointless right now. I did not
>> try to force execute that code path.
>
> If you have the HW it's definitely worth doing. There is a fault
> injection infra in Linus which allows to fail memory allocations.
> Or you can just make a little patch to the driver to fake failing
> every 1000th allocation.
>

I have the hardware available and will do the check.

>> > As far as I can tell only path which jumps to read_again after doing
>> > count++ is via the drain_data jump, but I can't tell how it's
>> > discarding subsequent segments in that case..
>> >  
>> >> -read_again:
>> >>  		buf1_len = 0;
>> >>  		buf2_len = 0;
>> >>  		entry = next_entry;  
>> 
>> Correct. The read_again is triggered in case that the segment is not the
>> last segment of the frame:
>> 
>> 		if (likely(status & rx_not_ls))
>> 			goto read_again;
>> 
>> So in case there is no skb (queue error) it will keep increasing count
>> until the last segment has been found with released device DMA
>> ownership. So skb will not change while the goto loop is running, the
>> only thing that will change is that subsequent segments release device
>> DMA ownership. The dirty buffers are then cleaned up from
>> stmmac_rx_refill().
>
> To be clear - I'm only looking at stmmac_rx(), that ZC one is even more
> confusing.
>
> Your patch makes sense, but I think it's not enough to make this code
> work in case of memory allocation failure. AFAIU the device supports
> scatter - i.e. receiving a single frame in multiple chunks. Each time
> thru the loop we process one (or two?) chunks. But the code uses 
> skb == NULL to decide whether it's the first chunk or not. So in case
> of memory allocation error it will treat the second chunk as the first
> (since skb will be NULL) and we'll get a malformed frame with missing
> chunks sent to the stack. The driver should discard the entire frame
> on failure..
>

Understood. However, this forces me to read the code and datahseet very
carefully to understand the details. I will do that, however, it will
take me some time.

For the ST and Synopsys people:
I could imagine that you would be able to fix this much faster than
I can, so if they want to work on this please let me know so I don't
waste my time on doing double work.

>> I think the driver code is really hard to read I have planned to cleanup
>> things later, however, this patch simply tries to prevent us from
>> returning a value greater than limit which could happen and would
>> definitely be wrong.
