Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A2530E077
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhBCRDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231879AbhBCRDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 12:03:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB3164E93;
        Wed,  3 Feb 2021 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612371755;
        bh=VKlyI8b+fpkfSoN6/xIrc7UXrAP5NPn2KWdsr8h5z7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SltDl5y5XIoww4RrGqq40W77bU45qMMjMnwNv9bTLp5SR68zkH5OlSQG33smAlZxh
         QbMHlhAaM9mF6entY66XsG09qJYcMvfD5VFVggAJcwbhfnVeWWJz7Myqjlbayzg/8v
         WPNS4z+2+LOuD5hPZaExphTDbjldgQW3CbRHONHyxoscIXBj/EMgjXYJh9NEHb45iV
         PLYWiCn0hv/xPWAVp6edgIPfOLsLaocsZGrxJqNGAGVmNfJzveW++3p3hToy0WB6B8
         Q5frdGjYnaVF3x3++hIZiskiRUJGvDayEobnUYFade2Y7pW+5RpDriCdQPb4ksKLEl
         WVo6NBVMlqvgw==
Date:   Wed, 3 Feb 2021 09:02:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Majtyka <alardam@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20210203090232.4a259958@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAAOQfrGqcsn3wu5oxzHYxtE8iK3=gFdTka5HSh5Fe9Hc6HWRWA@mail.gmail.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
        <20201207230755.GB27205@ranger.igk.intel.com>
        <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
        <20201209095454.GA36812@ranger.igk.intel.com>
        <20201209125223.49096d50@carbon>
        <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
        <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
        <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
        <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
        <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com>
        <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
        <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com>
        <87h7mvsr0e.fsf@toke.dk>
        <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
        <87bld2smi9.fsf@toke.dk>
        <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAOQfrGqcsn3wu5oxzHYxtE8iK3=gFdTka5HSh5Fe9Hc6HWRWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 13:50:59 +0100 Marek Majtyka wrote:
> On Tue, Feb 2, 2021 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 02 Feb 2021 13:05:34 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> > > Awesome! And sorry for not replying straight away - I hate it when I
> > > send out something myself and receive no replies, so I suppose I shou=
ld
> > > get better at not doing that myself :)
> > >
> > > As for the inclusion of the XDP_BASE / XDP_LIMITED_BASE sets (which I
> > > just realised I didn't reply to), I am fine with defining XDP_BASE as=
 a
> > > shortcut for TX/ABORTED/PASS/DROP, but think we should skip
> > > XDP_LIMITED_BASE and instead require all new drivers to implement the
> > > full XDP_BASE set straight away. As long as we're talking about
> > > features *implemented* by the driver, at least; i.e., it should still=
 be
> > > possible to *deactivate* XDP_TX if you don't want to use the HW
> > > resources, but I don't think there's much benefit from defining the
> > > LIMITED_BASE set as a shortcut for this mode... =20
> >
> > I still have mixed feelings about these flags. The first step IMO
> > should be adding validation tests. I bet^W pray every vendor has
> > validation tests but since they are not unified we don't know what
> > level of interoperability we're achieving in practice. That doesn't
> > matter for trivial feature like base actions, but we'll inevitably
> > move on to defining more advanced capabilities and the question of
> > "what supporting X actually mean" will come up (3 years later, when
> > we don't remember ourselves). =20
>=20
> I am a bit confused now. Did you mean validation tests of those XDP
> flags, which I am working on or some other validation tests?
> What should these tests verify? Can you please elaborate more on the
> topic, please - just a few sentences how are you see it?

Conformance tests can be written for all features, whether they have=20
an explicit capability in the uAPI or not. But for those that do IMO
the tests should be required.

Let me give you an example. This set adds a bit that says Intel NICs=20
can do XDP_TX and XDP_REDIRECT, yet we both know of the Tx queue
shenanigans. So can i40e do XDP_REDIRECT or can it not?

If we have exhaustive conformance tests we can confidently answer that
question. And the answer may not be "yes" or "no", it may actually be
"we need more options because many implementations fall in between".

I think readable (IOW not written in some insane DSL) tests can also=20
be useful for users who want to check which features their program /
deployment will require.
