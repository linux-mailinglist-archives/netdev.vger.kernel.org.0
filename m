Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0A235D477
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 02:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbhDMAcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 20:32:20 -0400
Received: from lists.nic.cz ([217.31.204.67]:43588 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239043AbhDMAcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 20:32:20 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id AC7B113FC7A;
        Tue, 13 Apr 2021 02:31:59 +0200 (CEST)
Date:   Tue, 13 Apr 2021 02:31:59 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210413023159.1f8fbfc1@thinkpad>
In-Reply-To: <20210413022730.2a51c083@thinkpad>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
        <20210411200135.35fb5985@thinkpad>
        <20210411185017.3xf7kxzzq2vefpwu@skbuf>
        <878s5nllgs.fsf@waldekranz.com>
        <20210412213045.4277a598@thinkpad>
        <8735vvkxju.fsf@waldekranz.com>
        <20210412235054.73754df9@thinkpad>
        <87wnt7jgzk.fsf@waldekranz.com>
        <20210413005518.2f9b9cef@thinkpad>
        <87r1jfje26.fsf@waldekranz.com>
        <87o8ejjdu6.fsf@waldekranz.com>
        <20210413015450.1ae597da@thinkpad>
        <20210413022730.2a51c083@thinkpad>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 02:27:30 +0200
Marek Behun <marek.behun@nic.cz> wrote:

> On Tue, 13 Apr 2021 01:54:50 +0200
> Marek Behun <marek.behun@nic.cz> wrote:
> 
> > I will look into this, maybe ask some follow-up questions.
> 
> Tobias,
> 
> it seems that currently the LAGs in mv88e6xxx driver do not use the
> HashTrunk feature (which can be enabled via bit 11 of the
> MV88E6XXX_G2_TRUNK_MAPPING register).
> 
> If we used this feature and if we knew what hash function it uses, we
> could write a userspace tool that could recompute new MAC
> addresses for the CPU ports in order to avoid the problem I explained
> previously...
> 
> Or the tool can simply inject frames into the switch and try different
> MAC addresses for the CPU ports until desired load-balancing is reached.
> 
> What do you think?
> 
> Marek

Although changing MAC addresses of the CPU ports each time some new
device comes into the network doesn't seem like a good idea, now that I
think about it. Hmm.
