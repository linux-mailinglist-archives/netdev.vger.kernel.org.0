Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F122A28E272
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 16:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgJNOpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 10:45:12 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52517 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgJNOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 10:45:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id A903AF9B;
        Wed, 14 Oct 2020 10:45:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 14 Oct 2020 10:45:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KIRc6v
        qnK+FNAoL+8MdqgFBVvYc4djdjJZSwQ9G55lM=; b=Uoenq9EqXNR0IccwZ05Znu
        +FGy/J5e+Bvnw5mb8P29bVWgkAkWBKoiQu4eQxw2/AIvIF/ZZOq7cpTp8O19nP5D
        DbFOYMPlfmSNBMi5WWZm/HvaCQUr/HpkHbt0o9EedXf1W8Gk/Swi15mKlCOqjEbb
        Jry+Z31h0xP74ZHRw0R4rFPltYVr72BGPQoPsc/CYLipsK/9HkNUdhVvu7oolVBw
        6alQf1zfP8sxz9A+9OiLRNm8uT0Qd4wfMpNWonntVl2EVbEEGlACMWnDkOo7AB6U
        L1jnRKzCnzESx0/Xy+zrjZ7e0BJPbabakE5MhxYgLV5HMJNZ7dto4jX4gxsIOLAQ
        ==
X-ME-Sender: <xms:9g6HX4LZ0ezA6cpADhV9M_PQMHN6qnyp1I3nT5XV4dL_SWbMON_DWw>
    <xme:9g6HX4KEkuaAItACaRq8HRWIA9in5MvHZJGbUbmY0fHTaeHB9ia_I2kNAfY5d5t0T
    xj6QNi_BWrL-qk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedriedugdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrfeejrddugeeknecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9g6HX4uPp6qeRP9DEHX347lUkIOMD9aXvpJckCq4pWHW2eXQacVQgA>
    <xmx:9g6HX1ZsVlejRuPRYiB2lWT7ql5z7daaOtrvY_ZiqEc8C8_ApD7_IQ>
    <xmx:9g6HX_YorYRkOyCekspW8Sparr7jRljf379l1kRcNzcmN1JV5ui5qg>
    <xmx:9g6HXwDzJE6dCjkhxYA2oMoLmiMvW9daNaHzuDin4l9dcheNbiM9ew>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD8E13280067;
        Wed, 14 Oct 2020 10:45:09 -0400 (EDT)
Date:   Wed, 14 Oct 2020 17:45:06 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: vxlan_asymmetric.sh test failed every time
Message-ID: <20201014144506.GA4788@shredder>
References: <20201013043943.GL2531@dhcp-12-153.nay.redhat.com>
 <20201013074930.GA4024934@shredder>
 <20201014013916.GM2531@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014013916.GM2531@dhcp-12-153.nay.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 09:39:16AM +0800, Hangbin Liu wrote:
> Thanks a lot for help debugging this issue, this patch works for me.

Also patched vxlan_symmetric.sh and applied to our tree. Will submit
tomorrow if nothing explodes in regression.

Thanks for reporting and testing.
