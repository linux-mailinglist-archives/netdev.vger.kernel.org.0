Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4A3DCC29
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 16:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhHAOw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 10:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhHAOw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 10:52:58 -0400
X-Greylist: delayed 2262 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 01 Aug 2021 07:52:50 PDT
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF9DC0613D3;
        Sun,  1 Aug 2021 07:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yr6az4JgcIM2+aNkieXBV9BlHhQ5SbdI3Ya971RKAnc=; b=NKx9WZgqp2uL3xlSK4JXof2ovw
        PUhSDmzTOfd1kzBdmsadqUzzSY0Y+Vxeo3TLBC1yXCwSli2U0aSOiEt6kzVncBsxZeWPryT1HGRNv
        xOR1A8FXIDEAkPCDcyIn4WPbQNWizgw65dbYkVXvhzB7danXy8H0+G6o6zFqW5Mk+oKM6Tme0DKWF
        T1/xgsebs+8605HiQ7Kav7aGxIRWAyuMuBpfXZR5d3kdzThslSzY1zZRS3m66tsaKbXqj6iO4bf8b
        bKpXj2zMpWv7/nJsLLAht5rrIqPz4+lIMMCpbGtot3LkQz+MovLxB8CauxAgIFw7EjLOpEOF60faU
        VoJuGQNQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mACEl-0002Cq-QE; Sun, 01 Aug 2021 15:14:43 +0100
Date:   Sun, 1 Aug 2021 15:14:42 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQasUsvJpML6CAsy@azazel.net>
References: <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="AWbsvAEVGD93+SnW"
Content-Disposition: inline
In-Reply-To: <YQREpVNFRUKtBliI@C02XR1NRJGH8>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--AWbsvAEVGD93+SnW
Content-Type: multipart/mixed; boundary="Nup6VDFSQFJD8bea"
Content-Disposition: inline


--Nup6VDFSQFJD8bea
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-07-30, at 13:27:49 -0500, Kyle Bowman wrote:
> On Wed, Jul 28, 2021 at 03:43:47AM +0200, Phil Sutter wrote:
> > You might want to check iptables commit ccf154d7420c0 ("xtables:
> > Don't use native nftables comments") for reference, it does the
> > opposite of what you want to do.
>
> I went ahead and looked through this commit and also found found the
> code that initially added this functionality; commit d64ef34a9961
> ("iptables-compat: use nft built-in comments support ").
>
> Additionally I found some other commits that moved code to nft native
> implementations of the xtables counterpart so that proved helpful.
>
> After a couple days of research I did end up figuring out what to do
> and have added a (mostly complete) native nft log support in
> iptables-nft. It all seems to work without any kernel changes
> required. The only problem I'm now faced with is that since we want to
> take the string passed into the iptables-nft command and add it to the
> nftnl expression (`NFTNL_EXPR_LOG_PREFIX`) I'm not entirely sure where
> to get the original sized string from aside from `argv` in the `struct
> iptables_command_state`. I would get it from the `struct
> xt_nflog_info`, but that's going to store the truncated version and we
> would like to be able to store 128 characters of the string as opposed
> to 64.
>
> Any recommendations about how I might do this safely?

The xtables_target struct has a `udata` member which I think would be
suitable.  libxt_RATEEST does something similar.  I've attached a patch
which should apply cleanly on top of yours.

Here's an example:

  $ sudo /usr/local/sbin/iptables-nft -A INPUT -j NFLOG --nflog-prefix '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef|0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF|'
  $ sudo /usr/local/sbin/iptables-nft -L INPUT
  # Warning: iptables-legacy tables present, use iptables-legacy to see them
  Chain INPUT (policy ACCEPT)
  target     prot opt source               destination
  NFLOG      all  --  anywhere             anywhere             nflog-prefix  0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcde
  $ sudo nft list ruleset
  table ip filter {
          chain INPUT {
                  type filter hook input priority filter; policy accept;
                  counter packets 113 bytes 8894 log prefix "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef|0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCD"
          }
  }

J.

> From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
> From: Kbowman <kbowman@cloudflare.com>
> Date: Thu, 29 Jul 2021 15:12:28 -0500
> Subject: [PATCH] iptables-nft: use nft built-in logging instead of xt_NFLOG
>
> Replaces the use of xt_NFLOG with the nft built-in log statement.
>
> This additionally adds support for using longer log prefixes of 128
> characters in size. A caveat to this is that the string will be
> truncated when the rule is printed via iptables-nft but will remain
> untruncated in nftables.
>
> Some changes have also been made to nft_is_expr_compatible() since
> xt_NFLOG does not support log level or log flags. With the new changes
> this means that when a log is used and sets either
> NFTNL_EXPR_LOG_LEVEL or NFTNL_LOG_FLAGS to a value aside from their
> default (log level defaults to 4, log flags will not be set) this will
> produce a compatibility error.
> ---
>  iptables/nft-shared.c | 45 +++++++++++++++++++++++++++++++++++++++++++
>  iptables/nft.c        | 38 ++++++++++++++++++++++++++++++++++++
>  iptables/nft.h        |  1 +
>  3 files changed, 84 insertions(+)

One note about formatting: you've used four spaces for indentation, but
Netfilter uses tabs.

> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 4253b081..b5259db0 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -22,6 +22,7 @@
>
>  #include <linux/netfilter/xt_comment.h>
>  #include <linux/netfilter/xt_limit.h>
> +#include <linux/netfilter/xt_NFLOG.h>
>
>  #include <libmnl/libmnl.h>
>  #include <libnftnl/rule.h>
> @@ -595,6 +596,48 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>  		ctx->h->ops->parse_match(match, ctx->cs);
>  }
>
> +static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
> +{
> +    __u16 group =  nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP);
> +    __u16 qthreshold = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD);
> +    __u32 snaplen = nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
> +    const char *prefix = nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX);
> +    struct xtables_target *target;
> +    struct xt_entry_target *t;
> +    size_t target_size;
> +
> +    void *data = ctx->cs;
> +
> +    target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
> +    if (target == NULL)
> +        return;
> +
> +    target_size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
> +
> +    t = xtables_calloc(1, target_size);
> +    t->u.target_size = target_size;
> +    strcpy(t->u.user.name, target->name);
> +    t->u.user.revision = target->revision;
> +
> +    target->t = t;
> +
> +    struct xt_nflog_info *info = xtables_malloc(sizeof(struct xt_nflog_info));
> +    info->group = group;
> +    info->len = snaplen;
> +    info->threshold = qthreshold;
> +
> +    /* Here, because we allow 128 characters in nftables but only 64
> +     * characters in xtables (in xt_nflog_info specifically), we may
> +     * end up truncating the string when parsing it.
> +     */
> +    strncpy(info->prefix, prefix, sizeof(info->prefix));
> +    info->prefix[sizeof(info->prefix) - 1] = '\0';
> +
> +    memcpy(&target->t->data, info, target->size);
> +
> +    ctx->h->ops->parse_target(target, data);
> +}
> +
>  static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
>  			     struct nftnl_expr *e)
>  {
> @@ -644,6 +687,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
>  			nft_parse_limit(&ctx, expr);
>  		else if (strcmp(name, "lookup") == 0)
>  			nft_parse_lookup(&ctx, h, expr);
> +		else if (strcmp(name, "log") == 0)
> +		    nft_parse_log(&ctx, expr);
>
>  		expr = nftnl_expr_iter_next(iter);
>  	}
> diff --git a/iptables/nft.c b/iptables/nft.c
> index f1deb82f..dce8fe0b 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -39,6 +39,7 @@
>  #include <linux/netfilter/nf_tables_compat.h>
>
>  #include <linux/netfilter/xt_limit.h>
> +#include <linux/netfilter/xt_NFLOG.h>
>
>  #include <libmnl/libmnl.h>
>  #include <libnftnl/gen.h>
> @@ -1340,6 +1341,8 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
>  		       ret = add_verdict(r, NF_DROP);
>  	       else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
>  		       ret = add_verdict(r, NFT_RETURN);
> +	       else if (strcmp(cs->jumpto, "NFLOG") == 0)
> +	           ret = add_log(r, cs);
>  	       else
>  		       ret = add_target(r, cs->target->t);
>         } else if (strlen(cs->jumpto) > 0) {
> @@ -1352,6 +1355,36 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
>         return ret;
>  }
>
> +int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
> +{
> +    struct nftnl_expr *expr;
> +    struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;
> +
> +    expr = nftnl_expr_alloc("log");
> +    if (!expr)
> +        return -ENOMEM;
> +
> +    if (info->prefix != NULL) {
> +        //char prefix[NF_LOG_PREFIXLEN] = {};
> +
> +        // get prefix here from somewhere...
> +        // maybe in cs->argv?
> +        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at the end is 12 then this string is truncated 123");
> +    }
> +    if (info->group) {
> +        nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
> +        if (info->flags & XT_NFLOG_F_COPY_LEN)
> +            nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
> +                               info->len);
> +        if (info->threshold)
> +            nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_QTHRESHOLD,
> +                               info->threshold);
> +    }
> +
> +    nftnl_rule_add_expr(r, expr);
> +    return 0;
> +}
> +
>  static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
>  {
>  #ifdef NLDEBUG
> @@ -3487,6 +3520,11 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
>  	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_FLAGS) == 0)
>  		return 0;
>
> +	if (!strcmp(name, "log") &&
> +	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LOG_LEVEL) == 4 &&
> +	    !nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_FLAGS))
> +	    return 0;
> +
>  	return -1;
>  }
>
> diff --git a/iptables/nft.h b/iptables/nft.h
> index 4ac7e009..28dc81b7 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -193,6 +193,7 @@ int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match
>  int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
>  int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
>  int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
> +int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
>  char *get_comment(const void *data, uint32_t data_len);
>
>  enum nft_rule_print {
> --
> 2.32.0

--Nup6VDFSQFJD8bea
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-extensions-libxt_NFLOG-use-udata-to-store-longer-pre.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 7bc91dbe4f3cc9f88fbb73137e9be9d1dba89deb Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 1 Aug 2021 14:47:52 +0100
Subject: [PATCH] extensions: libxt_NFLOG: use udata to store longer prefixes
 suitable for the nft log statement.

NFLOG truncates the log-prefix to 64 characters which is the limit
supported by iptables-legacy.  We now store the longer 128-character
prefix in struct xtables_target's udata member for use by iptables-nft.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.c | 6 ++++++
 iptables/nft.c           | 6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 02a1b4aa35a3..9057230d7ee7 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -5,6 +5,7 @@
 #include <getopt.h>
 #include <xtables.h>
=20
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
=20
@@ -53,12 +54,16 @@ static void NFLOG_init(struct xt_entry_target *t)
=20
 static void NFLOG_parse(struct xt_option_call *cb)
 {
+	char *nf_log_prefix =3D cb->udata;
+
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_PREFIX:
 		if (strchr(cb->arg, '\n') !=3D NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
+
+		snprintf(nf_log_prefix, NF_LOG_PREFIXLEN, "%s", cb->arg);
 		break;
 	}
 }
@@ -149,6 +154,7 @@ static struct xtables_target nflog_target =3D {
 	.save		=3D NFLOG_save,
 	.x6_options	=3D NFLOG_opts,
 	.xlate		=3D NFLOG_xlate,
+	.udata_size     =3D NF_LOG_PREFIXLEN
 };
=20
 void _init(void)
diff --git a/iptables/nft.c b/iptables/nft.c
index dce8fe0b4a18..13cbf0a8b87b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1365,11 +1365,7 @@ int add_log(struct nftnl_rule *r, struct iptables_co=
mmand_state *cs)
         return -ENOMEM;
=20
     if (info->prefix !=3D NULL) {
-        //char prefix[NF_LOG_PREFIXLEN] =3D {};
-
-        // get prefix here from somewhere...
-        // maybe in cs->argv?
-        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at =
the end is 12 then this string is truncated 123");
+        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, cs->target->udata);
     }
     if (info->group) {
         nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
--=20
2.30.2


--Nup6VDFSQFJD8bea--

--AWbsvAEVGD93+SnW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEGrEsACgkQKYasCr3x
BA3F7hAAlQRkgChCQ3TksfH7gw5bgZtSkWE7roQd0Mi6efye0bDQ4GhEkV9paMDS
FgnhATFD0rfo+5syuN+sOzF12x5lKhHNJbzMbMugV0+qKO4CMKNpGslcWeqjyqnN
iCBw1TB3nplq/EksrxTJ+cjDDLp+31XesYAUdsPqg3lBL0oFPwSg4z3+K88PhcX+
NqN8FNXy+UYb+76pmxJZ9vmIM9EH1mU2y6+wevadaV9W9dkIxTwXS4Rl4Pe+XsXK
LbqOFe8CFDdurVMh43R1lPAdbUsi5l5mblb3D+6k+Vu+Xcua7CFO01xTHiraTZAS
OqZG2PtSx+2iS7LVPZjMF+QdtTpTWruc1xV2lvk/bvhJnhUbJGT7JvtrdqyQQcvr
qKB4bYotgxs5O77MoOJve/2cQ50xB1hJVOMa4I6VCHGVuTilnl6rt+mxNuQ1UzRo
/fDoMsloxJP6oqVrn7iWJtVEJh1JLaZSP12fDCVo9MDmSF7vUat7wTrLFOUUMdaH
6HeEBwFKfn5HL6iu5IbH2Z9DeSOZ2EoKUEH/1aGokc/bpKMVySAJZSBcFRrGY/Sp
NRHlzINpJLxIJCFE/I+rmWWnl2DIV4jkRt6W80Dpkl6cqcXCX2liPP7i4jkSOvHd
nOY2CEcwJ1nBlcrYptfqAi8zDXAjnEmer7mM6ur2KFT0WCqTcFw=
=d0xl
-----END PGP SIGNATURE-----

--AWbsvAEVGD93+SnW--
