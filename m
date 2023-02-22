Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8BC69EFB5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 08:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBVH6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 02:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBVH6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 02:58:12 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F076526CCF;
        Tue, 21 Feb 2023 23:58:03 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pUk0j-0000zp-CF; Wed, 22 Feb 2023 08:57:57 +0100
Message-ID: <e6aaddb9-afec-e77d-be33-570f9f10a9c2@leemhuis.info>
Date:   Wed, 22 Feb 2023 08:57:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <linux@leemhuis.info>
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        Ivan Ivanich <iivanich@gmail.com>
Subject: [regression] Bug 217069 - Wake on Lan is broken on r8169 since 6.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1677052684;5fc1a5f6;
X-HE-SMSGID: 1pUk0j-0000zp-CF
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217069 :

> Ivan Ivanich 2023-02-22 00:51:52 UTC
> 
> After upgrade to 6.2 having issues with wake on lan on 2 systems: -
> first is an old lenovo laptop from 2012(Ivy Bridge) with realtek
> network adapter - second is a PC(Haswell refresh) with PCIE realtek
> network adapter
> 
> Both uses r8169 driver for network.
> 
> On laptop it's not possible to wake on lan after poweroff On PC it's
> not possible to wake on lan up after hibernate but works after
> poweroff
> 
> In both cases downgrade to 6.1.x kernel fixes the issue.

See the ticket for more details.

@Ivan: maybe someone that sees this mail might have an idea what's
wrong. But if not, you likely need to run a bisection to find what's
causing this.

[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v6.1..v6.2
https://bugzilla.kernel.org/show_bug.cgi?id=217069
#regzbot title: net/r8169: Wake/power on Lan is broken on two machines
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
