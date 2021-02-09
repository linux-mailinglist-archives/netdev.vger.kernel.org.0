Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06E031569C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhBITPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:15:09 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37161 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230520AbhBITIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:08:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C3481789;
        Tue,  9 Feb 2021 14:06:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 09 Feb 2021 14:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=ozTHsC4Eg1frWLg/1b+KfMRzDnkGr5AwxhoETMrlV
        yU=; b=m65a/q5eRtbp23QsnxfFAov15KrdAwSetuQHgW/q2N/06fM1SxB+320E4
        LR00ExBg3eCmSWSbcfwONYQ45FMQk0m25OiGU7WdOq9zfCmDK/PfwFhFbf3oPwKe
        eX0kJAH2Y6OUW20j1SEsIaDtXrj+v1kvp1OCe5ybMxkXNlUOynr/OWCKxRrz/y2V
        tsmRLq+lTi0cv5DdrpTO7q0xRg8ltoQP9jE5Aw6rc/ViOPrHWwycFVb7TtoPY8+P
        2J++d6Wp7OEUnmoOHC0LMqemADGS4ABntoTc9AFWAkAcSmYF8A0REJTFBUCdOzJf
        YpdfH/KPkF1XyucC05ZW+5Gs/Zsag==
X-ME-Sender: <xms:N90iYKN_bMkK9ZIsHJcOEMkc85Feea08SI1ljyBx9OVaX2uDp0uX3w>
    <xme:N90iYI_mGIpsQNxQ-XkKub66MF58tBnxyF-XYnVpKA8rKaqFs9-PrSQbro3nxOgq7
    VsFqxnlY5cw6_k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheehgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepuefgjeefveeivdektdfggefhgeevudegvefgtedugfetveevuedtgffhkefg
    gefgnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:N90iYBT98rAvyHTDxF7MI7YExASYg4MV68tQRGj_ZB3WNgnt44WuFQ>
    <xmx:N90iYKslKZIuuUHR9tybYJyE-ulsSYnYExDiPsUbi3Q5ki6urNJj2Q>
    <xmx:N90iYCdwRHOgLGYLn5gsCnt1NqMiZCSY2MkyvIJuxa4SFcKySxT23g>
    <xmx:N90iYC7dxFc9dIy3K7oar2vDIvHC8iNRCeXt0egpZE2QeRwAxbdeGA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A907A24005C;
        Tue,  9 Feb 2021 14:06:30 -0500 (EST)
Date:   Tue, 9 Feb 2021 21:06:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Mahesh Bandewar
         =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?=
         =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
Message-ID: <20210209190627.GA267182@shredder.lan>
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
 <87czx978x8.fsf@nvidia.com>
 <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 10:49:23AM -0800, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Tue, Feb 9, 2021 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote:
> > > Jian Yang <jianyang.kernel@gmail.com> writes:
> > >
> > > > From: Jian Yang <jianyang@google.com>
> > > >
> > > > Traditionally loopback devices come up with initial state as DOWN for
> > > > any new network-namespace. This would mean that anyone needing this
> > > > device would have to bring this UP by issuing something like 'ip link
> > > > set lo up'. This can be avoided if the initial state is set as UP.
> > >
> > > This will break user scripts, and it fact breaks kernel's very own
> > > selftest. We currently have this internally:
> > >
> > >     diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> > >     index 4c7d33618437..bf8ed24ab3ba 100755
> > >     --- a/tools/testing/selftests/net/fib_nexthops.sh
> > >     +++ b/tools/testing/selftests/net/fib_nexthops.sh
> > >     @@ -121,8 +121,6 @@ create_ns()
> > >       set -e
> > >       ip netns add ${n}
> > >       ip netns set ${n} $((nsid++))
> > >     - ip -netns ${n} addr add 127.0.0.1/8 dev lo
> > >     - ip -netns ${n} link set lo up
> > >
> > >       ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=1
> > >       ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_neigh=1
> > >
> > > This now fails because the ip commands are run within a "set -e" block,
> > > and kernel rejects addition of a duplicate address.
> >
> > Thanks for the report, could you send a revert with this explanation?
> Rather than revert, shouldn't we just fix the self-test in that regard?

I reviewed such a patch internally and asked Petr to report it as a
regression instead. At the time the new behavior was added under a
sysctl, but nobody had examples for behavior that will break, so the
sysctl was removed. Now we have such an example, so the revert / sysctl
are needed.
