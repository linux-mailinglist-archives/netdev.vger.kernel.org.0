Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428211CCEDB
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 02:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgEKA2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 20:28:32 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38942 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbgEKA2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 20:28:32 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id AAECC299CB;
        Sun, 10 May 2020 20:28:27 -0400 (EDT)
Date:   Mon, 11 May 2020 10:28:34 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Markus Elfring <Markus.Elfring@web.de>
cc:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
In-Reply-To: <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
Message-ID: <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de> <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet> <9d279f21-6172-5318-4e29-061277e82157@web.de> <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
 <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811774-1651048744-1589151508=:8"
Content-ID: <alpine.LNX.2.22.394.2005110858570.8@nippy.intranet>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-1651048744-1589151508=:8
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LNX.2.22.394.2005110858571.8@nippy.intranet>

On Sun, 10 May 2020, Markus Elfring wrote:

> >
> > Do you know when these bugs were introduced?
>=20
> I suggest to take another look at a provided tag =E2=80=9CFixes=E2=80=9D.

If you can't determine when the bug was introduced, how can you criticise=
=20
a patch for the lack of a Fixes tag?

> To which commit would you like to refer to for the proposed adjustment=20
> of the function =E2=80=9Cmac_sonic_platform_probe=E2=80=9D?
>=20

That was my question to you. We seem to be talking past each other.=20
Unforunately I only speak English, so if this misunderstanding is to be=20
resolved, you're going to have to try harder to make yourself understood.

> > Naming goto labels is just painting another bikeshed. Yes, some=20
> > alternatives are preferable but it takes too long to identify them and=
=20
> > finding consensus is unlikely anyway, as it's a matter of taste.
>=20
> Would you find numbered labels unwanted according to a possible=20
> interpretation related to 'GW-BASIC' identifier selection?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/coding-style.rst?id=3De99332e7b4cda6e60f5b5916cf9943a7=
9dbef902#n460
>=20

My preference is unimportant here. Therefore, your question must be=20
rhetorical. I presume that you mean to assert that Christophe's patch=20
breaches the style guide.

However, 'sonic_probe1' is the name of a function. The name of the goto=20
label 'undo_probe1' reflects the name of the function.

This is not some sequence of GW-BASIC labels referred to in the style=20
guide. And neither does the patch add new functions with numbered names.

> Can programming preferences evolve into the direction of =E2=80=9Csay wha=
t the=20
> goto does=E2=80=9D?
>=20

I could agree that macsonic.c has no function resembling "probe1", and=20
that portion of the patch could be improved.

Was that the opinion you were trying to express by way of rhetorical=20
questions? I can't tell.

Is it possible for a reviewer to effectively criticise C by use of=20
English, when his C ability surpasses his English ability?

You needn't answer that question, but please do consider it.

> Regards,
> Markus
>=20
---1463811774-1651048744-1589151508=:8--
