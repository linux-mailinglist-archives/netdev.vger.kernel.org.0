Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020171CE976
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgELAIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:08:20 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42550 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgELAIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:08:19 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 3995529BDB;
        Mon, 11 May 2020 20:08:16 -0400 (EDT)
Date:   Tue, 12 May 2020 10:08:23 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Markus Elfring <Markus.Elfring@web.de>
cc:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
In-Reply-To: <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de>
Message-ID: <alpine.LNX.2.22.394.2005120905410.8@nippy.intranet>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de> <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet> <9d279f21-6172-5318-4e29-061277e82157@web.de> <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet> <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet> <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811774-1457172623-1589239130=:8"
Content-ID: <alpine.LNX.2.22.394.2005120920320.8@nippy.intranet>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-1457172623-1589239130=:8
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LNX.2.22.394.2005120920321.8@nippy.intranet>


On Mon, 11 May 2020, Markus Elfring wrote:

> > If you can't determine when the bug was introduced,
>=20
> I might be able to determine also this information.
>=20

This is tantamount to an admission of duplicity.

>=20
> > how can you criticise a patch for the lack of a Fixes tag?
>=20
> I dared to point two details out for the discussed patch.
>=20

You deliberately chose those two details. You appear to be oblivious to=20
your own motives.

>=20
> >> To which commit would you like to refer to for the proposed=20
> >> adjustment of the function =E2=80=9Cmac_sonic_platform_probe=E2=80=9D?
> >
> > That was my question to you. We seem to be talking past each other.
>=20
> We come along different views for this patch review. Who is going to add=
=20
> a possible reference for this issue?
>=20

Other opinions are not relevant: I was trying to communicate with you.

>=20
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/Documentation/process/coding-style.rst?id=3De99332e7b4cda6e60f5b5916cf994=
3a79dbef902#n460
>=20
> >
> > My preference is unimportant here.
>=20
> It is also relevant here because you added the tag =E2=80=9CReviewed-by=
=E2=80=9D.=20
> https://lore.kernel.org/patchwork/comment/1433193/=20
> https://lkml.org/lkml/2020/5/8/1827
>=20

You have quoted my words out-of-context and twisted their meaning to suit=
=20
your purposes.

>=20
> > I presume that you mean to assert that Christophe's patch breaches the=
=20
> > style guide.
>=20
> I propose to take such a possibility into account.
>=20

This "possibility" was among the reasons why the patch was posted to a=20
mailing list by its author. That possibility is a given. If you claim this=
=20
possibility as your motivation, you are being foolish or dishonest.

>=20
> > However, 'sonic_probe1' is the name of a function.
>=20
> The discussed source file does not contain such an identifier.=20
> https://elixir.bootlin.com/linux/v5.7-rc5/source/drivers/net/ethernet/nat=
semi/macsonic.c#L486=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/net/ethernet/natsemi/macsonic.c?id=3D2ef96a5bb12be62ef75b5828c0aab83=
8ebb29cb8#n486
>=20

That's what I told you in my previous email. You're welcome.

>=20
> > This is not some sequence of GW-BASIC labels referred to in the style=
=20
> > guide.
>=20
> I recommend to read the current section =E2=80=9C7) Centralized exiting o=
f=20
> functions=E2=80=9D once more.
>=20

Again, you are proposing a bike shed of a different color.

>=20
> >> Can programming preferences evolve into the direction of =E2=80=9Csay =
what=20
> >> the goto does=E2=80=9D?
> >
> > I could agree that macsonic.c has no function resembling "probe1", and=
=20
> > that portion of the patch could be improved.
>=20
> I find this feedback interesting.
>=20
>=20
> > Was that the opinion you were trying to express by way of rhetorical=20
> > questions? I can't tell.
>=20
> Some known factors triggered my suggestion to consider the use of the=20
> label =E2=80=9Cfree_dma=E2=80=9D.
>=20

If you cannot express or convey your "known factors" then they aren't=20
useful.

>=20
> > Is it possible for a reviewer to effectively criticise C by use of=20
> > English, when his C ability surpasses his English ability?
>=20
> We come along possibly usual communication challenges.
>=20

That looks like a machine translation. I can't make sense of it, sorry.

> Regards,
> Markus
>=20

Markus, if you were to write a patch to improve upon coding-style.rst, who=
=20
should review it?

If you are unable to write or review such a patch, how can you hope to=20
adjudicate compliance?
---1463811774-1457172623-1589239130=:8--
