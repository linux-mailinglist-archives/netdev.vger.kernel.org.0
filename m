Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B896814BB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbjA3PUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238211AbjA3PUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:20:02 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FA63D0B3;
        Mon, 30 Jan 2023 07:19:53 -0800 (PST)
Received: from [2a02:8108:963f:de38:4bc7:2566:28bd:b73c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pMVwl-0002ep-OD; Mon, 30 Jan 2023 16:19:51 +0100
Message-ID: <e8937ad0-624d-9edd-5e3d-ad510e45af27@leemhuis.info>
Date:   Mon, 30 Jan 2023 16:19:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PULL] Networking for next-6.1 #forregzbot
Content-Language: en-US, de-DE
From:   "Linux kernel regression tracking (#update)" 
        <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221004052000.2645894-1-kuba@kernel.org>
 <6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org>
 <d6c68083-25e3-3ff5-9b0d-8928d1e077f1@leemhuis.info>
 <64800063-4728-6984-f1ee-f6e8c9978cb7@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <64800063-4728-6984-f1ee-f6e8c9978cb7@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1675091993;0d061751;
X-HE-SMSGID: 1pMVwl-0002ep-OD
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 22.12.22 13:20, Thorsten Leemhuis wrote:
> On 21.12.22 12:30, Thorsten Leemhuis wrote:

>> On 16.12.22 11:49, Jiri Slaby wrote:
>>>
>>> On 04. 10. 22, 7:20, Jakub Kicinski wrote:
>>>> Joanne Koong (7):
>>>
>>>>        net: Add a bhash2 table hashed by port and address
>>>
>>> This makes regression tests of python-ephemeral-port-reserve to fail.
>>
>> Thanks for the report. To be sure below issue doesn't fall through the
>> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
>> tracking bot:
>>
>> #regzbot ^introduced 28044fc1d495
>> #regzbot title new: regression tests of python-ephemeral-port-reserve fail
>> #regzbot ignore-activity

#regzbot fix: 936a192f9740


Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

#regzbot ignore-activity
