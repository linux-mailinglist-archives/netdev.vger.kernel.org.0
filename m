Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DB96BFFBB
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 08:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCSHP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 03:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjCSHPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 03:15:15 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1D910A9C;
        Sun, 19 Mar 2023 00:14:50 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pdnFd-0004AK-0J; Sun, 19 Mar 2023 08:14:45 +0100
Message-ID: <8e3655bf-92dc-3685-5e96-b51ba8b8e61f@leemhuis.info>
Date:   Sun, 19 Mar 2023 08:14:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
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
References: <e6aaddb9-afec-e77d-be33-570f9f10a9c2@leemhuis.info>
Subject: Re: [regression] Bug 217069 - Wake on Lan is broken on r8169 since
 6.2
In-Reply-To: <e6aaddb9-afec-e77d-be33-570f9f10a9c2@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1679210090;38081f0c;
X-HE-SMSGID: 1pdnFd-0004AK-0J
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.02.23 08:57, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
> 
> I noticed a regression report in bugzilla.kernel.org. As many (most?)
> kernel developer don't keep an eye on it, I decided to forward it by
> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217069 :
> 
>> Ivan Ivanich 2023-02-22 00:51:52 UTC
>>
>> After upgrade to 6.2 having issues with wake on lan on 2 systems: -
>> first is an old lenovo laptop from 2012(Ivy Bridge) with realtek
>> network adapter - second is a PC(Haswell refresh) with PCIE realtek
>> network adapter
>>
>> Both uses r8169 driver for network.
>>
>> On laptop it's not possible to wake on lan after poweroff On PC it's
>> not possible to wake on lan up after hibernate but works after
>> poweroff
>>
>> In both cases downgrade to 6.1.x kernel fixes the issue.
> 
> See the ticket for more details.

JFYI: turns out this is not a network bug, as the issue was bisected to
5c62d5aab875 ("ACPICA: Events: Support fixed PCIe wake event"). The
ticket linked above has the details.

#regzbot introduced: 5c62d5aab875
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
