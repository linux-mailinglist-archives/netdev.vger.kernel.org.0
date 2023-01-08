Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC86615DD
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 15:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjAHOtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 09:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjAHOtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 09:49:13 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CAEFAF1;
        Sun,  8 Jan 2023 06:49:12 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id AD2C4604F1;
        Sun,  8 Jan 2023 15:49:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673189349; bh=OS8rlvupmkFQBCQzSf/w7ocx8qttC8TLbeD1niJU5eg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oYz7NEp4jURKXSDmFzXXdYHy7Zk/Gr7COc8X1BeigKrig72LjSwE378wbMdOf1ZMI
         mppNHBQ2MS4BypN4i3XYusEiVuQT6nK89hDz7qTntUn/QfNyFj9TD6Ur/2Yt9aSIoP
         B0lmnZNP2asZzEHpszTtJdkQKBlwEm+G93/Itj6GD6PA3lbEnazhaU/AeiElC6zBVD
         OESXoXEuKT6aq/hI4CZwjtZYomzRSf1WpQhcmzKNyoFGfn+vZIu+z17Yth0vW5Xmhm
         wLixBwnwiE1hTG1apgM7wUSJ3PyZPhWwhAxSJhZ1kVwpzHPt0+Io8abUN4RBw4a/PR
         FqfucYm8YaNrQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fUg93Lk8AU9Y; Sun,  8 Jan 2023 15:49:07 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id 9EAD2604F0;
        Sun,  8 Jan 2023 15:49:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673189347; bh=OS8rlvupmkFQBCQzSf/w7ocx8qttC8TLbeD1niJU5eg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HfAoLkwNQgTJOS23qUFNlQSXnG2HXCMjgUWeSi+pZ1WOOPGcMIFa9/1w7I7r+VP08
         v+tJOh4ao35SBXRZnaKYvRRCd5Y6Xpaz4rUYHnaYlC+d6aBwDK76P7/d7ian8Uello
         maXs9jGmgOhgqEDwmE7jhLy7Eq4I5VykmDuEFpQaoxzmvqFI+uQy5C/l1coO9bxdvU
         avxXhUQ9dBEsT9B1KbTt5/TKgTln0HzHflxyIF2rbRAI65U6l9kI9RBEkFnYeTS8dl
         /q7YlJK9CaApBbHm4HBkdyYBZ7HdVL+f14yzwBhMuMZFC98azn+/9JnR1ZerycsoTK
         oovKqBEbZmgYA==
Message-ID: <750cd534-1361-4102-67c5-2898814f8b4c@alu.unizg.hr>
Date:   Sun, 8 Jan 2023 15:49:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs when
 selftest restarted
Content-Language: en-US, hr
To:     Guillaume Nault <gnault@redhat.com>
Cc:     linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias May <matthias.may@westermo.com>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian> <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian> <81fdf2bc-4842-96d8-b124-43d0bd5ec124@alu.unizg.hr>
 <Y7rNgPj9WIroPcQ/@debian>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <Y7rNgPj9WIroPcQ/@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08. 01. 2023. 15:04, Guillaume Nault wrote:

> For some reasons, your host doesn't accept the VXLAN packets received
> over veth0. I guess there are some firewalling rules incompatible with
> this tests script.

That beats me. It is essentially a vanilla desktop AlmaLinux (CentOS fork)
installation w 6.2-rc2 vanilla torvalds tree kernel.

Maybe DHCPv4+DHCPv6 assigned address got in the way?

>>> -------- >8 --------
>>>
>>> Isolate testing environment and ensure everything is cleaned up on
>>> exit.
>>>
>>> diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
> 
>> Wow, Guillaueme, this patch actually made things unstuck :)
> 
> Great! The patch isolates the testing environment, making it less
> dependent from the host that runs it. So the routing and firewalling
> configurations don't interfere anymore.

:)

>> The entire tools/tests/selftests/net section now had a PASS w "OK", save for a couple of tests here:
>>
>> not ok 1 selftests: nci: nci_dev # exit=1
>> not ok 12 selftests: net: nat6to4.o
>> not ok 13 selftests: net: run_netsocktests # exit=1
>> not ok 29 selftests: net: udpgro_bench.sh # exit=255
>> not ok 30 selftests: net: udpgro.sh # exit=255
>> not ok 37 selftests: net: fcnal-test.sh # TIMEOUT 1500 seconds
>> not ok 38 selftests: net: l2tp.sh # exit=2
>> not ok 46 selftests: net: icmp_redirect.sh # exit=1
>> not ok 55 selftests: net: vrf_route_leaking.sh # exit=1
>> not ok 59 selftests: net: udpgro_fwd.sh # exit=1
>> not ok 60 selftests: net: udpgro_frglist.sh # exit=255
>> not ok 61 selftests: net: veth.sh # exit=1
>> not ok 68 selftests: net: srv6_end_dt46_l3vpn_test.sh # exit=1
>> not ok 69 selftests: net: srv6_end_dt4_l3vpn_test.sh # exit=1
>> not ok 75 selftests: net: arp_ndisc_evict_nocarrier.sh # exit=255
>> not ok 83 selftests: net: test_ingress_egress_chaining.sh # exit=1
>> not ok 1 selftests: net/hsr: hsr_ping.sh # TIMEOUT 45 seconds
>> not ok 3 selftests: net/mptcp: mptcp_join.sh # exit=1
>>
>> If you are interested in additional diagnostics, this is a very interesting part of the
>> Linux kernel testing ...
>>
>> There was apparent hang in selftest/net/fcnal-test.sh as well.
>> I can help you with the diagnostics if you wish? Thanks.
>>
>> If I could make them all work both on Ubuntu 22.10 kinetic kudu and AlmaLinux 8.7
>> stone smilodon (CentOS fork), this would be a milestone for me :)
> 
> I'm surprised you have so many failures. Feel free to report them
> individually. Don't forget to Cc the authors of the scripts. Just
> pay attention not to overwhelm people.

Sure. I have already submitted half a dozen and I already feel the backlash,
"wear and tear" :)

But it is a good brainstorming session for me.

I realise that developers receive a lot of bug reports from the volume of LKML.

> I can probably help with the l2tp.sh failure and maybe with the
> fcnal-test.sh hang. Please report them in their own mail thread.

Then I will Cc: you for sure on those two.

But I cannot promise that this will be today. In fact, tomorrow is prognosed
rain so I'd better use the remaining blue-sky-patched day to do some biking ;-)

Anyway, I haven't received feedback from all submitted bug reports, so my stack
is near the overload. However, I made the "make kselftest" complete on both boxes
(and OSs of Debian and RH lineage), so I already feel some accomplishment :)

Maybe some issues will be fixed in today's release candidate, anyway.

Mirsad 

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

