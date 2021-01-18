Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B32C2FA8FE
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405524AbhARSil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:38:41 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47791 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405569AbhARSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:30:03 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 948D3184D;
        Mon, 18 Jan 2021 13:29:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 Jan 2021 13:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Co/Fyp
        WzxPWa5HbJGkpGwvIvXJcCzicqQuTSYLp7rRs=; b=aOLS20IQ+mvU35IEIds8FU
        J3NZeVCgwz5c4GsHIhIOETqmtbZzxC8x2evGBfWhS9Z4M0TNK72B8RN+fuJH3+jD
        oQ3JeMNNDp0rQe6OgSPGCVGMcB6Nk8tTIGz4VIbIIgCBCSYd6K+7KxASlAz0uNxV
        yhK9uHTBUJ1/yJF/hDq4gw3v5ju+zUBsRJ60LZsHr0Kd7lhE6M8zz5DJ9xlccI5E
        R+aC6BSar1xkcR4ckv2oTWOijnD8oqG4NTCZz0hIWmDeVoSu4whp0wsxLe983Q10
        eI4GnONjGsbNIE8f/XrsOvyrPKyN3B2TMGmZZoLKWz2ayHFXIGpiKnLUimuyyv7w
        ==
X-ME-Sender: <xms:etMFYMY8fRoUJ0ojgSTRVkyiViObY9L5hvKzXJBMwbapnYQN1JzoHg>
    <xme:etMFYI7uFQw2COlZwSH1f5Ki1JuOnQ1HqbHYKAaz1AzPBKKDD36OtUzEqbrdbrY33
    yqNfuLeIxoN8MI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:etMFYHDjpx1w7gRCGMwMblJAMz8BEzhZ0VqFF3CvW2twwiMSTvCEEA>
    <xmx:etMFYGfQDkZDmNXMS-Yuxqr5LdFECt3pLcFqUobvCbWwnzaPQ7Xsbw>
    <xmx:etMFYOKNuOreNTragG4TCKDu_DjBcmYLz7bO4XDfBglpG2tSCwTWRQ>
    <xmx:etMFYMczkU7Acqja-6dVJ7FvdzEPql9ILLrYnmlFndA1h93UpcKnqQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9ED8E240066;
        Mon, 18 Jan 2021 13:29:13 -0500 (EST)
Date:   Mon, 18 Jan 2021 20:29:10 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.org>
Subject: Re: [PATCH net-next 0/3] nexthop: More fine-grained policies for
 netlink message validation
Message-ID: <20210118182910.GA2334694@shredder.lan>
References: <cover.1610978306.git.petrm@nvidia.org>
 <f2ba918f-6781-3740-fe49-756fe4fb40c5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2ba918f-6781-3740-fe49-756fe4fb40c5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 10:43:22AM -0700, David Ahern wrote:
> On 1/18/21 7:05 AM, Petr Machata wrote:
> > From: Petr Machata <petrm@nvidia.org>
> > 
> > There is currently one policy that covers all attributes for next hop
> > object management. Actual validation is then done in code, which makes it
> > unobvious which attributes are acceptable when, and indeed that everything
> > is rejected as necessary.
> > 
> > In this series, split rtm_nh_policy to several policies that cover various
> > aspects of the next hop object configuration, and instead of open-coding
> > the validation, defer to nlmsg_parse(). This should make extending the next
> > hop code simpler as well, which will be relevant in near future for
> > resilient hashing implementation.
> > 
> > This was tested by running tools/testing/selftests/net/fib_nexthops.sh.
> > Additionally iproute2 was tweaked to issue "nexthop list id" as an
> > RTM_GETNEXTHOP dump request, instead of a straight get to test that
> > unexpected attributes are indeed rejected.
> > 
> > In patch #1, convert attribute validation in nh_valid_get_del_req().
> > 
> > In patch #2, convert nh_valid_dump_req().
> > 
> > In patch #3, rtm_nh_policy is cleaned up and renamed to rtm_nh_policy_new,
> > because after the above two patches, that is the only context that it is
> > used in.
> > 
> > Petr Machata (3):
> >   nexthop: Use a dedicated policy for nh_valid_get_del_req()
> >   nexthop: Use a dedicated policy for nh_valid_dump_req()
> >   nexthop: Specialize rtm_nh_policy
> > 
> >  net/ipv4/nexthop.c | 85 +++++++++++++++++-----------------------------
> >  1 file changed, 32 insertions(+), 53 deletions(-)
> > 
> 
> good cleanup. thanks for doing this. Did you run fib_nexthops.sh
> selftests on the change? Seems right, but always good to run that script
> which has functional tests about valid attribute combinations.

"This was tested by running tools/testing/selftests/net/fib_nexthops.sh"
:)
