Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B2D11837E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLJJ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:26:20 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48751 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbfLJJ0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:26:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CCFB223B0;
        Tue, 10 Dec 2019 04:26:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 04:26:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UpIfAZ
        KRcbKYbufTL7/2AiFUocJSkjbtDhYDWWuxcPQ=; b=ajFeX6+XE5Fh8B9ulFg+jZ
        a+LHdE+3TMTRHek0yFKlhK5Y+yMqdWv/XLjyDqgV+t/1E9brE7tCrGbD8M4G2UPx
        dHgd1kWXL++rxDn/DYduEs4r8Oq+FjRTxTH484iUv2wA+V7KBaLyaXDiOgnmCPva
        DZ/W/x6hMsgCkVuymifr70TB0rPLIDtijaMKLuaODMSHXoJrR8KgzOvqzUiJPAtT
        rG57i5ECvpT4y8dUoB8RbWE4NpnJ2dIuFkjfaicQxqVulFLstum9uEA+GSDyZJkk
        CzXr4rUbfuWvtRPdpJjHfCbWy+9GZj2o/CHoDIliq2TZ/KwY5wQxbV6nBKCnnJGg
        ==
X-ME-Sender: <xms:umTvXfqNSQJ_quNItJDjU8zrq6hn79h1WcJ-APQkDt7VDwmketIuvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:umTvXREHKm-bCwVr7vSWO8INCimR5BW4MFA0GcxomUCbUEGu6GE_Ag>
    <xmx:umTvXZlQaI3xSL6G_q6MLYITvLMofOjFbbGMfiLoZtxLymP06QF-QA>
    <xmx:umTvXclKqtG9gVzdxCY7modwYg27y_6CitpxI6khhOFEgDoddwKnmQ>
    <xmx:u2TvXRw898CdUwIY6ZJUtQQCDRtlJPdqxYEhlHHNt6sQPtVudmglfQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D68280060;
        Tue, 10 Dec 2019 04:26:18 -0500 (EST)
Date:   Tue, 10 Dec 2019 11:26:16 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] selftests: forwarding: Delete IPv6 address at the end
Message-ID: <20191210092616.GA378338@splinter>
References: <20191209065634.337316-1-idosch@idosch.org>
 <20191209.102050.2106424689422479418.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209.102050.2106424689422479418.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 10:20:50AM -0800, David Miller wrote:
> From: Ido Schimmel <idosch@idosch.org>
> Date: Mon,  9 Dec 2019 08:56:34 +0200
> 
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > When creating the second host in h2_create(), two addresses are assigned
> > to the interface, but only one is deleted. When running the test twice
> > in a row the following error is observed:
> > 
> > $ ./router_bridge_vlan.sh
> > TEST: ping                                                          [ OK ]
> > TEST: ping6                                                         [ OK ]
> > TEST: vlan                                                          [ OK ]
> > $ ./router_bridge_vlan.sh
> > RTNETLINK answers: File exists
> > TEST: ping                                                          [ OK ]
> > TEST: ping6                                                         [ OK ]
> > TEST: vlan                                                          [ OK ]
> > 
> > Fix this by deleting the address during cleanup.
> > 
> > Fixes: 5b1e7f9ebd56 ("selftests: forwarding: Test routed bridge interface")
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> 
> Applied, but wasn't the idea that we run these things in a separate
> network namespace so that we don't pollute the top level config even
> if the script dies mid-way or something?

Dave,

This is not the case for the forwarding tests. We use them to test both
the kernel data path (using veth pairs) and the hardware data path
(using physical loopbacks). Until recently we couldn't move the hardware
ports to a different network namespace, which is why these tests were
not written using namespaces. While using namespaces will avoid such
problems, it will also prolong the time it takes to run these tests,
given the devlink instance needs to be reloaded each time. On a normal
kernel this adds another ~5 seconds to each test. On a debug kernel (one
configuration we test) this adds another ~35 seconds.
