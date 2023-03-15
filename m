Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6495E6BABF1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjCOJSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjCOJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:18:32 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1FA26869;
        Wed, 15 Mar 2023 02:18:27 -0700 (PDT)
Received: from maxwell ([109.43.50.216]) by mrelayeu.kundenserver.de (mreue109
 [213.165.67.113]) with ESMTPSA (Nemesis) id 1Mj8eB-1q7s7x3pvJ-00fFAo; Wed, 15
 Mar 2023 10:17:45 +0100
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
 <20230314123759.132521-2-jh@henneberg-systemdesign.com>
 <ZBCIM//XkpFkiC4W@nimitz> <878rfzgysa.fsf@henneberg-systemdesign.com>
 <ZBGI1TxdNJHxPwtu@nimitz>
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: stmmac: Premature loop termination check
 was ignored
Date:   Wed, 15 Mar 2023 10:13:46 +0100
In-reply-to: <ZBGI1TxdNJHxPwtu@nimitz>
Message-ID: <874jqmgyq8.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:S922b+8o4Y7LC9//asTBO8aSj7ByxZpvlXTwngol4C1G9miRqeI
 vvm6FvKdKWo+THzuvwT8Mtg1Vb58BEpfsyqouvRM4xMokRYOkDnzk7XlDXo995bx9FPed7l
 JW/0dWjLhyvYfwdyAtHS7w+8vRQo9G73hA6B5QObDuph56sEy4Kjh2bJ1Ag0MJ+LgjZoU+H
 5s4aN7nQGNHocQYcQoV7g==
UI-OutboundReport: notjunk:1;M01:P0:d3AVJOz1y2k=;717VqAdYEa2Y83A+eRm12H98nL0
 oS9ka/XzNHQ/S91radP44utzD6sYZ2mMcMjrqJcik7CeKBu/6/XRF6+MHpTbZ62vV9+tQUinO
 GJrRj+z34R1KlyVg+PnHhpAJuSnbOXOBc6hXW6R+6vFdu6cU3ofxVIfvFk09qsja1d81zQMm6
 s0tqy9VoLKQG2YkOzwkSXcv80jWWNBmoMILE7J5B7pjCsz2bTDAXMgyrscn0l+XJaffgaX2KY
 GtAmyHgvTk2knps8SSVl5j/AcoakSVbeDgAXyJTVJ9zpDYKd5hsRzvZHE8xuuwAy7LCeB3jGX
 oB1YY6CB6pvdep+sFpjVyfnXqf1beM9Hasi/hil0NuF0RIy2f5lvWd5F/Cx9l5wRos6KiaUqU
 jWtY9afVtZb/oP9IuepcFF2CsRWyNvtK4zFBOnVnhEkqD7OQXm1S/EgB5rNz4VdGVow//PsMm
 fxPJELc7SZ6Yj4Z0H8uaY8arAQFPMiiiIOKhJUDrNKl7Jso7IJABhkcB/iwFFKhcnBmg7MC0Z
 jQGAxexCoq3tpEDXX95bogiBFZmWIIM3gv2u9O3CmrQ5v00b637OD0XWaLRioizHFBzUrJXau
 LnFNX9PJKjL/vf0G0YSD8FHBaoBkxymbh7Hsdo1y02vcxTYMiyABjELsnndm7VWg/i9G69EIW
 1ORDl9v5uGr4tnEb28cVG72DL/qa/Ajd/XOS66yDfQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Piotr Raczynski <piotr.raczynski@intel.com> writes:

> On Tue, Mar 14, 2023 at 04:01:11PM +0100, Jochen Henneberg wrote:
>> 
>> Piotr Raczynski <piotr.raczynski@intel.com> writes:
>> 
>> > On Tue, Mar 14, 2023 at 01:37:58PM +0100, Jochen Henneberg wrote:
>> >> The premature loop termination check makes sense only in case of the
>> >> jump to read_again where the count may have been updated. But
>> >> read_again did not include the check.
>> >
>> > Your commit titles and messages seems identical in both patches, someone
>> > may get confused, maybe you could change commit titles at least?
>> >
>> > Or since those are very related one liner fixes, maybe combine them into
>> > one?
>> 
>> I was told to split them into a series because the fixes apply to
>> different kernel versions.
>> 
> Makes sense, thanks. However I'd still at least modify title to show
> which patch fixes zc path or anything to distinguish them beside commit
> sha.

Will do.

>> >
>> > Also a question, since you in generally goto backwards here, is it guarded from
>> > an infinite loop (during some corner case scenario maybe)?
>> 
>> In theory I think this may happen, however, I would consider that to be
>> a different patch since it addresses a different issue.
>> 
>
> Right, it just caught my attention, probably just make sense to check
> it.

I will take a look. Really, from code readability the driver is in a bad
shape, comments do not match code, bool and int are mixed for flags and
bool parameters are set with int values, DMA memory barriers are set
inconsistently and many more. This makes it hard to be sure what things
really do and follow code paths. I will try to check this issue and
provide a fix if necessary.

Btw., shall I copy your Reviewed-by and the reviewed-by from previous
patches into the new series or do you set the tag again on the V2
series?

>> >
>> > Other than that looks fine, thanks.
>> > Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
>> >
>> >> 
>> >> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
>> >> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
>> >> ---
>> >>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >> 
>> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> >> index e4902a7bb61e..ea51c7c93101 100644
>> >> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> >> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> >> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>> >>  			len = 0;
>> >>  		}
>> >>  
>> >> +read_again:
>> >>  		if (count >= limit)
>> >>  			break;
>> >>  
>> >> -read_again:
>> >>  		buf1_len = 0;
>> >>  		buf2_len = 0;
>> >>  		entry = next_entry;
>> >> -- 
>> >> 2.39.2
>> >> 
>> 
>> 
>> -- 
>> Henneberg - Systemdesign
>> Jochen Henneberg
>> Loehnfeld 26
>> 21423 Winsen (Luhe)
>> --
>> Fon: +49 172 160 14 69
>> Url: https://www.henneberg-systemdesign.com


-- 
Henneberg - Systemdesign
Jochen Henneberg
Loehnfeld 26
21423 Winsen (Luhe)
--
Fon: +49 172 160 14 69
Url: https://www.henneberg-systemdesign.com
