Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2B824EBDB
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHWGqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 02:46:03 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:55312 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgHWGqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 02:46:02 -0400
X-Greylist: delayed 3366 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2020 02:46:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1598165160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dn1Ee1BWUkEe6R3beVJmm/p+qmzJ7mU5y+FkCrsO+Ow=;
        b=b5DHL4BhdJhm6eCsYhIKlDJZWgLVMphwp06+GOWpT12bMvTcH6r9xv0x7IyjZimHbtmBtX
        WrK4ELkgf5iLve8qWWrp5odUcuKf0iOiTtusG4T0lfgw/MGjX2TDYsebRE1LJkBW4NBhRM
        8c+PDWifO+OJafz2z3lE92L66OpFe+U=
From:   Sven Eckelmann <sven@narfation.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Simon Wunderlich <sw@simonwunderlich.de>,
        b.a.t.m.a.n@lists.open-mesh.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/8] net: batman-adv: delete duplicated words + other fixes
Date:   Sun, 23 Aug 2020 08:45:53 +0200
Message-ID: <3515346.etltgSPTIo@sven-edge>
In-Reply-To: <37b82a77-fc58-9a7b-8996-a6bd030ee7ef@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org> <1676363.I2AznyWB51@sven-edge> <37b82a77-fc58-9a7b-8996-a6bd030ee7ef@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4310618.EFodLd8k5E"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4310618.EFodLd8k5E
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, 23 August 2020 08:05:10 CEST Randy Dunlap wrote:
[...]
> > Please rebase to only contain the changes not yet in 
> > https://git.open-mesh.org/linux-merge.git/shortlog/refs/heads/batadv/net-next
[...]
> Is this git tree included in linux-next?

No, Stephen Rothwell isn't including the batadv/net + batadv/net-next branches 
of this tree [1] directly - only the netdev trees are included. And the batadv 
specific branches were not yet submitted for inclusion after net-next reopened [2]
after -rc1.

Kind regards,
	Sven

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS?id=c3d8f220d01220a5b253e422be407d068dc65511#n3135
[2] https://lore.kernel.org/netdev/20200818.002258.232165702420264020.davem@davemloft.net/T/#u

--nextPart4310618.EFodLd8k5E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl9CEKEACgkQXYcKB8Em
e0YLbxAApJz8wPlivbQR+Z9ArTfALZMyYK1we+BId3vMFGjjsc8FytGzRSCIOEEi
xzZnFb/LHN8aLJo1rAHV19WfIA6weHNZXxykhaRIcRaM5r7DpaoiSVqozaw0KurG
kIIZrY9Kc12o73ayuH8XdAb7Oiq1yQRKs3CkLc5xJ2NaEPz7rgJo2vMjFwlLspEN
rSqsILFfGNIrXIMCymDAetpHEsmmfJH51GAg29Y7S9Y+ZwToU9IzxwUGW3toPoJf
N6bo9L4f/mfEZJxSH9Mps5RILriQaubYorlemArixAspuhQeqzOXEog7OLDblDfO
axsruCudqNT3K/5Ni5QV0a+l5FOyZ91IVzt6zosxtamQ5aTaogEo5HBAZOHt1d/B
f78En0E+CpWWOgzcNSrtKDKdrPfTOyTRAxT2guhFyuWFlRemEJUhlxCr5IXZYPnU
yk8J7aoyuEWNUjB4Q6Qqstg9wXdzSRdB4MlLAHAqMnoT3QZQyoXJ3WdQkmdx4L5J
ka0k86mEE+XGStdH3Tisv7uihT4g/INi+OzhR+rXZj0VEWPlXl7frcqezAPLuWyg
fO0IR2zz6PzaChaysix3HxVHjgSwIt/nsGOxg18QlN8BKCbGSOZwjHt0bTt5p1wm
0VR6PVpDDt7jJELBv/gs7hH2ZbYRQHNTIdH+JCylPiBuUtJzcaM=
=nNIY
-----END PGP SIGNATURE-----

--nextPart4310618.EFodLd8k5E--



