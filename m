Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85930569F5A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiGGKRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiGGKRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:17:23 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D2450730;
        Thu,  7 Jul 2022 03:17:22 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1o9OZU-0008RW-7S; Thu, 07 Jul 2022 12:17:20 +0200
Message-ID: <a93e5967-026a-186d-2bf0-5628631b9e28@leemhuis.info>
Date:   Thu, 7 Jul 2022 12:17:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     regressions@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Will Deacon <will@kernel.org>
References: <20220706124007.GB7996@breakpoint.cc>
 <20220706145004.22355-1-fw@strlen.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH nf v3] netfilter: conntrack: fix crash due to confirmed
 bit load reordering
In-Reply-To: <20220706145004.22355-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1657189042;f22e09e4;
X-HE-SMSGID: 1o9OZU-0008RW-7S
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.07.22 16:50, Florian Westphal wrote:
> Kajetan Puchalski reports crash on ARM, with backtrace of:
> 
> [...]
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Diagnosed-by: Will Deacon <will@kernel.org>
> Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
> Signed-off-by: Florian Westphal <fw@strlen.de>

If you need to respin this patch for one reason or another, could you do
me a favor and add proper 'Link:' tags pointing to all reports about
this issue? e.g. like this:

 Link:
https://lore.kernel.org/all/Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com/

These tags are considered important by Linus[1] and others, as they
allow anyone to look into the backstory weeks or years from now. That is
why they should be placed in cases like this, as
Documentation/process/submitting-patches.rst and
Documentation/process/5.Posting.rst explain in more detail. I care
personally, because these tags make my regression tracking efforts a
whole lot easier, as they allow my tracking bot 'regzbot' to
automatically connect reports with patches posted or committed to fix
tracked regressions.

[1] see for example:
https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
