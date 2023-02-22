Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DFA69F85A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjBVPyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjBVPyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:54:39 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E32A3B3EA;
        Wed, 22 Feb 2023 07:54:38 -0800 (PST)
Received: from maxwell ([109.42.114.8]) by mrelayeu.kundenserver.de (mreue012
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MxYT3-1ocJz31HJ3-00xpU3; Wed, 22
 Feb 2023 16:52:28 +0100
References: <87y1oq5es0.fsf@henneberg-systemdesign.com>
 <Y/XbXwKYpy3+pTah@corigine.com>
User-agent: mu4e 1.8.14; emacs 28.2
From:   Henneberg - Systemdesign <lists@henneberg-systemdesign.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V3] net: stmmac: Premature loop termination check
 was ignored
Date:   Wed, 22 Feb 2023 16:49:55 +0100
In-reply-to: <Y/XbXwKYpy3+pTah@corigine.com>
Message-ID: <87lekp66ko.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:EUGFsK4XpAaH7yDm8YNyP0ASKdEARzN+x2SV1AiBuR+LhHCnNaO
 uQLIPRzr4vwnDQWs/T02m1FrIcZs6wX8ji5EkKXoTyqemxilayzw8e4dPQxNNvDH5F6hhRJ
 WLPY46dmsHwxpUYcn1KzoXBWo/XbQEQf6TYQNP/H783B9J0FaH7CllbNW6zDbpqlqtNxrIA
 EovVJLBeRYmf1/+FE/Sgw==
UI-OutboundReport: notjunk:1;M01:P0:SPFQol5nWp4=;6conbKbuDxwgu7b+mEolyujyQQh
 7nEdfqVUyRLezt7Q/BnlStJ1iWpj2h7vbYL4l+gA/g0pchlMhk76uu1iDS/MD/8CYhHUtmGlM
 un+71UbKucAjzz248yfz+nqetwn5gtmmZ541QT5Cxy3ROGP21+TYIY9VvekKdiOJYDhxSbp1I
 LCUOhiFW+sI2XlWlO73WgnCwNgse9fuvkCBs0PxDrRLV2gCeFhkKJMPOEPtN02EQwihgIoWb/
 Odx0rQw5XwNT7x7PNHuLxgujs2t9GfBGtfnArWLhZV3keMKBaupn8PXODPsthtDMboZBfLjLI
 GdqUaKP4+mucSbnN7jce/2gkwlPKcrm/hxMqxsnoW4I0o7+RSXv6qW7ySofu1PxCb0uuMkFjd
 2M+T9K4/+0n00il0+gvQQwcsmgQpcDjjGGlrIqglZg/OULvw1quChWL74+ogItGZok6+5IAJv
 gpaLVgkOGeHfD0OuUhAsInjJ6+yJ8c4ie3FeB7TdoaVtj8IoZURMxkqB2shQit7IUv57W6iok
 pFzd0u/uFcN/wCGAXx6+qqdukfrscRjOf5dG9Sy03Tr0L75/hRkS3XBbtzSf1f3fLZt6Xy1+f
 FM/OoW0uPrVXP4+GH9aBDv35hQrY/SIgEBbpZeVCZDgEkTVohsXJgIzNB/2DVIe0Dg9PuTv9Z
 18XhBGxVQ7P2Ycfpi1rfhrDBEEzMRGuyNZsX2IQ35g==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Simon Horman <simon.horman@corigine.com> writes:

> On Wed, Feb 22, 2023 at 08:38:28AM +0100, Jochen Henneberg wrote:
>> 
>> The premature loop termination check makes sense only in case of the
>> jump to read_again where the count may have been updated. But
>> read_again did not include the check.
>> 
>> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
>
> This commit was included in v5.13
>
>> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
>
> While this one was included in v5.4
>
> It seems to me that each of the above commits correspond to one
> of the two hunks below. I don't know if that means this
> patch should be split in two to assist backporting.
>

I was thinking about this already but the change was so trivial that I
hesitated to split it into two commits. I wanted I will surely change
this.

>> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
>
> That aside, this looks good to me.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
>> ---
>> V2: Added fixes tags
>> V3: Fixed fixes tag format
>> 
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 1a5b8dab5e9b..de98c009866a 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
>>  			len = 0;
>>  		}
>>  
>> +read_again:
>>  		if (count >= limit)
>>  			break;
>>  
>> -read_again:
>>  		buf1_len = 0;
>>  		entry = next_entry;
>>  		buf = &rx_q->buf_pool[entry];
>> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>>  			len = 0;
>>  		}
>>  
>> +read_again:
>>  		if (count >= limit)
>>  			break;
>>  
>> -read_again:
>>  		buf1_len = 0;
>>  		buf2_len = 0;
>>  		entry = next_entry;
>> -- 
>> 2.39.2
>> 


-- 
Henneberg - Systemdesign
Jochen Henneberg
Loehnfeld 26
21423 Winsen (Luhe)
--
Fon: +49 172 160 14 69
Url: https://www.henneberg-systemdesign.com
