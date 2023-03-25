Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E2E6C8E75
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 14:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjCYNX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 09:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCYNX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 09:23:27 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D13255AD;
        Sat, 25 Mar 2023 06:23:26 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pg3rZ-0001gO-FN; Sat, 25 Mar 2023 14:23:17 +0100
Message-ID: <dbb0d402-ac95-6355-03aa-42c2671727d7@leemhuis.info>
Date:   Sat, 25 Mar 2023 14:23:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Bug 217245 - mt7921e tries to load unnecessary firmware
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1679750606;45cfbc79;
X-HE-SMSGID: 1pg3rZ-0001gO-FN
X-Spam-Status: No, score=0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Thorsten here, the Linux kernel's regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developers don't keep an eye on it, I decided to forward it by
mail. Note, the reporter can be reached though bugzilla, as I sadly can
not CCed them to mails like this[1].

Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217245 :

> kitestramuort@autistici.org 2023-03-24 21:53:01 UTC
> 
> I compile mt7921e statically into the kernel, along with the firmware
> binaries needed for my MT7922 chip:
> WIFI_MT7922_patch_mcu_1_1_hdr.bin, WIFI_MT7922_patch_mcu_1_1_hdr.bin
> and BT_RAM_CODE_MT7922_1_1_hdr.bin
> 
> Since 6.2, mt7921e also tries to load WIFI_RAM_CODE_MT7961_1.bin and
> fails with
> 
> mt7921e 0000:02:00.0: Direct firmware load for
> mediatek/WIFI_RAM_CODE_MT7961_1.bin failed with error -2
> 
> The card seems to work normally without that binary, so I guess it is
> not needed and it shouldn't be requested. The error doesn't happen
> with the 6.1 kernel

See the ticket for more details.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v6.1..v6.2
https://bugzilla.kernel.org/show_bug.cgi?id=217245
#regzbot title: net: wireless: mt7921e when build in now requires a new
firmware file
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

[1] because bugzilla.kernel.org tells users upon registration their
"email address will never be displayed to logged out users"
