Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5921E6B2612
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCIOAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjCIOAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:00:04 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA663F2C2C;
        Thu,  9 Mar 2023 05:57:46 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 97C1F85D9D;
        Thu,  9 Mar 2023 14:57:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678370265;
        bh=IIMy00Ky4xp4+QCxuvzVq69EvAYijO3Bk+ry+Rh2Bpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZLU6L3cC7SoBXTNhNplQw1b973ft8yJNDScMAlw8ulNWDjFDyzdBcJLSzuFJ2nE1w
         Kk+QRYB9q752yHpWOSyxRhKB1BaoIJZuF+OcSn6keykSCxBGdI1GmM+gUFAFmh6rwH
         qiUXPhNX08G+Fv8OaDaYJJcZhascCZNkMNpPlxSGVyouDKhKP1qk5bRHI+swFFMAyO
         E9fiswzQ0AAvOMBTaRBM5Y00N5zZjZ6XJOyWNl8YutGKj/CDRLsFTxROkSxhqzzvAd
         mEnoaSn8VXwIDh1F7LWINVoXura/T9VVV3ZkvMc3z7FpzV4RMLc5v2Jb+Fzf5MuIiy
         j9btLLYFyF5Ng==
Date:   Thu, 9 Mar 2023 14:57:43 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] dsa: marvell: Add helper function to validate the
 max_frame_size variable
Message-ID: <20230309145743.48caafec@wsk>
In-Reply-To: <20230309135227.cmn5j3tundeugyzd@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-6-lukma@denx.de>
        <ZAndSR4L1QvOFta6@shell.armlinux.org.uk>
        <ZAnefI4vCZSIPkEK@shell.armlinux.org.uk>
        <20230309144752.5e62e037@wsk>
        <20230309135227.cmn5j3tundeugyzd@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1s53T+t7kl2/Y69l+BA56cz";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1s53T+t7kl2/Y69l+BA56cz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Thu, Mar 09, 2023 at 02:47:52PM +0100, Lukasz Majewski wrote:
> > Ok, I will reorder those patches and submit v6.
> >=20
> > Do you have any other comments regarding this patch set? =20
>=20
> Please allow for at least 24 hours between reposts. I would like to
> look at this patch set too, later today or tomorrow.

Ok. No problem.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/1s53T+t7kl2/Y69l+BA56cz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQJ5dcACgkQAR8vZIA0
zr1UWQgA4G25Vom+4ffMW7XidW8kBeBlYppPillW5YNNe8kZCp2tgALehwOanDR7
vTmzOuoVThjkGpZom/PveC+c/ml4cN2Z3cGjZ3LDFlA1sHo28eQyjdTXfMWI1XoI
qdjYkpOUiH48VfLse5w7R8n1RTIQeFOaonjPAZVxAZnAfS6cGO4Xkuk8zd36KLPE
4xBi1bxNUdcIGKoik8LKOAJ5po1Q6OM0Typm5esmo8E4MY1AiBrvgsEkYX7WZ+BP
F6GmuR+QXX9PFBkEPB2d6888I6W5VUF8/XqtHfOmvNmyKZ8KdftBPyjtyAb5Uitb
YHc1wnEMPWbVK+wmtokapfGke7G2uA==
=bFta
-----END PGP SIGNATURE-----

--Sig_/1s53T+t7kl2/Y69l+BA56cz--
