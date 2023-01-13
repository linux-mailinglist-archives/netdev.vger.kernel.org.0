Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136A5669651
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbjAMMCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjAMMB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:01:57 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92CE820C9;
        Fri, 13 Jan 2023 03:53:48 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 69F2485265;
        Fri, 13 Jan 2023 12:53:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673610826;
        bh=RxrDXcJ07buIhbEVcWKHYp0D9nS5B01WBXeK3QVU//Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t1aXcoDKHREWY7AWLw2T2CBaWeYMwRLE1+XFEPPYH3dXOWewbYfw0lEPIg8CyPWwb
         DVguK1k2KuCMB4hNEFMdmKvWJLijG7EyVyFlCkYPtQTAIkvh+idQKJ+ZW/Txlyu83r
         7qzF0jJ8RXGVM+yw6L9a4avymv4zaUoqdTldharmKtM61x1+MhJ4v53zy4M7RmqKz0
         PQHeDPearYer+2TzBMF20/eyqtzqR0EqKjWM0Yn0FFoIVFpdomBbq/3hVlN4hNUhq1
         RJRGDzV5hvzQxs0CekGdz2lmro/971UzVoa7mSIAjd8ANe7tEn2hcgRka5rEfYgDeJ
         nDIysbxPf9Yxg==
Date:   Fri, 13 Jan 2023 12:53:38 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113125338.02d44137@wsk>
In-Reply-To: <20230113111401.hyq7xogfo5tx77e7@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y7gdNlrKkfi2JvQk@lunn.ch>
        <20230113113908.5e92b3a5@wsk>
        <20230113104937.75umsf4avujoxbaq@skbuf>
        <20230113120219.7dc931c1@wsk>
        <20230113111401.hyq7xogfo5tx77e7@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vqs.jyD9W5E=3qeQNzhxo_h";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vqs.jyD9W5E=3qeQNzhxo_h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Fri, Jan 13, 2023 at 12:02:19PM +0100, Lukasz Majewski wrote:
> > Hi Vladimir,
> >  =20
> > > On Fri, Jan 13, 2023 at 11:39:08AM +0100, Lukasz Majewski wrote: =20
> > > > Are there any more comments, or is this patch set eligible for
> > > > pulling into net-next tree?   =20
> > >=20
> > > How about responding to the comment that was already posted
> > > first? =20
> >=20
> > Could you be more specific?
> >=20
> >=20
> > On the beginning (first posted version) the patch included 9 patches
> > (which included work for ADDR4 for some mv88e6020 setup).
> >=20
> > But after the discussion, I've decided to split this patch set to
> > smaller pieces;
> >=20
> > First to add the set_max_frame size with basic definition for
> > mv88e6020 and mv88e6071 and then follow with more complicated
> > changes (for which there is no agreement on how to tackle them).
> >=20
> > For the 'set_max_frame' feature Alexander Dyuck had some comments
> > regarding defensive programming approach, but finally he agreed with
> > Andrew's approach.
> >=20
> > As of now - the v4 has been Acked by Andrew, so it looks like at
> > least this "part" of the work is eligible for upstreaming.
> >=20
> >=20
> > Or there are any more issues about which I've forgotten ? =20
>=20
> Do you agree that for the chip families which neither implement
> port_set_jumbo_size() nor set_max_frame_size(), a max MTU of 1492 will
> be returned, which currently produces warnings at probe time and
> should be fixed first, prior to refactoring the code?
> https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.11377=
55-1-lukma@denx.de/#25149891

Sorry, but I've overlooked your reply.

I will write my comments as a reply to it.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/vqs.jyD9W5E=3qeQNzhxo_h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPBRkIACgkQAR8vZIA0
zr2AXwf/T4uUIY2bpV+qMXldZk8K/BXHzCf1wpH+/GjLC4/sREZevkZ0Ue+RXscQ
NoUvoHxusq3F3XJk23m2Zt/dmvMOf764iQFDGPu+V5H2n2qLTH1ecT9u5F3woiIR
8fg/wHC8xBFUBoWe4/BQWpxGMrdExxi29f/4zG4zxf+7aIUCRSKEwr/msr/muvKS
f+9xk5A2D7JxJqNQBgMzwFdk1wt4uq4R+tNnYvPd32Mqjor56QAtA7Co7RKT8izW
kmkXYMve93T1kCmZKX+3laYGxj779c0JQAVLPsg7K6m5Oqj6IkaPi9B+21ldEk54
bjCHhQJ0YS/Mco1gmpWIn4cNwYrLMQ==
=Fh38
-----END PGP SIGNATURE-----

--Sig_/vqs.jyD9W5E=3qeQNzhxo_h--
