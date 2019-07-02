Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983B85D6CB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGBTV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:21:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42777 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbfGBTV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:21:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E086721F6D;
        Tue,  2 Jul 2019 15:21:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 02 Jul 2019 15:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=H1eyvMtTWOTiP2We7gzPAIDaj/UBsLA87/zgqMXvy
        EE=; b=LGXYc763qalKVbTmzWzbomTXW1P/8UwjZEs6DxMO+8aOREt1Sb1OssFRG
        tmfIiUEuhEKnVilEepWZS7gsLQmVW0nSiwU90WXPSP3FQmWHH5KIIjyBNmmUOlFH
        0SIxbxFplH6viRgMOYB6JhPSl6fa3ls7+tey8u0RIzuz7l8ZdcKRl3U3X4vWXall
        DZuuJyHZu9AYblz7UMwkg7IVxYySF57wtvV47OzcFftjHNXuPRc2Kqewz5fOtIh4
        FnHi8FvukejRwSUhZ2p5RiKUUQtwya6RNhQcLcDnZysVNpMs4N6zed+wHmroarxa
        9Qx/yq6VaxQW6uacthqgThiMIGHtw==
X-ME-Sender: <xms:ta4bXeaZ2IVkHFjCQGvl3SN1bclb24-aa2C4iXKB3TN7N38qzbBMqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdekgddugedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    dtledrieehrdeifedruddtudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ta4bXe1wYD5aCLH0WAw1p3MKLf-n_Q3MeiOod3T_DBEdmvMbF1URcg>
    <xmx:ta4bXY6-UfMXJ-ePgb8RWyDIiCYVxDWYIA1cWhsZqpweh3gOq9DdGQ>
    <xmx:ta4bXSRPLkSTRxdFnjA3GlSp7bMaSWd9eN7sen_k_kChFQshgVxP8A>
    <xmx:ta4bXT_BNnagpwoiMc1T3WgHFXH-iYpCbBK6m6xIrdjG228kte4rBw>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF00B80063;
        Tue,  2 Jul 2019 15:21:24 -0400 (EDT)
Date:   Tue, 2 Jul 2019 22:21:22 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     =?iso-8859-1?Q?Zolt=E1n?= Elek <elek.zoltan.dev@gmail.com>
Cc:     netdev@vger.kernel.org, dsa@cumulusnetworks.com
Subject: Re: veth pair ping fail if one of them enslaved into a VRF
Message-ID: <20190702192122.GA16784@splinter>
References: <CANsP1a4HCthstZP16k-ABajni1m75+VKT+mgLPF=4yGJ-H_ONQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsP1a4HCthstZP16k-ABajni1m75+VKT+mgLPF=4yGJ-H_ONQ@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 08:42:15PM +0200, Zoltán Elek wrote:
> Hi!
> 
> I have a simple scenario, with a veth pair, IP addresses assigned from
> the same subnet. They can ping eachother. But when I put one of them
> into a VRF (in the example below, I put veth in-vrf into the test-vrf
> VRF) the ping fails. My first question: that is the expected behavior?
> And my second question: is there any way to overcome this?
> 
> Here are my test commands:
> ip link add out-of-vrf type veth peer name in-vrf
> ip link set dev out-of-vrf up
> ip link set dev in-vrf up
> ip link add test-vrf type vrf table 10
> ip link set dev test-vrf up
> ip -4 addr add 100.127.253.2/24 dev in-vrf
> ip -4 addr add 100.127.253.1/24 dev out-of-vrf
> 
> Then ping works as expected:
> ping -c1 -I 100.127.253.1 100.127.253.2
> 
> After I put the in-vrf into test-vrf, ping fails:
> ip link set in-vrf vrf test-vrf up

You need to re-order the FIB rules so that lookup for 100.127.253.1
happens in table 10 and not in the local table:

# ip -4 rule add pref 32765 table local
# ip -4 rule del pref 0
# ip -4 rule show 
1000:   from all lookup [l3mdev-table] 
32765:  from all lookup local 
32766:  from all lookup main 
32767:  from all lookup default 

Bad:

ping 16735 [001] 13726.398115: fib:fib_table_lookup: table 255 oif 0 iif
9 proto 0 100.127.253.2/0 -> 100.127.253.1/0 tos 0 scope 0 flags 4 ==>
dev out-of-vrf gw 0.0.0.0 src 100.127.253.1 err 0

Good:

ping 16665 [001] 13500.937145: fib:fib_table_lookup: table 10 oif 0 iif
9 proto 0 100.127.253.2/0 -> 100.127.253.1/0 tos 0 scope 0 flags 4 ==>
dev in-vrf gw 0.0.0.0 src 100.127.253.2 err 0

> 
> Thanks,
> Zoltan Elek,
> VI1
