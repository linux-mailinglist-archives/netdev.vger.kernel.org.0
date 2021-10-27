Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4450543D2D4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhJ0UdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:33:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57910 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbhJ0UdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:33:12 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B615121709;
        Wed, 27 Oct 2021 20:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635366645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8PMHUUUWpe6WppkcsifDtO53RongY41spr2obiLuo/g=;
        b=jK+Ihdf69LZ2NuyzR08vS6DNp2hqsMaP4b6phk3gReALpk2V7sxAAWkSDeu5U5hSLTJ3Jv
        knTg2MG2icaONnsoXtwYwErnmTfickkEWTjeJrma74a/jQzUTa3ZprgZd4Nxl8tNr4a/rR
        47zPa6IIqLwBKTylXmncXE7WkP83FyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635366645;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8PMHUUUWpe6WppkcsifDtO53RongY41spr2obiLuo/g=;
        b=LqVD6W5RHvAhJfy1ah+5dtBjsJqqM//PwMCDiRLFKXCw3j1x2BSg39WqxqL5kZi8TIWwzc
        GKOMp0KsGCywO1Cg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A8911A3B83;
        Wed, 27 Oct 2021 20:30:45 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 89A3F607F2; Wed, 27 Oct 2021 22:30:45 +0200 (CEST)
Date:   Wed, 27 Oct 2021 22:30:45 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 00/14] ethtool: Use memory maps for EEPROM
 parsing
Message-ID: <20211027203045.sfauzpf3rarx5iro@lion.mk-sys.cz>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="26xzbmvb4zr6lgti"
Content-Disposition: inline
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--26xzbmvb4zr6lgti
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 12, 2021 at 04:25:11PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
>=20
> This patchset prepares ethtool(8) for retrieval and parsing of optional
> and banked module EEPROM pages, such as the ones present in CMIS. This
> is done by better integration of the recent 'MODULE_EEPROM_GET' netlink
> interface into ethtool(8).

I still need to take a closer look at some of the patches but just to be
sure: the only reason to leave this series for 5.16 cycle is that it's
rather big and intrusive change (i.e. it does not depend on any kernel
functionality not present in 5.15), right?

Michal


--26xzbmvb4zr6lgti
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmF5tu8ACgkQ538sG/LR
dpWMLAf/WicWiWcDiJfPckzxvaXSFKlAgQL+Lc7vfOlmyiuZPPqn0luN1DgFfmFa
+2KiU7fEixWrg5rovVaottclYZeHNDWIk5wBoHutAjiFtaRSbinS7TmJoVxa3YZX
GIXX5y2kh74p6DejO28egFnB03GqCrOdm6fjH+DBRgOC6CmIutaRAHBIpUQS7IbU
/MsJFmbENdnl0zpJe+wdrQKiX0lSmns0u5YaDAHelJydVap5QosCGDcvI/F/JKLP
o1BDuWbYF9jw6G72anonCOV6yxhZcUeAK/kW0PJbHT+jGuhkLdjAS77Zf1UDOl8N
bd3h8it7WJjCFDsHujVpF++ofNsrGQ==
=iyan
-----END PGP SIGNATURE-----

--26xzbmvb4zr6lgti--
