Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FA122ED69
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgG0Ndl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:33:41 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37971 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728322AbgG0Ndk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:33:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0448158053F;
        Mon, 27 Jul 2020 09:33:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Jul 2020 09:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YgsMZx
        5pwgpEVAvT6XOgIf4w7AHitJHDyTwwU4qEatA=; b=jQRpjra5a+K9eBy0w+s+Vz
        mPB94ZBosBduEWOnSjljw+8hpjEzFFC904sOPmp7ARDe+7b/eXgsCKJmhtNyicBZ
        zCPwwjkkb05K0YfGiAlA2DjbQ1tDLUZN+JjPw3S7qjVj1grZEX4aHI1AiVsE9Io+
        bNlBAGI/fkhfHIPXd+03GrSnOlle3YkzFc7ppSc0/mjvP7Ug0ymP/jml3M2cNzpZ
        3nqHV1F7F7FdVxhEmwJMcva5WUKD1OYbGuvTFkmIgufIhR4Y72HrPEITOBAe68Cd
        fvWvVqG/K7r5+3fgppYIz90IWY9h/aEu1muFU3O5nc5cERR4JMg31zdbbJgisnTQ
        ==
X-ME-Sender: <xms:rtceXy0qPafjj9qpXmjj6TnMvhnN8iqgYqZd1rJD6mGA9-PBCQUb-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudekuddrvddrudejleenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rtceX1F_YViw2fDAyMCnC7fGnfljQba279q87vXUcjjPowXNi_Cqsg>
    <xmx:rtceX65T8s2wLqXjs6IFdWVooA4TqBK23wtFXT8C9ITPngl1WqSE7w>
    <xmx:rtceXz1hp7RD7fUx415E-Em3LUMy8FS0rLa4p_YYh0paweRCsdWclA>
    <xmx:stceX9WkosEn1T_dUOgyyDuWyUiT95rC7CZ-5r4WjPh7lQcldUdW1g>
Received: from localhost (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9886A3280064;
        Mon, 27 Jul 2020 09:33:33 -0400 (EDT)
Date:   Mon, 27 Jul 2020 16:33:31 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 19/26] net/ipv6: switch ipv6_flowlabel_opt to sockptr_t
Message-ID: <20200727133331.GA1851348@shredder>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-20-hch@lst.de>
 <20200727121505.GA1804864@shredder>
 <20200727130029.GA26393@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727130029.GA26393@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:00:29PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 27, 2020 at 03:15:05PM +0300, Ido Schimmel wrote:
> > I see a regression with IPv6 flowlabel that I bisected to this patch.
> > When passing '-F 0' to 'ping' the flow label should be random, yet it's
> > the same every time after this patch.
> 
> Can you send a reproducer?

```
#!/bin/bash

ip link add name dummy10 up type dummy

ping -q -F 0 -I dummy10 ff02::1 &> /dev/null &
tcpdump -nne -e -i dummy10 -vvv -c 1 dst host ff02::1
pkill ping

echo

ping -F 0 -I dummy10 ff02::1 &> /dev/null &
tcpdump -nne -e -i dummy10 -vvv -c 1 dst host ff02::1
pkill ping

ip link del dev dummy10
```

Output with commit ff6a4cf214ef ("net/ipv6: split up
ipv6_flowlabel_opt"):

```
dropped privs to tcpdump
tcpdump: listening on dummy10, link-type EN10MB (Ethernet), capture size 262144 bytes
16:26:27.072559 62:80:34:1d:b4:b8 > 33:33:00:00:00:01, ethertype IPv6 (0x86dd), length 118: (flowlabel 0x920cf, hlim 1, next-header ICMPv6 (58) payload length: 64) fe80::6080:34ff:fe1d:b4b8 > ff02::1: [icmp6 sum ok] ICMP6, echo request, seq 2
1 packet captured
1 packet received by filter
0 packets dropped by kernel

dropped privs to tcpdump
tcpdump: listening on dummy10, link-type EN10MB (Ethernet), capture size 262144 bytes
16:26:28.352528 62:80:34:1d:b4:b8 > 33:33:00:00:00:01, ethertype IPv6 (0x86dd), length 118: (flowlabel 0xcdd97, hlim 1, next-header ICMPv6 (58) payload length: 64) fe80::6080:34ff:fe1d:b4b8 > ff02::1: [icmp6 sum ok] ICMP6, echo request, seq 2
1 packet captured
1 packet received by filter
0 packets dropped by kernel
```

Output with commit 86298285c9ae ("net/ipv6: switch ipv6_flowlabel_opt to
sockptr_t"):

```
dropped privs to tcpdump
tcpdump: listening on dummy10, link-type EN10MB (Ethernet), capture size 262144 bytes
16:32:17.848517 f2:9a:05:ff:cb:25 > 33:33:00:00:00:01, ethertype IPv6 (0x86dd), length 118: (flowlabel 0xfab36, hlim 1, next-header ICMPv6 (58) payload length: 64) fe80::f09a:5ff:feff:cb25 > ff02::1: [icmp6 sum ok] ICMP6, echo request, seq 2
1 packet captured
1 packet received by filter
0 packets dropped by kernel

dropped privs to tcpdump
tcpdump: listening on dummy10, link-type EN10MB (Ethernet), capture size 262144 bytes
16:32:19.000779 f2:9a:05:ff:cb:25 > 33:33:00:00:00:01, ethertype IPv6 (0x86dd), length 118: (flowlabel 0xfab36, hlim 1, next-header ICMPv6 (58) payload length: 64) fe80::f09
a:5ff:feff:cb25 > ff02::1: [icmp6 sum ok] ICMP6, echo request, seq 2
1 packet captured
1 packet received by filter
0 packets dropped by kernel
```

> 
> > 
> > It seems that the pointer is never advanced after the call to
> > sockptr_advance() because it is passed by value and not by reference.
> > Even if you were to pass it by reference I think you would later need to
> > call sockptr_decrease() or something similar. Otherwise it is very
> > error-prone.
> > 
> > Maybe adding an offset to copy_to_sockptr() and copy_from_sockptr() is
> > better?
> 
> We could do that, although I wouldn't add it to the existing functions
> to avoid the churns and instead add copy_to_sockptr_offset or something
> like that.

Sounds good

Thanks
