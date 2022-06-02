Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12E753BE40
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiFBSzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiFBSzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:55:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3236F1C2D51
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 11:55:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7DD921F899;
        Thu,  2 Jun 2022 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654196107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DxHrRg7t3xOKlI+CEXy3BMAQtu3mumRitlDpL7YteTo=;
        b=FEBk8T89UF5uCuQ6K5HM7aNN1OVWecTqby/s5KzWZjXg+g9VzKXdZTXju+ZWuFeKsRJMHZ
        UDDy9XqWWjQkqVhvKKHb6P1t4N77svpX7JwJbbYlVZAy67dwNPTJbcZLJ8Wjc1SsL+o57V
        YdMl1FuIVqfK0kPkb1dMTeVyH4x1gds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654196107;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DxHrRg7t3xOKlI+CEXy3BMAQtu3mumRitlDpL7YteTo=;
        b=OfSK9KtMd+dYRduw/XtHF6bykQdeGFOYKBcP9h6489hZrD81Csb+8fOZWpEop7qbaaTTOG
        vhcMdKevzuRkkrBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7270C2C141;
        Thu,  2 Jun 2022 18:55:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B851B60406; Thu,  2 Jun 2022 20:55:04 +0200 (CEST)
Date:   Thu, 2 Jun 2022 20:55:04 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>
Subject: Re: [PATCH ethtool] ethtool: fec: Change the prompt string to adapt
 to current situations
Message-ID: <20220602185504.xk4uzvyk5h4wavqp@lion.mk-sys.cz>
References: <20220602053626.62512-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wpmzt2clfby4ge5u"
Content-Disposition: inline
In-Reply-To: <20220602053626.62512-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wpmzt2clfby4ge5u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2022 at 07:36:26AM +0200, Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
>=20
> Majority upstream drivers uses `Configured FEC encodings` to report
> supported modes. At which point it is better to change the text in
> ethtool user space that changes the meaning of the field, which is
> better to suit for the current situations.
>=20
> So changing `Configured FEC encodings` to `Supported/Configured FEC
> encodings` to adapt to both implementations.
>=20
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>=20
> This patch resulted from a discussion on netdev regarding
> updating the behaviour of the NFP driver. It was concluded in
> that thread that it would be better to update the ethtool documentation
> to reflect current implementations of the feature.
>=20
> Ref: [PATCH net] nfp: correct the output of `ethtool --show-fec <intf>`
>      https://lore.kernel.org/netdev/20220530084842.21258-1-simon.horman@c=
origine.com/
> ---
>  ethtool.c     | 2 +-
>  netlink/fec.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 277253090245..8654f70de03b 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5567,7 +5567,7 @@ static int do_gfec(struct cmd_context *ctx)
>  	}
> =20
>  	fprintf(stdout, "FEC parameters for %s:\n", ctx->devname);
> -	fprintf(stdout, "Configured FEC encodings:");
> +	fprintf(stdout, "Supported/Configured FEC encodings:");

I'm OK with this part, even if I would prefer if we could unify what the
drivers present.

>  	dump_fec(feccmd.fec);
>  	fprintf(stdout, "\n");
> =20
> diff --git a/netlink/fec.c b/netlink/fec.c
> index f2659199c157..1762ae349ca6 100644
> --- a/netlink/fec.c
> +++ b/netlink/fec.c
> @@ -153,7 +153,7 @@ int fec_reply_cb(const struct nlmsghdr *nlhdr, void *=
data)
>  	print_string(PRINT_ANY, "ifname", "FEC parameters for %s:\n",
>  		     nlctx->devname);
> =20
> -	open_json_array("config", "Configured FEC encodings:");
> +	open_json_array("support/config", "Supported/Configured FEC encodings:"=
);

AFAICS this would result in backword incompatible change of the JSON
output structure which is something we should avoid if we want people to
use JSON for scripting rather than the human readable text output.

Michal

>  	fa =3D tb[ETHTOOL_A_FEC_AUTO] && mnl_attr_get_u8(tb[ETHTOOL_A_FEC_AUTO]=
);
>  	if (fa)
>  		print_string(PRINT_ANY, NULL, " %s", "Auto");
> --=20
> 2.30.2
>=20

--wpmzt2clfby4ge5u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKZB4IACgkQ538sG/LR
dpUxuwf7BawdyPn1br10o5SUAUwaetUFiIUp92i50MsiEmvZY3hkuYWAttLUS5KU
Kg2W5R6T8CPSZBNrFN68C03DVC/U7V4L26DFO0Ur5CsOYBpnLPTvQJ2+aRbdSKkX
VpcU0h5cLPLFs6i/l71Le2JonIy0jWgvSg1GahSlDY4xbhUGC9XgolAy8Onql9x+
eAdosz/JK/1sw2DyDcJSA54gsFZIZq9hAsOtrBA2c7EZxJpMycAisyL9cfFapne1
sjQXzEVIousHX67iy2aydOrK6SMhhpTtZFUAiBwOkcITxvaAuTOhFC2tABH+chx8
nncUwWsUHWXNvHj8AD2tcf0Rm+ZctQ==
=KBw5
-----END PGP SIGNATURE-----

--wpmzt2clfby4ge5u--
