Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2366B72A4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCMJdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCMJcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:32:41 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD40A4D2B4;
        Mon, 13 Mar 2023 02:31:52 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pbeWz-0007Gj-RS; Mon, 13 Mar 2023 10:31:49 +0100
Message-ID: <05ad6c8c-0573-b1b3-d8bd-62175f9bd9f3@leemhuis.info>
Date:   Mon, 13 Mar 2023 10:31:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc:     primalmotion@pm.me,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        Kalle Valo <kvalo@kernel.org>, netdev <netdev@vger.kernel.org>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: [regression] Bug 217183 - AR9462/ath9k: running wifi scan freezes the
 laptop
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678699913;1fa1f308;
X-HE-SMSGID: 1pbeWz-0007Gj-RS
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Thorsten here, the Linux kernel's regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217183 :

>  primalmotion@pm.me 2023-03-12 19:27:05 UTC
> 
> Since 6.2.1 (and onward), running a wifi scan freezes the laptop completely. The screen is frozen, caps lock led is on, and there's nothing left to do but force reboot.
> 
> Step to reproduce:
> 1) iwctl station wlan0 scan
> 
> This works just fine on 6.1.12 and below. 
> This is 100% reproducible. 
> 
> I can't find any relevant log. I tried to collect dmesg and journalctl -k while I was performing the command, but the laptop freezes before I can get anything.
> 
> Card: Qualcomm Atheros AR9462 Wireless Network Adapter (rev 01)
> Driver: ath9k
> 
> module parameters:
> /sys/module/ath9k/parameters/blink 0
> /sys/module/ath9k/parameters/bt_ant_diversity 0
> /sys/module/ath9k/parameters/btcoex_enable 1
> /sys/module/ath9k/parameters/led_active_high -1
> /sys/module/ath9k/parameters/ps_enable 1
> /sys/module/ath9k/parameters/use_chanctx 0
> /sys/module/ath9k/parameters/use_msi 0
> 
> Let me know if you need any additional logs from other places I don't know

See the ticket for more details.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v6.1..v6.2
https://bugzilla.kernel.org/show_bug.cgi?id=217183
#regzbot title: net: wifi: ath9k: wifi scan freezes laptop
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
