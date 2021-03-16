Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C107633D007
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhCPIjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:39:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47991 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235240AbhCPIjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:39:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EF5F75C00EA;
        Tue, 16 Mar 2021 04:39:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 04:39:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ybb4+l
        kT5Aoatj2tUP8ztn4bXpxGuYu/3EmhvjOV8/U=; b=E3/M8ZU0ahsAfy1/JzW3nZ
        n3d0ho68Q4M7oRlzTjEQysZwBIr6aUKfxd3JjLpyv08Tarxf0y9dBP/SStni+jNT
        ksS90VaiDw5wpeY9r9XjcA2CoiPtSyf21QrOiAlXV6S2c6dp2Qgj9xO18Csnlitd
        WzBSBUIgzoz/SEUCXTZwn4NENQwzGVX5wun5L8Q+mcXq/XV3fQdzODARkyUzJsLK
        Q+rRncANOJYjgqMtkWso4r//pfEEgAMF//Ww40luR/rsp3sorCIj4OLKpWUim/Nf
        mE+tJrJduM/8l8jd35Fo1UQD9WPmhAd6zh7uJcAQsGSRvJvH6uRi/ZmfSIsKGQwA
        ==
X-ME-Sender: <xms:w25QYCAG6AmDfXp_mEm_lBHVE3E1hHPMZ2pLlawP785nLrx5mRkD_w>
    <xme:w25QYMh3wVpR0tmh14mFc3YOagAEIOc6VkiQMH9j4fC_MnigqJPPucnr62oSjJrwU
    Nv26WJiN92HtrI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefuddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleeh
    keeunecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeegrddvvdelrdduhe
    efrdeggeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:w25QYFkIvkldvSvGX0VycZwBpeFi2QJ77Jf7ifCNYJYi3bN9L5UbWA>
    <xmx:w25QYAzwWEaR9StmYnNoslVsVeDSKvOjrD9zryLnuRZDCKSR94a6OA>
    <xmx:w25QYHTB3MrtNcI4kcH4ABSGZFmS2bS5sFAvhAoyWWFXTdT5kFcsPA>
    <xmx:w25QYKPbAdT_vay96BVgfcFTI-w_FLOcdAN4yqnUsWWCj89cXgQLPw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07B001080063;
        Tue, 16 Mar 2021 04:39:30 -0400 (EDT)
Date:   Tue, 16 Mar 2021 10:39:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Tim Rice <trice@posteo.net>, petrm@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: Re: [BUG] Iproute2 batch-mode fails to bring up veth
Message-ID: <YFBuv83HJLG0zMbw@shredder.lan>
References: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Petr

On Tue, Mar 16, 2021 at 06:22:08AM +1100, Tim Rice wrote:
> Hey all,
> 
> Sorry if this isn't the right place to report Iproute2 bugs. It was implied by README.devel as well as a couple of entries I saw in bugzilla.
> 
> I use iproute2 batch mode to construct network namespaces. Example script:
> 
>   $ cat ~/bin/netns-test.sh
>   #! /bin/bash
> 
>   gw=192.168.5.1
>   ip=192.168.5.2
>   ns=netns-test
>   veth0=${ns}-0
>   veth1=${ns}-1
> 
>   /usr/local/sbin/ip -b - << EOF
>   link add $veth0 type veth peer name $veth1
>   addr add $gw peer $ip dev $veth0
>   link set dev $veth0 up
>   netns add $ns
>   link set $veth1 netns $ns
>   netns exec $ns ip link set dev lo up
>   netns exec $ns ip link set dev $veth1 up
>   netns exec $ns ip addr add $ip/24 dev $veth1
>   netns exec $ns ip addr add $ip peer $gw dev $veth1
>   netns exec $ns ip route add default via $gw dev $veth1
>   netns exec $ns ip route add 192.168.0.0/24 via $gw dev $veth1
>   EOF
> 
> 
> I noticed when version 5.11.0 dropped that this stops working. Batch mode fails to bring up the inner veth.
> 
> Expected usage (as produced by v5.10.0):
> 
>   $ sudo ./bin/netns-test.sh
>   $ sudo ip netns exec netns-test ip route
>   default via 192.168.5.1 dev netns-test-1
>   192.168.0.0/24 via 192.168.5.1 dev netns-test-1
>   192.168.5.0/24 dev netns-test-1 proto kernel scope link src 192.168.5.2
>   192.168.5.1 dev netns-test-1 proto kernel scope link src 192.168.5.2
> 
> Actual behaviour:
> 
>   $ sudo ./bin/netns-test.sh
>   $ sudo ip netns exec netns-test ip route  # Notice the empty output
>   $ sudo ip netns exec netns-test ip link
>   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>   39: netns-test-1@if40: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/ether 1a:96:4e:4f:84:31 brd ff:ff:ff:ff:ff:ff link-netnsid 0
> 
> System info:
> 
> * Distro: Void Linux
> * Kernel version: 5.10.23
> * CPU: AMD Ryzen 7 1800X and Ryzen 5 2600. (Reproduced on both.)
> 
> Git bisect pinpoints this commit: https://github.com/shemminger/iproute2/commit/1d9a81b8c9f30f9f4abeb875998262f61bf10577
> 
> That commit was focused on refactoring batch mode. This is consistent with my experience that only batch mode is affected. Everything works as expected when running the commands manually.
> 
> ~ Tim
