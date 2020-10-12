Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C346428AB2A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 02:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgJLAGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 20:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgJLAGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 20:06:10 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B9EC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 17:06:09 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q25so1764625ioh.4
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 17:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JqFPdm7Uuq0N9/hGjayf2PVrscGqAUsq6FQXY21IyLY=;
        b=FpTGfwbkPDxbVnH3stNRi0wrtMrhOwQnd/lFlZkryoShtqIaikFim6fqrQqEYO/ja8
         FJ/s1B5N1oFddQvnKqvSFbcYPiGf9g7ePLIJnlnB7aukbR9myty8VvnGJVsJcO2m5UKq
         JMc7LakxE0A9ASCz7ZqGTwUek/f9Nm175KUbsA2PGhaH+Y5covSv16CbCGlHM4ou0Sbx
         3HZSJMIDRlFUVflV0N04sdBdpwQk+HYVThhdmZb2Lu/ams84uTZ9pDi5PUmVO7ITlgb9
         hBkueoKkjWQKlE1C3KEjte086w+iL3uexWmIbhqZZPkFZJvEPTnhM1A4Ps56L3+ogoWD
         v0oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JqFPdm7Uuq0N9/hGjayf2PVrscGqAUsq6FQXY21IyLY=;
        b=LxuzoBuqvo1opTweMPlIsHan8FNWEb1WJhmjpv+WEQHb8a5e79/2DbqTYmlg6WuSs7
         eP916UeUq82WY39HQVr35nByf+2yTqlEIBtHfmNffpUhEZoPQ1+8mEV5Ecx9Ir5ZyHnP
         kjHts8NgGs2ynzyLglCUXFduQdHkTkPrXsPi0/tYc15zvT4m49517FYss735k8KRb9K/
         lJx/z6cLIxxSI9RxNhWrwVYPHK7ASlTRPrQG/OuLoqlXQiWAjlflJAViKnrYp0BBfYwV
         4VA0S5nwt9Suwf+0BPiovRPoj3Akd3ChUm7TI/ZSIR/QLdRCEFAyzYpqP38tTZYFEeoy
         j1ag==
X-Gm-Message-State: AOAM532tjw5sNohcXIMtl5FmUz06mqcgqaPHfpsR9a/pqAiyIYAKXY6E
        ZEOh25OsWRnTfpSpRJ3h4ePZDoO5s1w=
X-Google-Smtp-Source: ABdhPJwnAqDvuZzoM2EI8HT4CMzCk5TwVpdCWSd5n7QhqcuF63zNUwMsXHQ60T1MEZD91s/QIAkuew==
X-Received: by 2002:a5d:9243:: with SMTP id e3mr15121719iol.193.1602461168014;
        Sun, 11 Oct 2020 17:06:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id r2sm7514950ile.1.2020.10.11.17.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 17:06:07 -0700 (PDT)
Subject: Re: ip rule iif oif and vrf
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200922131122.GB1601@ICIPI.localdomain>
 <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
 <20200923235002.GA25818@ICIPI.localdomain>
 <ccba2d59-58ad-40ca-0a09-b55c90e9145e@gmail.com>
 <20200924134845.GA3688@ICIPI.localdomain>
 <97ce9942-2115-ed3a-75ea-8b58aa799ceb@gmail.com>
 <20201001022345.GA3527@vmserver>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d4d0a18-0f08-d171-dcbe-26e01d354b13@gmail.com>
Date:   Sun, 11 Oct 2020 18:06:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201001022345.GA3527@vmserver>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 7:23 PM, Stephen Suryaputra wrote:
> On Thu, Sep 24, 2020 at 08:41:54AM -0600, David Ahern wrote:
>>> We have multiple options on the table right now. One that can be done
>>> without writing any code is to use an nft prerouting rule to mark
>>> the packet with iif equals the tunnel and use ip rule fwmark to lookup
>>> the right table.
>>>
>>> ip netns exec r0 nft add table ip c2t
>>> ip netns exec r0 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
>>> ip netns exec r0 nft rule ip c2t prerouting iif gre01 mark set 101 counter
>>> ip netns exec r0 ip rule add fwmark 101 table 10 pref 999
>>>
>>> ip netns exec r1 nft add table ip c2t
>>> ip netns exec r1 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
>>> ip netns exec r1 nft rule ip c2t prerouting iif gre10 mark set 101 counter
>>> ip netns exec r1 ip rule add fwmark 101 table 10 pref 999
>>>
>>> But this doesn't seem to work on my Ubuntu VM with the namespaces
>>> script, i.e. pinging from h0 to h1. The packet doesn't egress r1_v11. It
>>> does work on our target, based on 4.14 kernel.
>>
>> add debugs to net/core/fib_rules.c, fib_rule_match() to see if
>> flowi_mark is getting set properly. There could easily be places that
>> are missed. Or if it works on one setup, but not another compare sysctl
>> settings for net.core and net.ipv4
> 
> Sorry, I got side-tracked. Coming back to this: I made a mistake in the
> ip rule fwmark pref in the script. I have fixed it and the script is
> attached (gre_setup_nft.sh). It has the nft and ip rule commands above.
> The ping between h0 and h1 works.
> 
>>> We also notice though in on the target platform that the ip rule fwmark
>>> doesn't seem to change the skb->dev to the vrf of the lookup table.
>>
>> not following that statement. fwmark should be marking the skb, not
>> changing the skb->dev.
> 
> Yes and it causes the ping between h0 and r1 r1_v11 to not work, e.g.:
> 
> ip netns exec h0 ping -c 1 11.0.0.1
> 
> Similarly, ping between r0_v00 and r1_v11 also does not work:
> 
> ip netns exec r0 ip vrf exec vrf_r0t ping -c 1 -I 10.0.0.1 11.0.0.1
> 
>>> E.g., ping from 10.0.0.1 to 11.0.0.1. With net.ipv4.fwmark_reflect set,
>>> the reply is generated but the originating ping application doesn't get
>>> the packet.  I suspect it is caused by the socket is bound to the tenant
>>> vrf. I haven't been able to repro this because of the problem with the
>>> nft approach above.
> 
> To illustrate my statements above, this is what I did:
> ip netns exec r1 sysctl -w net.ipv4.fwmark_reflect=1
> ip netns exec h0 ping -c 1 11.0.0.1
> PING 11.0.0.1 (11.0.0.1) 56(84) bytes of data.
> 64 bytes from 11.0.0.1: icmp_seq=1 ttl=63 time=0.079 ms
> 
> The ping between h0 and r1 r1_v11 works, but it still doesn't work for this:
> ip netns exec r0 ip vrf exec vrf_r0t ping -c 1 -I 10.0.0.1 11.0.0.1
> 
> eventhough the reply is received by gre01:
> ip netns exec r0 tcpdump -nexi gre01
> 22:10:57.173680 Out ethertype IPv4 (0x0800), length 100: 10.0.0.1 > 11.0.0.1: ICMP echo request, id 3803, seq 1, length 64
> 	0x0000:  4500 0054 1d2a 4000 4001 087e 0a00 0001
> 	0x0010:  0b00 0001 0800 a410 0edb 0001 b13a 755f
> 	0x0020:  0000 0000 5da6 0200 0000 0000 1011 1213
> 	0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
> 	0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
> 	0x0050:  3435 3637
> 22:10:57.173724  In ethertype IPv4 (0x0800), length 100: 11.0.0.1 > 10.0.0.1: ICMP echo reply, id 3803, seq 1, length 64
> 	0x0000:  4500 0054 c709 0000 4001 9e9e 0b00 0001
> 	0x0010:  0a00 0001 0000 ac10 0edb 0001 b13a 755f
> 	0x0020:  0000 0000 5da6 0200 0000 0000 1011 1213
> 	0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
> 	0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
> 	0x0050:  3435 3637
> 
> In summary the question is: should ip rule with action FR_ACT_TO_TBL
> also change the skb->dev to the right l3mdev?

'ip rule' does not change the skb; only the vrf driver does that (and
some IPv4/IPv6 code reverts it). The rule code only changes the
flowi_oif setting.


