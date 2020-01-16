Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1122613D652
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgAPJBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:01:38 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39163 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgAPJBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:01:38 -0500
Received: by mail-pj1-f65.google.com with SMTP id e11so1272844pjt.4
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 01:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZQXBqfdhsAZ3/6okGA1MSOFGc6p5z1v/pMuhuVz+/n4=;
        b=JhprW+ZLT9/I/TIGhFzpHzLCuTI0esvSUgF6agbkVShG980adh20SdyIz7W0JWxq0B
         DfGMYBTQBYkYq/dxLXc2FB9lkGLafBUQNicatpzHQ/ncWEey1KaGN/FqTZ6CFKwNhVgn
         Ps+6nZHU6ts9IyuHXlo3NdJiRHtZ0uVdsDTSS1IyWCqxlVNMbL1ZuMZO6wJkIiwEmEOL
         xs45Npqei0l5a8IF1fWYGdkr6+jzh0BtA+fc7r+glvmfobffHlKg9F0dYeHkJS9LinvP
         tvu7BJyyeDY2rcWOtZHi0xmYG5BmO6y3+E5kFkpqqz3SMoAgexorX499ky9DuLQjKBsb
         lhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZQXBqfdhsAZ3/6okGA1MSOFGc6p5z1v/pMuhuVz+/n4=;
        b=BwkvhUo5yaYQZi8dPRMqC+Zqkv2OBRqJr0NWW+Huq8JRFix5qD8nHydeHAEtJYYpvN
         StOparV8mNDHMnS319Xq3b9e8l7ZpAABdWA8ZZkqq+9hS6OV8QAPc0UhxSO+dJTW/nSm
         tIrrgIvRVb+icrGOUaSCGS/Ohz/S74+EMyxk4s6D06rvSg+tXiyoLmaMNuhyUFsjnO6Y
         wWayCPuVeE0U4+3r5jXUlSH6A8KnNOIXkcGqUYNJTOoKipnnMsr8xZ/fIXj9m5BN7hrA
         suiZq4ObrA1DFWedrnkhNf6kYbJ8KJGEmevTGB6gPyPSps5i9HkcXloqw27Aa9Ctj70K
         Qt9g==
X-Gm-Message-State: APjAAAXpfamXOZ7c5pMY0fvhonKgaa+W+sfYunIzlKILkMmTROl4n7rT
        Q5Nqbnu47qjx/rD5s+9yDMg=
X-Google-Smtp-Source: APXvYqxpz/q/eOe9XGRy1KIcRz4jmEr7hu8RDLJoTCM5zMdXJOd4j5cED5/crmmGsk/f1zGjwQfw/Q==
X-Received: by 2002:a17:902:b103:: with SMTP id q3mr30686280plr.37.1579165297411;
        Thu, 16 Jan 2020 01:01:37 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o98sm2746542pjb.15.2020.01.16.01.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 01:01:36 -0800 (PST)
Subject: Re: Veth pair swallow packets for XDP_TX operation
To:     Hanlin Shi <hanlins@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cheng-Chun William Tu <tuc@vmware.com>
References: <1D6D69BF-5643-45C2-A0F5-2D30C9C608E5@vmware.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <fb2d324b-35fb-802d-2e1d-1ee1aa234c16@gmail.com>
Date:   Thu, 16 Jan 2020 18:01:32 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1D6D69BF-5643-45C2-A0F5-2D30C9C608E5@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hanlin,

On 2020/01/16 7:35, Hanlin Shi wrote:
> Hi community,
> 
> I’m prototyping an XDP program, and the hit issues with XDP_TX operation on veth device. The following code snippet is working as expected on 4.15.0-54-generic, but is NOT working on 4.20.17-042017-lowlatency (I got the kernel here: https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20.17/).
> 
> Here’s my setup: I created a veth pair (namely veth1 and veth2), and put them in two namespaces (namely ns1 and ns2). I assigned address 60.0.0.1 on veth1 and 60.0.0.2 on veth2, set the device as the default interface in its namespace respectively (e.g. in ns1, do “ip r set default dev veth1”). Then in ns1, I ping 60.0.0.2, and tcpdump on veth1’s RX for ICMP.
> 
> Before loading any XDP program on veth2, I can see ICMP replies on veth1 interface. I load a program which do “XDP_TX” for all packets on veth2. I expect to see the same ICMP packet being returned, but I saw nothing.
> 
> I added some debugging message in the XDP program so I’m sure that the packet is processed on veth2, but on veth1, even with promisc mode on, I cannot see any ICMP packets or even ARP packets. In my understanding, 4.15 is using generic XDP mode where 4.20 is using native XDP mode for veth, so I guess there’s something wrong with veth native XDP and need some helps on fixing the issue.

You need to load a dummy program to receive packets from peer XDP_TX when using native veth XDP.

The dummy program is something like this:
int xdp_pass(struct xdp_md *ctx) {
	return XDP_PASS;
}
And load this program on "veth1".

For more information please refer to this slides.
https://netdevconf.info/0x13/session.html?talk-veth-xdp

Also there is a working example here.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/test_xdp_veth.sh

Toshiaki Makita

> 
> Please let me know if you need help on reproducing the issue.
> 
> Thanks,
> Hanlin
> 
> PS: here’s the src code for the XDP program:
> #include <stddef.h>
> #include <string.h>
> #include <linux/if_vlan.h>
> #include <stdbool.h>
> #include <bpf/bpf_endian.h>
> #include <linux/if_ether.h>
> #include <linux/ip.h>
> #include <linux/tcp.h>
> #include <linux/udp.h>
> #include <linux/in.h>#define DEBUG
> #include "bpf_helpers.h"
> 
> SEC("xdp")
> int loadbal(struct xdp_md *ctx) {
>    bpf_printk("got packet, direct return\n");
>    return XDP_TX;
> }char _license[] SEC("license") = "GPL";
> 
> "bpf_helpers.h" can be found here: https://github.com/dropbox/goebpf/raw/master/bpf_helpers.h
> 
