Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C0466BE7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349144AbhLBWEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:04:38 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47678 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243287AbhLBWEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:04:37 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3E492218A8;
        Thu,  2 Dec 2021 22:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638482474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJ41qSFY8Qkwt3MoV9ljeGyWcEsXreDZOYw+KJ41B4A=;
        b=vNwNlxUq7FYsVBcHbMYk7gYCuIZ0g1ihw+m2nGJpCZHXazrZxsWe6xYVo0JXmytIPVGFui
        RvUZWuRhSprKF0c2sy2btKXUEfJiDFq0WhuKIhondZ8/QxI5E3igF/UdWUQwCbwnesLuT0
        hWMEKQ8QqcYKNH0tcehUdQoTqVFym3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638482474;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJ41qSFY8Qkwt3MoV9ljeGyWcEsXreDZOYw+KJ41B4A=;
        b=/ax6b6wFm4lnXQ76QJr22cjAMxEEqAPJWa+LS1AgNqVAbVK5YJ8oSc5NsVDkwDzAs3JYSY
        KqMkABmD9WMXzAAw==
Received: from lion.mk-sys.cz (unknown [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2C8EEA3B83;
        Thu,  2 Dec 2021 22:01:14 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 080B9607CC; Thu,  2 Dec 2021 23:01:14 +0100 (CET)
Date:   Thu, 2 Dec 2021 23:01:14 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 0/8] ethtool: Add support for CMIS
 diagnostic information
Message-ID: <20211202220114.n6vzttsvrujhbe2h@lion.mk-sys.cz>
References: <20211123174102.3242294-1-idosch@idosch.org>
 <20211202214518.rwhrmzwhdmzs3kue@lion.mk-sys.cz>
 <YalAO4PwKrJaFAZ4@shredder>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bgip6c3vizw4mzj3"
Content-Disposition: inline
In-Reply-To: <YalAO4PwKrJaFAZ4@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bgip6c3vizw4mzj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 02, 2021 at 11:52:59PM +0200, Ido Schimmel wrote:
> On Thu, Dec 02, 2021 at 10:45:18PM +0100, Michal Kubecek wrote:
> > The series looks good to me and I'm ready to merge it but as it is
> > marked "ethtool-next", I better make sure: is it OK to merge it into
> > master branch (targeting ethtool 5.16)? In other words, do I see
> > correctly that it does not depend on any features that would be missing
> > in 5.16 kernel?
>=20
> Yes

Thank you. The series is merged into master branch now.

Michal

--bgip6c3vizw4mzj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmGpQiQACgkQ538sG/LR
dpVtfgf/QzB0GOl2x7Jv1/hzVuWLtWXMDTc/luHBxn0OqEYcih3eYgcK4Jk+RFW6
qQ+6pnLMEAlw9r49KSZR56l38Ob7sgAkYxyYmQFJLHFFKKElF+oh/cssx9NMFjqR
mbrb1A2BWvX5eVw0SO0isMSP0pggXa2nOu+U+7964Hb9WWtvsA+G0L+lCDbV693c
XW4tWNC8vu6dEESwn08iDyP9ln0O/prHwlC9Ofa1VIGR9RYLXsRfpkLWIiJ33cOB
dUv+zJ7L8ledyiBPj6ZdspfT1mDhEZHjew+7yqlm4T5F7C2b6Irk6MhEkdpNMhus
ZHOJls8uLZrBNU/jzzX4gvX1xNgz8g==
=iR0Z
-----END PGP SIGNATURE-----

--bgip6c3vizw4mzj3--
