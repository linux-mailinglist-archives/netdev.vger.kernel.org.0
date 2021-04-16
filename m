Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0F1362889
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhDPTVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:21:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59021 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239770AbhDPTVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 15:21:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C1A385C01FA;
        Fri, 16 Apr 2021 15:21:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 15:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hkuUGq
        h9yWA89x/h1qAfVGkW6sekiVlt/+V74/O8dKM=; b=N/u8ATg6im9EYVGjvc3Hcq
        vkQwfJFx3B0Jc8318uEtqYV6YtkjRIiG5f37pKMnpn+4z/S70JDXR7UNEJjMfiye
        tch+h+mEsy266hrnAnaAfH9Aft0PAl1MpbpX+lawLSuroYONKQ42mhhliV9LD+Uo
        dVH/Z7/zXjlV5Yiy6BsC4XTe1V6JkLdvrrgjHRk6QKTGDI8zbDvrUxEI0CyiynHh
        JQ/IlK6DDhs9lcTQlGXq1jfukljSpLcV9m7umaeUmCE3SguOJKEApdNqFBijOoiN
        k0PBN6IRUoWqDGZEl782zRrS1Z5a/FrN/E3HJexaEgMqtvqZkiKAgkU/qBAGmN0w
        ==
X-ME-Sender: <xms:reN5YE3ja89kyFERV5eYLNFUeDTbyEUTADykDiFJP0vqM_V2MtG1Rw>
    <xme:reN5YPERGdhp25OjzbJmX23lXeADUvLP768W1vTMGSAUd_AxDgdrVQ1QwrfGh_noQ
    4zVV_RWrImlXmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ortddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgjeevhfdvgeeiudekteduveegue
    ejfefffeefteekkeeuueehjeduledtjeeuudenucfkphepkeegrddvvdelrdduheefrddu
    keejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:reN5YM6BVwikuoughMdfFQMHZef7snZC2GihxMBG-Ocb4hd3eAfyoA>
    <xmx:reN5YN3ErL4DdsZJChClAN6qULpmXTdfn-FVMfERHNSf89HxSFOQ0g>
    <xmx:reN5YHEkbsZE8YLhqTQ7w4bNulJ9WFjBFGQSZR4T0ylmnLBKB5MNRQ>
    <xmx:ruN5YLinSf9ATrA3OrQwpOhUVwTsToBPipd9HeQtYd1rXQAATwPC0Q>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACAD2240057;
        Fri, 16 Apr 2021 15:21:16 -0400 (EDT)
Date:   Fri, 16 Apr 2021 22:21:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next 7/9] mlxsw: implement ethtool standard stats
Message-ID: <YHnjqCozQWYAXNmG@shredder.lan>
References: <20210416022752.2814621-1-kuba@kernel.org>
 <20210416022752.2814621-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416022752.2814621-8-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 07:27:50PM -0700, Jakub Kicinski wrote:
> mlxsw has nicely grouped stats, add support for standard uAPI.
> I'm guessing the register access part. Compile tested only.

Jakub, wanted to let you know that it seems to be working. I'll review
the patches tomorrow/Sunday, as it's already late here. Thanks!

$ ./ethtool -S swp13 --groups eth-phy eth-mac rmon
Standard stats for swp13:
eth-phy-SymbolErrorDuringCarrier: 0
eth-mac-FramesTransmittedOK: 8
eth-mac-FramesReceivedOK: 8
eth-mac-FrameCheckSequenceErrors: 0
eth-mac-AlignmentErrors: 0
eth-mac-OctetsTransmittedOK: 928
eth-mac-OctetsReceivedOK: 848
eth-mac-MulticastFramesXmittedOK: 8
eth-mac-BroadcastFramesXmittedOK: 0
eth-mac-MulticastFramesReceivedOK: 8
eth-mac-BroadcastFramesReceivedOK: 0
eth-mac-InRangeLengthErrors: 0
eth-mac-OutOfRangeLengthField: 0
eth-mac-FrameTooLongErrors: 0
rmon-etherStatsUndersizePkts: 0
rmon-etherStatsOversizePkts: 0
rmon-etherStatsFragments: 0
rmon-rx-etherStatsPkts64Octets: 0
rmon-rx-etherStatsPkts65to127Octets: 6
rmon-rx-etherStatsPkts128to255Octets: 2
rmon-rx-etherStatsPkts256to511Octets: 0
rmon-rx-etherStatsPkts512to1023Octets: 0
rmon-rx-etherStatsPkts1024to1518Octets: 0
rmon-rx-etherStatsPkts1519to2047Octets: 0
rmon-rx-etherStatsPkts2048to4095Octets: 0
rmon-rx-etherStatsPkts4096to8191Octets: 0
rmon-rx-etherStatsPkts8192to10239Octets: 0
