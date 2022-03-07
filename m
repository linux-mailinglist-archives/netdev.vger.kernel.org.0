Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407A14CF29C
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 08:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiCGHc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 02:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiCGHc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 02:32:56 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2212C2559E;
        Sun,  6 Mar 2022 23:32:02 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nR7qZ-0006vu-C1; Mon, 07 Mar 2022 08:31:59 +0100
Message-ID: <4a28b83b-37ef-1533-563a-39b66c5ff158@leemhuis.info>
Date:   Mon, 7 Mar 2022 08:31:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Linux regressions report for mainline [2022-03-06]
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <robh@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Netdev <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
References: <164659571791.547857.13375280613389065406@leemhuis.info>
 <CAHk-=wgYjH_GMvdnNdVOn8m81eBXVykMAZvv_nfh8v_qdyQNvA@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CAHk-=wgYjH_GMvdnNdVOn8m81eBXVykMAZvv_nfh8v_qdyQNvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1646638322;c6fcc38d;
X-HE-SMSGID: 1nR7qZ-0006vu-C1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.03.22 22:33, Linus Torvalds wrote:
> On Sun, Mar 6, 2022 at 11:58 AM Regzbot (on behalf of Thorsten
> Leemhuis) <regressions@leemhuis.info> wrote:
>>
>> ========================================================
>> current cycle (v5.16.. aka v5.17-rc), culprit identified
>> ========================================================
>>
>> Follow-up error for the commit fixing "PCIe regression on APM Merlin (aarch64 dev platform) preventing NVME initialization"
>> ---------------------------------------------------------------------------------------------------------------------------
>> https://linux-regtracking.leemhuis.info/regzbot/regression/Yf2wTLjmcRj+AbDv@xps13.dannf/
>> https://lore.kernel.org/stable/Yf2wTLjmcRj%2BAbDv@xps13.dannf/
>>
>> By dann frazier, 29 days ago; 7 activities, latest 23 days ago; poked 13 days ago.
>> Introduced in c7a75d07827a (v5.17-rc1)
> 
> Hmm. The culprit may be identified, but it looks like we don't have a
> fix for it, so this may be one of those "left for later" things. It
> being Xgene, there's a limited number of people who care, I'm afraid.
> 
> Alternatively, maybe 6dce5aa59e0b ("PCI: xgene: Use inbound resources
> for setup") should just be reverted as broken?

I don't care much, I just hope someone once again will look into this,
as this (and the previous) regression are on my list for quite a while
already and process once again seems to have slowed down. :-/

>> ====================================================
>> current cycle (v5.16.. aka v5.17-rc), unknown culprit
>> ====================================================
>>
>>
>> net: bluetooth: qualcom and intel adapters, unable to reliably connect to bluetooth devices
>> -------------------------------------------------------------------------------------------
>> https://linux-regtracking.leemhuis.info/regzbot/regression/CAJCQCtSeUtHCgsHXLGrSTWKmyjaQDbDNpP4rb0i+RE+L2FTXSA@mail.gmail.com/
>> https://lore.kernel.org/linux-bluetooth/CAJCQCtSeUtHCgsHXLGrSTWKmyjaQDbDNpP4rb0i%2BRE%2BL2FTXSA@mail.gmail.com/
>>
>> By Chris Murphy, 23 days ago; 47 activities, latest 3 days ago.
>> Introduced in v5.16..f1baf68e1383 (v5.16..v5.17-rc4)
>>
>> Fix incoming:
>> * https://lore.kernel.org/regressions/1686eb5f-7484-8ec2-8564-84fe04bf6a70@leemhuis.info/
> 
> That's a recent fix, it seems to be only in the bluetooth tree right
> now, and won't be in rc7. I'm hoping that I'll get it in next week's
> networking dump.

You will, it afaics already got merged into the right branch already:
https://lore.kernel.org/all/164637060982.7623.2431046217416492091.git-patchwork-notify@kernel.org/

It just came slightly too late for the last pull into the net. The same
had happened a week earlier with regression fixes, that's why I already
brought this up:

https://lore.kernel.org/netdev/37349299-c47b-1f67-2229-78ae9b9b4488@leemhuis.info/

Short story: things should hopefully improve soon.

BTW: @bluetooth maintainers, I noticed your -next branch is in next, but
your -fixes branch
git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git is
not. Is that on purpose? Some (many?) of the other trees downstream to
the net tree have both their -fixes and their -next branches included
there regularly.

> Cc'ing the right people just to prod them, since we've had much too
> many "Oh, I didn't even realize it was a regression" issues this time
> around.

Yeah, since I started regression tracking again I noticed that quite a
few regressions fixes are merged quite slowly because maintainers put
them in their -next branches instead of sending them towards mainline
within a few days. I always try to make the maintainers aware of this
when I noticed it. That already helped a little afaics, but there is
more work ahead of me afaics...

Ciao, Thorsten
