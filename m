Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99183CF170
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 05:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfJHD6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 23:58:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39287 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfJHD6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 23:58:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so23000496qtb.6;
        Mon, 07 Oct 2019 20:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NnpEw+ywvJZXpSWAjbLOxSA4dq8mRh5pItXnVvgA3l4=;
        b=V2IDqiE0T9d511JQSQZkcowC2XRBL+V4+hRschXqKWQ95cRLbm8WSF/2BHP5fmvyw9
         GDIkAh5wjj+mcp8Z156/5K4tFRYjpTI3LNKG08fNueWfZRS4TeSTbKVCszL2Ht8hCEun
         MEyome+VmfpvUNyj2w/QRL6Mt2YjBZNDdL/zlvowdXXG9feCnkdYyMWoZ1qSuRkh5Vp+
         tak1k201xQCHixXeEG/kHkdggMeFwr3e4KJx4RdUm2mWKSNDhI8mzy1YTX81kPP8eIOY
         gbEnDhtCZj8VsveUYBA8TLimA/Fq36PpgSU2c82kuj5sphd82YWypucQUxK/DBDbyVUl
         xeMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NnpEw+ywvJZXpSWAjbLOxSA4dq8mRh5pItXnVvgA3l4=;
        b=lbsaFvZI5YxqTEhNHnRzMGJ67oUwDdjL7+10tklnzrSJnfCyyJOZOpIRyC+62QTVLO
         3ODl5zGNb9Vpn56Rp2ic986ItGoj7lHAvZT7ZQO0Pm5Uo7crAER/6tEEvjS/t461RWEf
         ZGt+1Dd7shj8MEkegch2e/j872wuaSzELf1EqRnTDja6BVogglkJr37kCYr3k+ihdjNg
         5PlboWjnPjwY9WTa+PFT472he+JlRxecmY/wW9rp0pE6DccGHdQHrNt/LTtE40fqLvtc
         Hl97bqGlsGEszrPwR8VaCVfHk7T8LijRhx2xwDzciF6sp9F5zESe8roVSAjwkc+e3aev
         SJ4Q==
X-Gm-Message-State: APjAAAXBmIbPOTecAGN9iSx1yJ/GLeqnS6duk5My1CGhIyPhzonTvaCn
        mclByN/4Nh/5D+o/cy9agiU=
X-Google-Smtp-Source: APXvYqyWL+nwojqL562qUMKTJ29D7lryw+OOnC4v6FJ3I+blfxV5xGyIJd05ajIxTKf3tYCBWBBGYQ==
X-Received: by 2002:ac8:388e:: with SMTP id f14mr34730246qtc.167.1570507123112;
        Mon, 07 Oct 2019 20:58:43 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id n65sm8749744qkb.19.2019.10.07.20.58.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 20:58:42 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0598C21BBA;
        Mon,  7 Oct 2019 23:58:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 07 Oct 2019 23:58:41 -0400
X-ME-Sender: <xms:bwmcXTJnspn-UefsV2CiORveZZ-iblwvwo0UCFlp2GCJmDhqyYtTEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehgtderredtredvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecukfhppedutd
    durdekiedrgeefrddvtdeinecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhm
    vghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekhe
    ehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghm
    vgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:bwmcXS5GR1LACr8GTpI7fK1pTyVUuMSChTEnEIbLP5-rnMvXg3S4Ow>
    <xmx:bwmcXUS1_KfNxtv0k-gixKlhVmHNeU1Tc59z17a2HOq2rkQT_-IUTw>
    <xmx:bwmcXdh7sqDKpQYHPYHQDe7I3RdmNHgPmwv3z6q_gGRV6Re_b-wO3w>
    <xmx:cQmcXawAe7FP52wi5yZrtu3FdKs1U_P7caIUgJsx2i6cG1uPOQC7AdPutr0>
Received: from localhost (unknown [101.86.43.206])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C24680061;
        Mon,  7 Oct 2019 23:58:38 -0400 (EDT)
Date:   Tue, 8 Oct 2019 11:58:34 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Marco Elver <elver@google.com>,
        syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        rcu@vger.kernel.org, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
Message-ID: <20191008035834.GB2609633@tardis>
References: <000000000000604e8905944f211f@google.com>
 <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
 <20191007134304.GA2609633@tardis>
 <20191008001131.GB255532@google.com>
 <20191008021233.GD2689@paulmck-ThinkPad-P72>
 <20191008025056.GA2701514@tardis>
 <20191008033353.GK2689@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20191008033353.GK2689@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2019 at 08:33:53PM -0700, Paul E. McKenney wrote:
[...]
> > ---
> >  kernel/rcu/tree_exp.h | 17 +++++++----------
> >  1 file changed, 7 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
> > index af7e7b9c86af..fb51752ac9a6 100644
> > --- a/kernel/rcu/tree_exp.h
> > +++ b/kernel/rcu/tree_exp.h
> > @@ -372,12 +372,10 @@ static void sync_rcu_exp_select_node_cpus(struct =
work_struct *wp)
> >  	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
> > =20
> >  	/* IPI the remaining CPUs for expedited quiescent state. */
> > -	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {
> > +	for_each_leaf_node_cpu_mask(rnp, cpu, mask_ofl_ipi) {
> >  		unsigned long mask =3D leaf_node_cpu_bit(rnp, cpu);
> >  		struct rcu_data *rdp =3D per_cpu_ptr(&rcu_data, cpu);
> > =20
> > -		if (!(mask_ofl_ipi & mask))
> > -			continue;
> >  retry_ipi:
> >  		if (rcu_dynticks_in_eqs_since(rdp, rdp->exp_dynticks_snap)) {
> >  			mask_ofl_test |=3D mask;
>=20
> This part I have already on -rcu branch "dev".
>=20
> > @@ -389,10 +387,10 @@ static void sync_rcu_exp_select_node_cpus(struct =
work_struct *wp)
> >  		}
> >  		ret =3D smp_call_function_single(cpu, rcu_exp_handler, NULL, 0);
> >  		put_cpu();
> > -		if (!ret) {
> > -			mask_ofl_ipi &=3D ~mask;
> > +		/* the CPU responses the IPI, and it will report QS itself */
> > +		if (!ret)
> >  			continue;
> > -		}
> > +
> >  		/* Failed, raced with CPU hotplug operation. */
> >  		raw_spin_lock_irqsave_rcu_node(rnp, flags);
> >  		if ((rnp->qsmaskinitnext & mask) &&
> > @@ -403,13 +401,12 @@ static void sync_rcu_exp_select_node_cpus(struct =
work_struct *wp)
> >  			schedule_timeout_uninterruptible(1);
> >  			goto retry_ipi;
> >  		}
> > -		/* CPU really is offline, so we can ignore it. */
> > -		if (!(rnp->expmask & mask))
> > -			mask_ofl_ipi &=3D ~mask;
> > +		/* CPU really is offline, and we need its QS. */
> > +		if (rnp->expmask & mask)
> > +			mask_ofl_test |=3D mask;
> >  		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
> >  	}
> >  	/* Report quiescent states for those that went offline. */
> > -	mask_ofl_test |=3D mask_ofl_ipi;
> >  	if (mask_ofl_test)
> >  		rcu_report_exp_cpu_mult(rnp, mask_ofl_test, false);
> >  }
>=20
> Would you be willing to port this optimization on top of current -rcu
> branch "dev" with an suitably modified commit message?
>=20

Sure, will do ;-)

Regards,
Boqun

> 							Thanx, Paul

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAl2cCWYACgkQSXnow7UH
+rhz7Af+Nij364bAg8HkjALb5BhcfB+hJC9AgMEcFVjStzO0s8BnctHvtlQeh0nM
DKIuwC+YwUX4c1uwWWtI4EQlCwseOQJLFaC3QP7sdyqIzziLeUeL4QEhinAONiAA
nlp9qS/qChRQ21B0RsvxFhT/SoWrpCf7x78rVTjpi2lOc7fopFEX52CeGwwioWLL
o7gfkrBtGhSTwkYI9OCJOiOrzmFLxvkSwKqlYuvC8T5IUSV5LQKWEyEo8bCwEAzs
fNZo4Svq/PhE5nIBOzvy2P/Wfc3VK5MAbe977ptBzV1rEpvnZl/6MA0yp18YwuKC
v0op9RMzpBPyNhZeacKMGigiNyq9lA==
=+lHp
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
