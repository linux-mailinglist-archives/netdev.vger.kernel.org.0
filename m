Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDDF307A92
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhA1QUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:20:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45589 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232076AbhA1QU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:20:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 15A7A5C0163;
        Thu, 28 Jan 2021 11:19:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 28 Jan 2021 11:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CP5tVB
        WS/3PkdmQ8ymXnw023w1qBpaOI3AYq/NFx6G4=; b=fZbN/BJXEzhqShYdAGzsD/
        r8TBeVzAZgXIyQmkaDw95jmohYgAzLIecCH8SPZV2XfweLH7Se9xOwwx7QQ4uvTh
        dX7+1Urj8Mb22wcfL0XQylWlvm/3qO/+ONyMT6fI8E+BSScno74Vf+UEPYu+iyPv
        uBb3y40pe6kj9opSSOabVr2NHjgSDRnH8QOFf6goZhcS4DIyWIcfpx/XMUo+u7NI
        LW8qz5jgwGz5x+YjNuOImh1oAU6Bj4aTWHZ5CDQDA22NGhtZu5PE4FseSL6YsQLa
        IoL9luB7wH2WNuAzXJI11A9lBQ9OqoN+dCH3Osp09A0AqLjHBBk4wHCwNuhBluRg
        ==
X-ME-Sender: <xms:GeQSYM7r3-BN7WGyFVMs7FNzk5np5Ks6axoCopd3f_hNioLZNy5wag>
    <xme:GeQSYN6WEDvfvk4WPB80dlvQos2YnpZWT_c1TRYBFMFk9Q3FaHfhS-8hWgDMy6jFX
    DUAY-4CJTruscc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GeQSYLcIpJ22awSWBnXdCSArwuX5a03qkJknXmdnPnRXwIrPNAm5rQ>
    <xmx:GeQSYBKMQ36lpL1I7JCWBxDizg4-lkUsL5fFL6uSHPOe6sXPlPSCJA>
    <xmx:GeQSYAKUdmveXIFoKAFQAmmzcElMK31CmzlPkPPNIt3ePL5x3459fg>
    <xmx:GuQSYFHKhDtT8N8KaXI0Ioe5weQemQARWy6QP4jNTF_ETf1-IshV-Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0D7C24005A;
        Thu, 28 Jan 2021 11:19:36 -0500 (EST)
Date:   Thu, 28 Jan 2021 18:19:33 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210128161933.GA3285394@shredder.lan>
References: <20210125151819.8313-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125151819.8313-1-simon.horman@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 04:18:19PM +0100, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Allow a policer action to enforce a rate-limit based on packets-per-second,
> configurable using a packet-per-second rate and burst parameters. This may
> be used in conjunction with existing byte-per-second rate limiting in the
> same policer action.

Hi Simon,

Any reason to allow metering based on both packets and bytes at the same
action versus adding a mode (packets / bytes) parameter? You can then
chain two policers if you need to rate limit based on both. Something
like:

# tc filter add dev tap1 ingress pref 1 matchall \
	action police rate 1000Mbit burst 128k conform-exceed drop/pipe \
	action police pkts_rate 3000 pkts_burst 1000

I'm asking because the policers in the Spectrum ASIC are built that way
and I also don't remember seeing such a mixed mode online.

> 
> e.g.
> tc filter add dev tap1 parent ffff: u32 match \
>               u32 0 0 police pkts_rate 3000 pkts_burst 1000
> 
> Testing was unable to uncover a performance impact of this change on
> existing features.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> ---
>  include/net/sch_generic.h      | 15 ++++++++++++++
>  include/net/tc_act/tc_police.h |  4 ++++
>  include/uapi/linux/pkt_cls.h   |  2 ++
>  net/sched/act_police.c         | 37 +++++++++++++++++++++++++++++++---
>  net/sched/sch_generic.c        | 32 +++++++++++++++++++++++++++++
>  5 files changed, 87 insertions(+), 3 deletions(-)

The intermediate representation in include/net/flow_offload.h needs to
carry the new configuration so that drivers will be able to veto
unsupported configuration.
