Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B236763870B
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiKYKHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiKYKHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:07:20 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE4E27FD5;
        Fri, 25 Nov 2022 02:07:19 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oyVc4-0007KE-Kv; Fri, 25 Nov 2022 11:07:16 +0100
Message-ID: <fb66eabd-d0e5-ea15-5705-c2f95a98c3ac@leemhuis.info>
Date:   Fri, 25 Nov 2022 11:07:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] ipv4: Fix route deletion when nexthop info is not
 specified
Content-Language: en-US, de-DE
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@gmail.com, razor@blackwall.org,
        jonas.gorski@gmail.com, mlxsw@nvidia.com, stable@vger.kernel.org
References: <20221124210932.2470010-1-idosch@nvidia.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20221124210932.2470010-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1669370839;68fbbcc8;
X-HE-SMSGID: 1oyVc4-0007KE-Kv
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 24.11.22 22:09, Ido Schimmel wrote:
> When the kernel receives a route deletion request from user space it
> tries to delete a route that matches the route attributes specified in
> the request.
> [...]
 > Cc: stable@vger.kernel.org
> Reported-by: Jonas Gorski <jonas.gorski@gmail.com>

Many thx for taking care of this. There is one small thing to improve,
please add the following tags here:

Link:
https://lore.kernel.org/r/CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch%2B=aA5Q@mail.gmail.com/

To explain: Linus[1] and others considered proper link tags in cases
like important, as they allow anyone to look into the backstory weeks or
years from now. That why they should be placed here, as outlined by the
documentation[2]. I care personally, because these tags make my
regression tracking efforts a whole lot easier, as they allow my
tracking bot 'regzbot' to automatically connect reports with patches
posted or committed to fix tracked regressions.

Apropos regzbot, let me tell regzbot to monitor this thread:

#regzbot ^backmonitor:
https://lore.kernel.org/r/CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch%2B=aA5Q@mail.gmail.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

[1] for details, see:
https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/

[2] see Documentation/process/submitting-patches.rst
(http://docs.kernel.org/process/submitting-patches.html) and
Documentation/process/5.Posting.rst
(https://docs.kernel.org/process/5.Posting.html)
