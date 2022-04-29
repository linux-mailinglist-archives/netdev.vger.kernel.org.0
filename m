Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318DF514619
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357130AbiD2KAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 06:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbiD2KAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 06:00:04 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D623F8B5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 02:56:46 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id bv19so14428288ejb.6
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 02:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version;
        bh=lC2aQDO1jDrS95kLb2tVibcrroZGiiyDY0egjLaQEhE=;
        b=2fX326V4gT7wC/I/ulqHmYuRjHFvLcA/ZwkP9IbQkoivC2RP25C9BFcd3x5zPZe6a9
         ZGrwKUBJAym3q4cN6MReU0Z81RUVdQL/v9xQsEK0vREY2DZNCrDg2+9tejJQHLfv3+Fk
         H4jIHpKH2Sz4TZlkPyeJlYwaWcoHrQJcDWyaCh4SdzhdOx/W8sVJIWjc+YQga73O8YDw
         ckFEyCJRKcyRexmBve9/VzkR3cfpIIOBB6qyxhvc3sm3eXCdZ3dK2pbRa0oRK/y38ALc
         DfMuL7oxF727PIIJin+6uxzJ+lOEeWXJ58Pl3GNAFknul4GD9s6/GhD0QkTs5x0Melfl
         e1Cw==
X-Gm-Message-State: AOAM531nkkdKkiZa7toU1AoxfKFb+yc9QyDFuwW2crJnIw9yg2UYknB7
        36n7fKLTKTl+xRkNgczHRYQxTqNU8s0=
X-Google-Smtp-Source: ABdhPJxMMH0h3MN+8YfG5XYIWASgaXbwwv6irQmsbVw5FOtNOHJYQ8bSAPN7+yJxp1IAIWN3sv8htg==
X-Received: by 2002:a17:906:478b:b0:6db:8b6e:d5de with SMTP id cw11-20020a170906478b00b006db8b6ed5demr36380235ejc.161.1651226204490;
        Fri, 29 Apr 2022 02:56:44 -0700 (PDT)
Received: from localhost ([2a01:4b00:f41a:3600:360b:9754:2e3a:c344])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709070b0a00b006f3ef214daasm485085ejl.16.2022.04.29.02.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 02:56:43 -0700 (PDT)
Message-ID: <fac8b95ce32c4b57e7ea00596cbf01aaf966c7ef.camel@debian.org>
Subject: Re: Simplify ambient capability dropping in iproute2:ip tool.
From:   Luca Boccassi <bluca@debian.org>
To:     Tinkerer One <tinkerer@zappem.net>, netdev@vger.kernel.org
Date:   Fri, 29 Apr 2022 10:56:38 +0100
In-Reply-To: <CABCx3R0QbN2anNX5mO1iPGZNgS=wdWr+Rb=bYGwf24o6jxjnaQ@mail.gmail.com>
References: <CABCx3R0QbN2anNX5mO1iPGZNgS=wdWr+Rb=bYGwf24o6jxjnaQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-OBlkst5mfEnR4dm2FbSd"
User-Agent: Evolution 3.38.3-1+plugin 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-OBlkst5mfEnR4dm2FbSd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-04-28 at 20:17 -0700, Tinkerer One wrote:
> Hi,
>=20
> This is expanded from https://github.com/shemminger/iproute2/issues/62
> which I'm told is not the way to report issues and offer fixes to
> iproute2 etc.
>=20
> [I'm not subscribed to the netdev list, so please cc: me if you need more=
 info.]
>=20
> The original change that added the drop_cap() code was:
>=20
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=
=3Dba2fc55b99f8363c80ce36681bc1ec97690b66f5
>=20
> In an attempt to address some user feedback, the code was further
> complicated by:
>=20
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=
=3D9b13cc98f5952f62b825461727c8170d37a4037d
>=20
> Another user issue was asked about here (a couple days ago):
>=20
> https://stackoverflow.com/questions/72015197/allow-non-root-user-of-conta=
iner-to-execute-binaries-that-need-capabilities
>=20
> I looked into what was going on and found that lib/utils.c contains
> some complicated code that seems to be trying to prevent Ambient
> capabilities from being inherited except in specific cases
> (ip/ip.c:main() calls drop_cap() except in the ip vrf exec case.). The
> code clears all capabilities in order to prevent Ambient capabilities
> from being available. The following change achieves suppression of
> Ambient capabilities much more precisely. It also permits ip to not
> need to be setuid-root or executed under sudo since it can now be
> optionally empowered by file capabilities:
>=20
> diff --git a/lib/utils.c b/lib/utils.c
> index 53d31006..681e4aee 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -1555,25 +1555,10 @@ void drop_cap(void)
> =C2=A0#ifdef HAVE_LIBCAP
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* don't harmstring root/=
sudo */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (getuid() !=3D 0 && ge=
teuid() !=3D 0) {
> -               cap_t capabilities;
> -               cap_value_t net_admin =3D CAP_NET_ADMIN;
> -               cap_flag_t inheritable =3D CAP_INHERITABLE;
> -               cap_flag_value_t is_set;
> -
> -               capabilities =3D cap_get_proc();
> -               if (!capabilities)
> -                       exit(EXIT_FAILURE);
> -               if (cap_get_flag(capabilities, net_admin, inheritable,
> -                   &is_set) !=3D 0)
> +               /* prevent any ambient capabilities from being inheritabl=
e */
> +               if (cap_reset_ambient() !=3D 0) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0exi=
t(EXIT_FAILURE);
> -               /* apps with ambient caps can fork and call ip */
> -               if (is_set =3D=3D CAP_CLEAR) {
> -                       if (cap_clear(capabilities) !=3D 0)
> -                               exit(EXIT_FAILURE);
> -                       if (cap_set_proc(capabilities) !=3D 0)
> -                               exit(EXIT_FAILURE);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> -               cap_free(capabilities);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0#endif
> =C2=A0}

The current setup is necessary, as the commit message says:

"Users have reported a regression due to ip now dropping capabilities
unconditionally.
zerotier-one VPN and VirtualBox use ambient capabilities in their
binary and then fork out to ip to set routes and links, and this
does not work anymore.

As a workaround, do not drop caps if CAP_NET_ADMIN (the most common
capability used by ip) is set with the INHERITABLE flag.
Users that want ip vrf exec to work do not need to set INHERITABLE,
which will then only set when the calling program had privileges to
give itself the ambient capability."

Besides, giving setuid to ip itself would be very dangerous, and should
definitely not be supported. I am not aware of any distribution that
does it. If there is any, it should be removed. Even for the vrf exec
case, on Debian/Ubuntu I've set it up so that the caps are not
configured by default, but require admin action at install time to
enable, with a clear warning about the possible risks and tradeoffs.

--=20
Kind regards,
Luca Boccassi

--=-OBlkst5mfEnR4dm2FbSd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAmJrtlYACgkQSylmgFB4
UWLFFQf+JygIN6vLqgUTha6Uozvywmp9UOizGSAq23rJnrAIKPQWa1kxzxOpnPjw
FcUOKF8zfxiCzTc6K/5oYzjh8HNcaRtqGARC5u3T2uJNIf7GqAEMMhQqnCunYtez
eRh+aAs8B+j0s6Iz3V/ClX4jMaQ+u3KXi08PujYS1scupE91VGIGTEFsZY4MLdAr
LEY8RNpw4+QgR0F82ZS8fKkXIeQ2xEr+5Ed/EQkF4pJOPDZQoT2lOwnoK91u8wNx
k8cBc0NgJEFz020cj4Plcxa3qn4bSeQXYvPX4swKHsEnj2REfpdFXM/4/6wGy/UR
SVN/jtK82cRMMqK83fy0HWbtNf2yyg==
=4dnq
-----END PGP SIGNATURE-----

--=-OBlkst5mfEnR4dm2FbSd--
