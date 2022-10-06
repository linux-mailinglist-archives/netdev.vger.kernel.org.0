Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB185F6A7B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiJFPX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiJFPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:23:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44847B517B
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:23:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 038931F388;
        Thu,  6 Oct 2022 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665069836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ST5Kiq+SqHkpPWjGPlTIfAjgg0MQoEAvr4Jr54FjKzM=;
        b=r0Rgun1akD7W0TgGVsQs/ceeGZMvVlB+bviVE36KZbvZOdsluny81yRoKko/WEXJJMWsjx
        xeCTprRtbS0NGwvOSiA+pVtiEtPca8PiesyqM7eC/Egs0x7y7eheUJ3MS35XZD61L7mDlT
        rGOGlqI8RhIRCzcHMo8vFC48DS1Du+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665069836;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ST5Kiq+SqHkpPWjGPlTIfAjgg0MQoEAvr4Jr54FjKzM=;
        b=aRAoRG3TEf3Z+lFvObwgLFhIUfguepBp+Vc2+qazWfAGmTBcE2Zrxquqwxbn89zNQFt7RC
        iBPwRoPqr0LAazDg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E5EC22C171;
        Thu,  6 Oct 2022 15:23:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D037C6093B; Thu,  6 Oct 2022 17:23:51 +0200 (CEST)
Date:   Thu, 6 Oct 2022 17:23:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Mathew McBride <matt@traverse.com.au>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/2] ethtool: remove restriction on ioctl
 commands having JSON output
Message-ID: <20221006152351.uvlmkpgue5btx55x@lion.mk-sys.cz>
References: <20220704054114.22582-1-matt@traverse.com.au>
 <20220704054114.22582-3-matt@traverse.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vnyoidhfmsodcwww"
Content-Disposition: inline
In-Reply-To: <20220704054114.22582-3-matt@traverse.com.au>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vnyoidhfmsodcwww
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2022 at 05:41:14AM +0000, Mathew McBride wrote:
> The module-info/dump eeprom (-m/--module-info) is one such command
> which is now able to produce JSON.
>=20
> Signed-off-by: Mathew McBride <matt@traverse.com.au>

I'm sorry for the delay, this came while I was on vacation so I needed
to think a bit more about JSON output in ioctl path, then it somehow
fell through the cracks.

> ---
>  ethtool.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 83bbde8..ece4ac0 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -6409,9 +6409,6 @@ int main(int argc, char **argp)
>  	ctx.argp =3D argp;
>  	netlink_run_handler(&ctx, args[k].nlchk, args[k].nlfunc, !args[k].func);
> =20
> -	if (ctx.json) /* no IOCTL command supports JSON output */
> -		exit_bad_args();
> -
>  	ret =3D ioctl_init(&ctx, args[k].no_dev);
>  	if (ret)
>  		return ret;

I don't think this is a good idea. This way you effectively revert
commit 9a935085ec1c ("ethtool: return error if command does not support
--json") in ioctl path so that --json will be silently ignored there for
all commands which do not support JSON output, i.e. for all except one.

One way around would be adding an extra flag to mark commands supporting
JSON output in ioctl path but IMHO it's not likely that there are going
to be many more. It would be probably easier keep the check as is.

Michal

--vnyoidhfmsodcwww
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmM+8vwACgkQ538sG/LR
dpWQqQgAi99rkIno1gO8DLM9ZJueI3uyBpUtGvYaTD9s7+lJAFvKQWhE4sMF3LLX
GBXQbhT+eB4sCcPHaK+X3HzXHcYg3VsvWzS6wBWckhKy0Je8KK+huFeDwHr7MakG
x1z3F0IRnPikOJXfG85VkdhdHNcypg1YKRxYCp4ZJRqY4UhMhcTCmfgtQYtFrJw3
lRWJ9c2zDcfqOxv274kZT4zzBOF3Hq7bkkLCPbXcL8GMG1xtFwyoiZU057DTR5J+
Drg+BXJzVvXyeXT6XXlzC40aZ/59IkIipQ98rf4XnIsJ1a/2U+peJNIxnc7Po/Xw
tkqOY0KqbdNruaW87XZut4Yi7JTooQ==
=IrZC
-----END PGP SIGNATURE-----

--vnyoidhfmsodcwww--
