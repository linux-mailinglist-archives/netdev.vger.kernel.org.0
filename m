Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E781C34E864
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhC3NFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:05:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49497 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231924AbhC3NFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:05:15 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B66765C00C6;
        Tue, 30 Mar 2021 09:05:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 30 Mar 2021 09:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=A0MburTfIsNpVJMyAjn9JNnxw5czxShi/IgsGyLRK
        G0=; b=D1w1kaGuTmRCargSPR5s4wvTStQwnuCuLKfU4vUXiFxgKpZ7JPwRAXbeL
        aNYzDKJV8iGMe7ikmJYqpn5qRgxC3k1d6Y0yo5chbrZODaIdpMZOQRrSKeuBA0DX
        s/XKCrsf7krxzyceXkIYkNG5OEPrr3o1owZvjtBqAphWl7ORrRLbn3md3hnrCpN7
        bywQS0R6LqfTuhxhjFod1eXN0vGXkk9cfwhspmFICkJsGLyLrvzbOBIC6dWmQQO1
        MUURT0rsvGoL/WFytmS02wL0sHBfKeHxWy/Kf2dMPUiVk1PNjBDSEUHsuXcctz5Q
        +gIYPd/s1GgYNAAcL7KtcKg0Jl/WA==
X-ME-Sender: <xms:CiJjYFsYlX5-xorIbe1j6I0x-KiXSb_z9gXc2J2uj5gjDdYSEEdc2g>
    <xme:CiJjYJ-zU9q_Sv-MmqqcQzBNP_pUkIwLpfn1Po_J7_bhHapxNwTklxhZPh3o1QW3_
    t9VnjEKBt6jeG8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeitddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjsehtke
    ortddttdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeejteejudevvdfhhfevhedvuddvff
    ffhfetteegkeeufedvledvteelveehfeeukeenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CiJjYPN-OScpsrOq-8t631eBlcwDbrvHa0ojvBKAYifI_8gMbvMXDQ>
    <xmx:CiJjYHEco1J-MwCtcX0RMwQqn7Fgw0cRbPx5Z_d5PiO7YG0QioV94g>
    <xmx:CiJjYNT7KPV2RnFdxLuDzvuZhE6gFIqeH2XeF4GeO7uA77R-rUl2Xw>
    <xmx:CiJjYG6iDekBM08TRHYIcf8ieATQ96ZKXTqLvocFrRPclLE0tsgPLQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD5881080057;
        Tue, 30 Mar 2021 09:05:13 -0400 (EDT)
Date:   Tue, 30 Mar 2021 16:05:10 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     xuchunmei <xuchunmei@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: ip-nexthop does not support flush by id
Message-ID: <YGMiBowCKbVHJrfh@shredder.lan>
References: <C2B7C7DB-B613-41BB-9D5F-EF162181988C@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C2B7C7DB-B613-41BB-9D5F-EF162181988C@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 08:44:30PM +0800, xuchunmei wrote:
> Hi,
> 
> I use iproute-5.10 with kernel-5.10.6, I found that ip-nexthop does not support flush by id, is it by design?
> 
> Reproduce steps:
> # ip netns add me
> # ip -netns me addr add 127.0.0.1/8 dev lo
> # ip -netns me link set lo up
> # ip -netns me nexthop add id 105 blackhole proto 99
> # ip -netns me nexthop flush id 105
> id 105 blackhole proto 99
> # ip -netns me nexthop ls
> id 105 blackhole proto 99
> 
> while use flush without any args, flush will success.
> # ip -netns me nexthop flush
> Flushed 1 nexthops
> 
> I find the function ipnh_list_flush implemented in ipnexthop.c:
> 
> else if (!strcmp(*argv, "id")) {
> 			__u32 id;
> 
> 			NEXT_ARG();
> 			if (get_unsigned(&id, *argv, 0))
> 				invarg("invalid id value", *argv);
> 			return ipnh_get_id(id);
> 		} 
> 
> When args is “id”, just return the related info of “id”, so I want to known is it by design ?

Looks like a bug. 'flush' does not really make sense with 'id', but
'list id' works, so I think 'flush id' should also work.

Can you send a patch?
