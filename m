Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4E55EFF2B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiI2VQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiI2VQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:16:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107508E4E3;
        Thu, 29 Sep 2022 14:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5672B82682;
        Thu, 29 Sep 2022 21:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D162FC433C1;
        Thu, 29 Sep 2022 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664486180;
        bh=ROjd3Cmeo8ZgMm8i4nPA+VFwqUo6Wd2vWUiUg1YWtWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTYJL6ZNLzPZbcribVbMsH8Mj5lqOSfGzV3ykZB2oQuAHwjk7YaAaDNq/MrgETF1+
         w/ZIyf63fxqSBKlxqQHVse6RjQpFwO0wYbxDkcxxpCTrzcJy0F0KMcXLBQBAhOyOeE
         BRbUTbLn3v+8dzBYvhtuwRPLEuLLm/ZT03NUN9MsEc0HismYg19LiCdAoazShM7fpX
         XwkaDf91KCOO9QjpJzje/WQg4XPGHG4tSJLvaoVyHu82NeoHSFvejoGjmyWCzavsgQ
         r4Eh+ur3iplHfGYxJL+4J4wyGIzEB5NLK0STCrxzxUGFWsYAZ9o/rnPItI4eNNEBil
         efN9UBoZvng5Q==
Date:   Thu, 29 Sep 2022 23:16:16 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, nathan@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] net: netfilter: move bpf_ct_set_nat_info kfunc
 in nf_nat_bpf.c
Message-ID: <YzYLIL/XIzUiHVUE@lore-desk>
References: <ddd17d808fe25917893eb035b20146479810124c.1664111646.git.lorenzo@kernel.org>
 <6cf2c440-79a6-24ce-c9bb-1f1f92af4a0b@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cP9+8kBhea7b/WMn"
Content-Disposition: inline
In-Reply-To: <6cf2c440-79a6-24ce-c9bb-1f1f92af4a0b@linux.dev>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cP9+8kBhea7b/WMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 9/25/22 6:26 AM, Lorenzo Bianconi wrote:
> > Remove circular dependency between nf_nat module and nf_conntrack one
> > moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
> >=20
> > Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc hel=
per")
> > Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   include/net/netfilter/nf_conntrack_bpf.h |  5 ++
> >   include/net/netfilter/nf_nat.h           | 14 +++++
> >   net/netfilter/Makefile                   |  6 ++
> >   net/netfilter/nf_conntrack_bpf.c         | 49 ---------------
> >   net/netfilter/nf_nat_bpf.c               | 79 ++++++++++++++++++++++++
> >   net/netfilter/nf_nat_core.c              |  2 +-
> >   6 files changed, 105 insertions(+), 50 deletions(-)
> >   create mode 100644 net/netfilter/nf_nat_bpf.c
> >=20
> > diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/net=
filter/nf_conntrack_bpf.h
> > index c8b80add1142..1ce46e406062 100644
> > --- a/include/net/netfilter/nf_conntrack_bpf.h
> > +++ b/include/net/netfilter/nf_conntrack_bpf.h
> > @@ -4,6 +4,11 @@
> >   #define _NF_CONNTRACK_BPF_H
> >   #include <linux/kconfig.h>
> > +#include <net/netfilter/nf_conntrack.h>
> > +
> > +struct nf_conn___init {
> > +	struct nf_conn ct;
> > +};
> >   #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_=
BTF)) || \
> >       (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_B=
TF_MODULES))
> > diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_=
nat.h
> > index e9eb01e99d2f..cd084059a953 100644
> > --- a/include/net/netfilter/nf_nat.h
> > +++ b/include/net/netfilter/nf_nat.h
> > @@ -68,6 +68,20 @@ static inline bool nf_nat_oif_changed(unsigned int h=
ooknum,
> >   #endif
> >   }
> > +#if (IS_BUILTIN(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) |=
| \
> > +    (IS_MODULE(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODU=
LES))
> > +
> > +extern int register_nf_nat_bpf(void);
> > +
> > +#else
> > +
> > +static inline int register_nf_nat_bpf(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +#endif
> > +
>=20
> This looks similar to the ones in nf_conntrack_bpf.h.  Does it belong the=
re
> better?  No strong opinion here.

I have no strong opinion too. I will move it in nf_conntrack_bpf.h as
requested by Pablo.

Regards,
Lorenzo

>=20
> The change looks good to me.  Can someone from the netfilter team ack this
> piece also?
>=20

--cP9+8kBhea7b/WMn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYzYLIAAKCRA6cBh0uS2t
rI+gAP4jQUzyq68Jt64Pt/QjX2dwL3fDkGfC5AtQBtsDP/JWFAD+LgxoJF/pADCV
bLV8VFK2bCm2bvK4nf2ZcDzRZf0H/wk=
=wgAc
-----END PGP SIGNATURE-----

--cP9+8kBhea7b/WMn--
