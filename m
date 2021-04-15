Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF6F360A5E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhDONUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 09:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDONU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 09:20:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7D8C061574;
        Thu, 15 Apr 2021 06:20:06 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618492804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=onhykUzXf+/EwFP50ypOXEHOWfV85WogyE7TB/1hxLM=;
        b=fvZSnk4FDhR0rUQNCp7zWEexOgxoM6fVTb9ZNTt5vDGlOCuznffQoguS38pGzczCXY2aWe
        GZJ71VPqw+QxMhMtP2jmJDceMMVwewWMfs9lfmtusBuV1VXQOrhGWLqqn3ZPYpfMAwZ0D9
        igpD0ywki7qTftlrQkXBbIf6Z4fGIB0bcAxZSGZpkMyPa3gn6bK5Ew98fg7J5bkmY7l49u
        fAL74nA914v8mpMXhevKVc4UWaxdSWc5tW6sLhMw/to3Sv/lANv9vR9LrH3g6kjXUggwZF
        fPkSo4h+a7XyepEISpt6Eqrf8Iqg1Ks5TqXNZrmtGhlAHd+pLUyNEIyYWj/Niw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618492804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=onhykUzXf+/EwFP50ypOXEHOWfV85WogyE7TB/1hxLM=;
        b=SBf11oFUfY83MZ9Xqsy6ctSb7TGOnnDiPFQ5O70bBSUih03DjMnMwazqNb5e9RWtKE/xyq
        oXjvaJOPUwefoeCg==
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net] igb: Fix XDP with PTP enabled
In-Reply-To: <20210415145011.6734d3fb@carbon>
References: <20210415092145.27322-1-kurt@linutronix.de> <20210415140438.60221f21@carbon> <874kg7hhej.fsf@kurt> <20210415145011.6734d3fb@carbon>
Date:   Thu, 15 Apr 2021 15:20:02 +0200
Message-ID: <87v98nfzwd.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Apr 15 2021, Jesper Dangaard Brouer wrote:
> I have a project involving i225+igc (using TSN).  And someone suggested
> that I also looked at i210 for TSN.  I've ordered hardware that have
> i210 on motherboard (and I will insert my i225 card) so I have a system
> with both chips for experimenting with TSN.  I guess, I would have
> discovered this eventually when I got the hardware.  Thanks for saving
> me from this mistake. Thanks!

Well, both cards are interesting for TSN. However, the i225 has some
advanced features in contrast to the i210. For instance, it supports
time aware scheduling (IEEE 802.1Qbv) in hardware through the Linux
TAPRIO interface.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB4PYIACgkQeSpbgcuY
8Kb++w//cWfxRdKbXgvTOAikLaw1ZzNE1Jmpt+ztax4zcmZX8Qe07WuCarmTqNWS
qZqiKEsnLvxBsZo46qQEYBofELI5TdwmkUXODmHvOFEHng/SvN4dZd0JXqI1EriY
LY37FBl00xqDUrSrt+9AgjswEnxWxueOyH/xvONxjSjNXP8sh1jk6YbRi77+ZzMA
ggVBGyCyckmhqAG7KCC+htOM+OWvChz0VOCpWRGy6LSCjQSU10b5LnCOCT2749BP
sm+QdZwcxU+vCSdzAQF6WounBgCZono2STziYzoJxOKYk2as5i94hM14DpRaTSaz
vHyyp/nVwVa3Cq1mbF1/C9Rd3XGm5h3LlbSgXe60c+jPxhQb76vvBhYTseb3ZXuR
vnH4R0RwpFshbc4PnUthyTRtM1iYOdppySsBlXCrN1EWiR9tV/8yTwou9WGP07ko
r/gM3jPolQ0bMxe+Kvhi/D+82FABC069mlAeqxks/KUCEfSJvVrRwTSom+qadKfj
ilh7IgOb5EBXwKGWAuEcmn+TqphtLy+AB7T79dbANYzmV1f6aaqyZbsMK/xYvENS
lJ6Wjyhc2jWBAjcVi8gG+PWzSMuUckdwBBIu4v7f59ZDlIcAmIdMcNCeNqdJ9YVQ
f7YgKXk1CFM9WAJzQBky9vFPL02wBhysw3fPW3vZxRMNz/syfyc=
=KPkY
-----END PGP SIGNATURE-----
--=-=-=--
