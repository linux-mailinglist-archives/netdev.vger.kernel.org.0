Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C7B59EAFB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiHWS1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiHWS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:27:14 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F2D3B964;
        Tue, 23 Aug 2022 09:47:27 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oQX3l-0005u0-IL; Tue, 23 Aug 2022 18:47:25 +0200
Message-ID: <7c41dd25-8bfa-c7b0-a430-1b115e8ee375@leemhuis.info>
Date:   Tue, 23 Aug 2022 18:47:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: Bug 216320 - KSZ8794 operation broken #forregzbot
Content-Language: en-US
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <967ef480-2fac-9724-61c7-2d5e69c26ec3@leemhuis.info>
In-Reply-To: <967ef480-2fac-9724-61c7-2d5e69c26ec3@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1661273247;2e013e76;
X-HE-SMSGID: 1oQX3l-0005u0-IL
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 17.08.22 15:36, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
>
> I noticed a regression report in bugzilla.kernel.org that afaics nobody
> acted upon since it was reported. That's why I decided to forward it by
> mail to those that afaics should handle this.
> 
> To quote from https://bugzilla.kernel.org/show_bug.cgi?id=216320 :
> 
>> After upgrading a Yocto build system from kernel 5.4 to 5.15, I found KSZ8794 switch operation was no longer functional. I got errors such as:
>>
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.770912] ksz8795-switch spi2.0: Unsupported interface: gmii, port: 0
>> Aug  1 22:23:17 tv999996 kern.warn kernel: [   10.777562] ksz8795-switch spi2.0 wan (uninitialized): validation of gmii with support 0000000,00000000,000062cf and advertisement 0000000,00000000,000062cf failed: -22
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.792874] ksz8795-switch spi2.0 wan (uninitialized): failed to connect to PHY: -EINVAL
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.800978] ksz8795-switch spi2.0 wan (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 0
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.829188] ksz8795-switch spi2.0: Unsupported interface: gmii, port: 1
>> Aug  1 22:23:17 tv999996 kern.warn kernel: [   10.835821] ksz8795-switch spi2.0 lan2 (uninitialized): validation of gmii with support 0000000,00000000,000062cf and advertisement 0000000,00000000,000062cf failed: -22
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.851156] ksz8795-switch spi2.0 lan2 (uninitialized): failed to connect to PHY: -EINVAL
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.859358] ksz8795-switch spi2.0 lan2 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 1
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.892821] ksz8795-switch spi2.0: Unsupported interface: gmii, port: 2
>> Aug  1 22:23:17 tv999996 kern.warn kernel: [   10.899466] ksz8795-switch spi2.0 lan1 (uninitialized): validation of gmii with support 0000000,00000000,000062cf and advertisement 0000000,00000000,000062cf failed: -22
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.914845] ksz8795-switch spi2.0 lan1 (uninitialized): failed to connect to PHY: -EINVAL
>> Aug  1 22:23:17 tv999996 kern.err kernel: [   10.923052] ksz8795-switch spi2.0 lan1 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 2
>>
>> I found that if I reverted commit 2c709e0bdad4d996ec8925b9ee6d5b97458708f1, "net: dsa: microchip: ksz8795: add phylink support", then it worked properly again. The errors I saw were due to the checks in ksz8_validate() that were added in the above commit.
> Could somebody please take a look, especially if you're among the main
> recipients of this mail and not just CCed?
> 
> Anyway, to ensure this is not forgotten I'll add it to the Linux kernel
> regression tracking bot:
> 
> #regzbot introduced: 2c709e0bdad4d996ec8925b9ee6d5b97458708f1
> https://bugzilla.kernel.org/show_bug.cgi?id=216320

#regzbot fixed-by: 5fbb08eb7f945c7e88
