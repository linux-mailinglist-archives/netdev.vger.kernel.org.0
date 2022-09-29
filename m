Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD01E5EFF2F
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiI2VQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiI2VQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F2D1C6A6F;
        Thu, 29 Sep 2022 14:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 891F3B8267F;
        Thu, 29 Sep 2022 21:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4007C433D7;
        Thu, 29 Sep 2022 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664486199;
        bh=GcuqMUS9NVNUzu0FIsCbbFvVJvXHP9GPGBq15bzlttU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RPgjSZUbeZzRkl7x5eJJulKFMhI/B41enBlK1SM1DrqFG7OsB0kajn3YinuXRw4I4
         AsBhcYwm2y/9jg6PAZfotcSHNKEvQpNHDMIYzDTByOymJLbbT+T2jGFLkf16pOCCpL
         pm5WE9XdpgJnFBw4JLuyi0p6EM8JrFmUjSLDYJVrfJdWjnmWoWMoO+R0sMyWJA4hpd
         mmUH4Pa2520r/yrJajbP5+OD/Lj3DYqxMkenMHs75i005t1Z05KKLcOkImG1U6afVw
         FDn6+TSBenfXhRJ/ssuHtFW1dwGdreXZKG0KaCmnaIYs9akCErsGtm0fyWr1MZWNZm
         LdLARHnhzhNUg==
Date:   Thu, 29 Sep 2022 23:16:35 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, nathan@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] net: netfilter: move bpf_ct_set_nat_info kfunc
 in nf_nat_bpf.c
Message-ID: <YzYLM7i1Id4uvRmX@lore-desk>
References: <ddd17d808fe25917893eb035b20146479810124c.1664111646.git.lorenzo@kernel.org>
 <6cf2c440-79a6-24ce-c9bb-1f1f92af4a0b@linux.dev>
 <YzXwCggIANDo9Gyu@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="R2PVonCrJXBYLLJt"
Content-Disposition: inline
In-Reply-To: <YzXwCggIANDo9Gyu@salvia>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--R2PVonCrJXBYLLJt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sep 29, Pablo Neira Ayuso wrote:
> On Thu, Sep 29, 2022 at 12:13:45PM -0700, Martin KaFai Lau wrote:
> > On 9/25/22 6:26 AM, Lorenzo Bianconi wrote:
> > > Remove circular dependency between nf_nat module and nf_conntrack one
> > > moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
> > >=20
> > > Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc h=
elper")
> > > Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >   include/net/netfilter/nf_conntrack_bpf.h |  5 ++
> > >   include/net/netfilter/nf_nat.h           | 14 +++++
> > >   net/netfilter/Makefile                   |  6 ++
> > >   net/netfilter/nf_conntrack_bpf.c         | 49 ---------------
> > >   net/netfilter/nf_nat_bpf.c               | 79 +++++++++++++++++++++=
+++
> > >   net/netfilter/nf_nat_core.c              |  2 +-
> > >   6 files changed, 105 insertions(+), 50 deletions(-)
> > >   create mode 100644 net/netfilter/nf_nat_bpf.c
> > >=20
> > > diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/n=
etfilter/nf_conntrack_bpf.h
> > > index c8b80add1142..1ce46e406062 100644
> > > --- a/include/net/netfilter/nf_conntrack_bpf.h
> > > +++ b/include/net/netfilter/nf_conntrack_bpf.h
> > > @@ -4,6 +4,11 @@
> > >   #define _NF_CONNTRACK_BPF_H
> > >   #include <linux/kconfig.h>
> > > +#include <net/netfilter/nf_conntrack.h>
> > > +
> > > +struct nf_conn___init {
> > > +	struct nf_conn ct;
> > > +};
> > >   #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INF=
O_BTF)) || \
> > >       (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO=
_BTF_MODULES))
> > > diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/n=
f_nat.h
> > > index e9eb01e99d2f..cd084059a953 100644
> > > --- a/include/net/netfilter/nf_nat.h
> > > +++ b/include/net/netfilter/nf_nat.h
> > > @@ -68,6 +68,20 @@ static inline bool nf_nat_oif_changed(unsigned int=
 hooknum,
> > >   #endif
> > >   }
> > > +#if (IS_BUILTIN(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF))=
 || \
> > > +    (IS_MODULE(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MO=
DULES))
> > > +
> > > +extern int register_nf_nat_bpf(void);
> > > +
> > > +#else
> > > +
> > > +static inline int register_nf_nat_bpf(void)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +#endif
> > > +
> >=20
> > This looks similar to the ones in nf_conntrack_bpf.h.  Does it belong t=
here
> > better?  No strong opinion here.
> >=20
> > The change looks good to me.  Can someone from the netfilter team ack t=
his
> > piece also?
>=20
> Could you move this into nf_conntrack_bpf.h ?

ack, I will fix it in v2.

Regards,
Lorenzo


--R2PVonCrJXBYLLJt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYzYLMwAKCRA6cBh0uS2t
rF7BAQCLfn7jOS73Ln0dNouKHpc/GWuyklxxmF84ZHumZTYb+gD+K3M3F12Af/w7
/hN+v8HijMcYYwh1gY07kE5B1dsQeAM=
=4rb2
-----END PGP SIGNATURE-----

--R2PVonCrJXBYLLJt--
