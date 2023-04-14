Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DAA6E2561
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjDNONs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjDNONq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:13:46 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A1DCC01
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:13:15 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pnKAD-0000HC-Me; Fri, 14 Apr 2023 16:12:33 +0200
Message-ID: <ea3d1c37-e621-3416-7f3b-d81307627c55@leemhuis.info>
Date:   Fri, 14 Apr 2023 16:12:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US, de-DE
To:     =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Jon Mason <jdmason@kudzu.us>
References: <20230227091156.19509-1-zajec5@gmail.com>
 <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
 <002c1f96-b82f-6be7-2530-68c5ae1d962d@milecki.pl>
 <b7b11a57-9512-cda9-1b15-5dd5aa12f162@gmail.com>
 <d6990d00-6fd5-cd89-755d-d7f566c574fa@leemhuis.info>
 <569c0f2f-ff7b-9367-e33e-ddf37a13232b@collabora.com>
From:   "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <569c0f2f-ff7b-9367-e33e-ddf37a13232b@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681481595;0a82c458;
X-HE-SMSGID: 1pnKAD-0000HC-Me
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.04.23 16:08, Ricardo Cañuelo wrote:
> Hi Thorsten,
> 
> On 14/4/23 16:04, Linux regression tracking (Thorsten Leemhuis) wrote:
>> What happened to this? It seems there wasn't any progress since above
>> mail week. But well, seems to be a odd issue anyway (is that one of
>> those issues that CI systems find, but don't cause practical issues in
>> the field?). Hence: can somebody with more knowledge about this please
>> tell if it this is something I can likely drop from the list of tacked
>> regressions?
> 
> From Rafał's answer, I think we can consider this a false positive and
> move on.

great, thx for confirming!

#regzbot inconclusive: CI false positive
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.




