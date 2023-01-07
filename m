Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9184B660B5D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 02:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbjAGBRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 20:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGBRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 20:17:15 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42B91582A;
        Fri,  6 Jan 2023 17:17:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 4370F604F1;
        Sat,  7 Jan 2023 02:17:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673054231; bh=tOXkAcpVzrI4E+5+ZN43yIpq5j8zJF+acCO3Fcif6zc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=zm1IbIjgjy6oK6N72T5+uASSYpEmjtOiiAxE4COmPYs74vloKLz/ZLiv59bd98xmH
         niiHGyNSqtQsObKNFsBEMKrc96sGZm0p9V0vHJqcG2om7UZwJ1hss5vKsRmOZHfCtY
         M8owRHgopmOZUNEbnT7DiR41xCg+TtZCiCCjp+/MkWHls8FbszdIEp6lPJVlyGbeYl
         qHG2NBNY/f4K61Sr3/ZPRzktZjDYj6xrP8bjzq+OVJdFLgtvWz7L73t6BnWvtmVVb3
         sFZQMYUwci3GTpRMH429c69OfJqnGxFVEj5tW09fiUepGARWbUdv9Q3yPyzJB4/gaO
         e3uS3EpN6JOoA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nhdIEi3gejxc; Sat,  7 Jan 2023 02:17:08 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id ED354604F0;
        Sat,  7 Jan 2023 02:17:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673054228; bh=tOXkAcpVzrI4E+5+ZN43yIpq5j8zJF+acCO3Fcif6zc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S2Vsk/Nn6rS/utirW0NetD9KbZ1+k3jfS41b3lRf/FNgnpsuKtZinjJ2XthUImM3a
         YQxaMVrLB7v0Sm2i86CX2jXcuUVheAInv7Q+Q8VtEGetgZNQOmLyfo8BNflHgNCtn4
         m0IRbdFIiaAXa46CjUMqxH8KJUbTOaHyd3d5/rWvrK/yOGbjYpGR8CD85CnB0NxNAD
         LChIQwz2NavuThVgLIo7q0aqC1vcx+r6I4zUrC/Xc7tyGgR1ZkmMu+RvXgmGE6bQYt
         20NO3nmkVvB9xDedALD2oWd1znHAUWvPSEJ6wi0Emt9rkFfNp14FDohE33wPv4zvnK
         J8vvnWX3OBe4g==
Message-ID: <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
Date:   Sat, 7 Jan 2023 02:17:07 +0100
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <Y7i5cT1AlyC53hzN@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07. 01. 2023. 01:14, Guillaume Nault wrote:
> On Fri, Jan 06, 2023 at 02:44:11AM +0100, Mirsad Goran Todorovac wrote:
>> [root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/l2_tos_ttl_inherit.sh
>> ┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     4 │     4 │ inherit 0xc4 │  inherit 116 │ false │Cannot create namespace file "/var/run/netns/testing": File exists
>> RTNETLINK answers: File exists
>> RTNETLINK answers: File exists
>> RTNETLINK answers: File exists
> 
> You probably have leftovers from a previous test case. In particular
> the "testing" network name space already exists, which prevents the
> script from creating it. You can delete it manually with
> "ip netns del testing". If this netns is there because of a previous
> incomplete run of l2_tos_ttl_inherit.sh, then you'll likely need to
> also remove the tunnel interface it created in your current netns
> ("ip link del tep0").

Thanks, it worked :)

> Ideally this script wouldn't touch the current netns and would clean up
> its environment in all cases upon exit. I have a patch almost ready
> that does just that.

As these interfaces were not cleared by "make kselftest-clean",
this patch with a cleanup trap would be most welcome.

However, after the cleanup above, the ./l2_tos_ttl_inherit.sh
script hangs at the spot where it did in the first place (but
only on Lenovo desktop 10TX000VCR with BIOS M22KT49A from
11/10/2022, AlmaLinux 8.7, and kernel 6.2-rc2; not on Lenovo
Ideapad3 with Ubuntu 22.10, where it worked like a charm with
the same kernel RC).

The point of hang is this:

[root@pc-mtodorov net]# ./l2_tos_ttl_inherit.sh
┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │     4 │ inherit 0xb8 │  inherit 102 │ false │     OK │
│    gre │     4 │     4 │ inherit 0x10 │   inherit 53 │  true │     OK │
│    gre │     4 │     4 │   fixed 0xa8 │    fixed 230 │ false │     OK │
│    gre │     4 │     4 │   fixed 0x0c │     fixed 96 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │     6 │ inherit 0xbc │  inherit 159 │ false │     OK │
│    gre │     4 │     6 │ inherit 0x5c │  inherit 242 │  true │     OK │
│    gre │     4 │     6 │   fixed 0x38 │    fixed 113 │ false │     OK │
│    gre │     4 │     6 │   fixed 0x78 │     fixed 34 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │ other │ inherit 0xec │   inherit 69 │ false │     OK │
│    gre │     4 │ other │ inherit 0xf0 │  inherit 201 │  true │     OK │
│    gre │     4 │ other │   fixed 0xec │     fixed 14 │ false │     OK │
│    gre │     4 │ other │   fixed 0xe4 │     fixed 15 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     6 │     4 │ inherit 0xc4 │   inherit 21 │ false │     OK │
│    gre │     6 │     4 │ inherit 0xc8 │  inherit 230 │  true │     OK │
│    gre │     6 │     4 │   fixed 0x24 │    fixed 193 │ false │     OK │
│    gre │     6 │     4 │   fixed 0x1c │    fixed 200 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     6 │     6 │ inherit 0xe4 │   inherit 81 │ false │     OK │
│    gre │     6 │     6 │ inherit 0xa4 │  inherit 130 │  true │     OK │
│    gre │     6 │     6 │   fixed 0x18 │    fixed 140 │ false │     OK │
│    gre │     6 │     6 │   fixed 0xc8 │    fixed 175 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     6 │ other │ inherit 0x74 │  inherit 142 │ false │     OK │
│    gre │     6 │ other │ inherit 0x50 │  inherit 125 │  true │     OK │
│    gre │     6 │ other │   fixed 0x90 │     fixed 84 │ false │     OK │
│    gre │     6 │ other │   fixed 0xb8 │    fixed 240 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     4 │     4 │ inherit 0xb4 │   inherit 93 │ false │

Developers usually ask for bash -x output of the script that failed or hung
when reporting problems (too long for an email):

https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/bash-l2_tos_ttl_inherit.html

dmesg might be useful:

https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/dmesg-20230107.txt

Hope this helps.

I am rather new to namespaces, so I can't help more than that with the current
state of my learning curve :)

Thanks,
Mirsad

--
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
-- 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

