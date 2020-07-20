Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCA4227063
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGTVcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:32:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:41846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgGTVcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 17:32:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CC198B6D0;
        Mon, 20 Jul 2020 21:32:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2F14D6032A; Mon, 20 Jul 2020 23:32:09 +0200 (CEST)
Date:   Mon, 20 Jul 2020 23:32:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andre Guedes <andre.guedes@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] igc: Fix output values case
Message-ID: <20200720213209.hjkoihfh4iyxdmtf@lion.mk-sys.cz>
References: <20200720190038.11193-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hukukmvjfajaxbxo"
Content-Disposition: inline
In-Reply-To: <20200720190038.11193-1-andre.guedes@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hukukmvjfajaxbxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 12:00:38PM -0700, Andre Guedes wrote:
> This patch changes the output values to be lowercase and replaces
> "True"/"False" by "yes"/"no" so the output from the IGC driver is
> consistent with other Intel drivers.
>=20
> Signed-off-by: Andre Guedes <andre.guedes@intel.com>
> ---

Applied, thank you.

Michal

--hukukmvjfajaxbxo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8WDVMACgkQ538sG/LR
dpXB7wf+NIm9zgklFthx9xo+nm3pxusMbbCeyNdIlxz+BGZ77sSYUafnLYzsDkx7
jM7SEz9foW83VsI5S6Ilo72s8FrhSeDFvoKcSOmzQhPZ6WP0Q8DxPiHGk9zadXTz
ovJLny4/SEKDxtzsmAlJmGQSJrOg0G7/BRFA0jaS87lJ1epYHsNr00qOP4cfiS/7
fKEZE1iUxrM0zKDFY9WkZL9yC1NRzumzoNWf8+1WElJUAscA1cSmefsOTWwKMqRg
fQwBsPk0h1cQuur2C/howK25mymZg6fpzoH4VJa9RPId6QJgdnfx/R8QPnoxA+Sp
OgOu3NkvIK4cJU5oRYXwtrIsPIvIgg==
=NDf7
-----END PGP SIGNATURE-----

--hukukmvjfajaxbxo--
