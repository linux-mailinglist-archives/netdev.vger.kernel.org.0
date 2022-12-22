Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22D16540EC
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 13:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiLVMUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 07:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiLVMUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 07:20:02 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0766D1B3;
        Thu, 22 Dec 2022 04:20:01 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p8KYK-00087V-Ce; Thu, 22 Dec 2022 13:20:00 +0100
Message-ID: <64800063-4728-6984-f1ee-f6e8c9978cb7@leemhuis.info>
Date:   Thu, 22 Dec 2022 13:20:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PULL] Networking for next-6.1 #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221004052000.2645894-1-kuba@kernel.org>
 <6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org>
 <d6c68083-25e3-3ff5-9b0d-8928d1e077f1@leemhuis.info>
In-Reply-To: <d6c68083-25e3-3ff5-9b0d-8928d1e077f1@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1671711602;d5608299;
X-HE-SMSGID: 1p8KYK-00087V-Ce
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.12.22 12:30, Thorsten Leemhuis wrote:
> [Note: this mail contains only information for Linux kernel regression
> tracking. Mails like these contain '#forregzbot' in the subject to make
> then easy to spot and filter out. The author also tried to remove most
> or all individuals from the list of recipients to spare them the hassle.]
> 
> On 16.12.22 11:49, Jiri Slaby wrote:
>>
>> On 04. 10. 22, 7:20, Jakub Kicinski wrote:
>>> Joanne Koong (7):
>>
>>>        net: Add a bhash2 table hashed by port and address
>>
>> This makes regression tests of python-ephemeral-port-reserve to fail.
> 
> Thanks for the report. To be sure below issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
> tracking bot:
> 
> #regzbot ^introduced 28044fc1d495
> #regzbot title new: regression tests of python-ephemeral-port-reserve fail
> #regzbot ignore-activity

#regzbot monitor:
https://lore.kernel.org/all/20221221151258.25748-1-kuniyu@amazon.com/
#regzbot fix: tcp: Add TIME_WAIT sockets in bhash2

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
