Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7650812DA1B
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 17:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfLaQKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 11:10:24 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41146 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbfLaQKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 11:10:24 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so35507249wrw.8
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 08:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pSVzl6FnvnAVr+Wik5Wob1+V4iu+RFzLiuBag7qyOkc=;
        b=PCOTdxkNw3zc1q31J8mx5irA2ODvERZTgxptK0SPYLE90S7DjlDfGn68RiCqcjMCzC
         4oJlsFVCvQxjzkt0giXP9bLlyr4crCVcYDKOaVi52O6iuwVoNa3OVIlB7Y7rZuozvUwd
         3S1GBZE1T8n70N2es4bBoJY9ywehgKe9i5VP9AOuJ+y1weKTzQWmIUDzewuA22QOr0mM
         IgOhUH1KxJ2H0dJ3geysLCtZejOcSnWtB6baMaRLNsTaVCJqMgurPeH7BJM4pPcGBxWk
         nko9tZyu4JYiq9V1SL2GFQTOq7GQKIwUHXRvcHIsQu5upsV56DV/9Y3lf20VvvIq2mjS
         0vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pSVzl6FnvnAVr+Wik5Wob1+V4iu+RFzLiuBag7qyOkc=;
        b=M9XP/AvtWDi6GR81Fx3J90ZZ/w7m5wv40u+BsqySVfcyYJFROeKDQwLuzn1+7xAWy8
         SG/ANqWnGphxTsNQ8hyGZNqF6fgU1QTeF40/YFBnGzNx/oGpnDlAjwIINwyJ1pHjANKg
         Cd6cdbvU7hm7r/CIOv2ANb/1VfdrMYl1I61kEpzL1KCyqqaMzvp475cASyY2bkFIT6QO
         c8/rmtOmZDPd0AbgQJcafWuYaxnn5bYNyKG9QclA4p9mkSjg/hMpVW9Zw0iodYPMx+g4
         ahn4xDvmfhCTz6jyf+CSqHfDorC3jVLOPriZgqtwBqY8CzEGhY1GQOKvhDazmIOAW0Tp
         Zn6A==
X-Gm-Message-State: APjAAAVQgMo0XEmhptzQyOwl2ZSAm+WblFHk2q7cEkJQkSbArhOLRrPx
        SOWc6suvQi5JEHbWw7ko/cQ=
X-Google-Smtp-Source: APXvYqy3G8ppPIQ3fuEIi0rbaOP7R3rqfES3t/SSipS0zG048ICKuJUr9al69LyXYRw2vxwZQh0ZrA==
X-Received: by 2002:adf:8541:: with SMTP id 59mr72192070wrh.307.1577808622580;
        Tue, 31 Dec 2019 08:10:22 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id i10sm50009819wru.16.2019.12.31.08.10.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Dec 2019 08:10:21 -0800 (PST)
Date:   Tue, 31 Dec 2019 17:10:20 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20191231161020.stzil224ziyduepd@pali>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x3gd6wbnle6ehxjt"
Content-Disposition: inline
In-Reply-To: <20191222192235.GK25745@shell.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x3gd6wbnle6ehxjt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sunday 22 December 2019 19:22:35 Russell King - ARM Linux admin wrote:
> Hi,
>=20
> I've been trying to configure DSA for VLANs and not having much success.
> The setup is quite simple:
>=20
> - The main network is untagged
> - The wifi network is a vlan tagged with id $VN running over the main
>   network.
>=20
> I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> setup to provide wifi access to the vlan $VN network, while the switch
> is also part of the main network.

Hello, I do not know if it is related, but I have a problem with DSa,
VLAN and mv88e6085 on Espressobin board (armada-3720).

My setup/topology is similar:

eth0 --> main interface for mv88e6085 switch
wan --> first RJ45 port from eth0
lan0 --> second RJ45 port from eth0
wan.10 --> unpacked VLAN with id 10 packets from wan

Just one note, wan and wan.10 uses different MAC addresses. Also lan0
has another MAC address.

Basically on upstream wan are two different/separated networks. First
one is untagged, second one is tagged with vlan id 10 and tagged packets
should come on wan interface (linux kernel then pass untagged packets to
wan and vlan id 10 tagged as "untagged" to wan.10). lan0 is downstream
network and in this configuration Espressobin works as router. So there
is no switching between RJ45 ports, all packets should come to CPU and
Linux's iptables do all stuff.

And now the problem. All (untagged) traffic for first network on wan
works fine (incoming + outgoing). Also all outgoing packets from wan.10
interface are correctly transmitted (other side see on first RJ45 port
that packets are properly tagged by id 10). But for unknown reason all
incoming packets with vlan id 10 on first RJ45 port are dropped. Even
tcpdump on eth0 does not see them.

Could be this problem related to one which Russel described? I tried to
debug this problem but I give up 2 days before Russel send this email
with patches, so I have not had a chance to test it.

One very strange behavior is that sometimes mv88e6085 starts accepting
those vlan id 10 packets and kernel them properly send to wan.10
interface and userspacee applications see them. And once they start
appearing it works for 5 minutes, exactly 300s. After 300s they are
again silently somehow dropped (tcpdump again does not see them). I was
not able to detect anything which could cause that kernel started seeing
them. Looks for me it was really random. But exact time 300s is really
strange.

I used default Debian Buster kernel (without any custom patches). Also
one from Debian Buster backports, but behavior was still same.

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--x3gd6wbnle6ehxjt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCXgty6gAKCRCL8Mk9A+RD
Ujn7AJ0e7bmhb7RFeU6j51TVJm+Y4AkLkgCfYyxjE3FFqzdiRLY0upR3ZnGwKpU=
=1XvK
-----END PGP SIGNATURE-----

--x3gd6wbnle6ehxjt--
