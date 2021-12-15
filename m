Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497644750FF
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 03:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhLOCgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 21:36:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhLOCgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 21:36:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE548B81C53
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9B4C34600;
        Wed, 15 Dec 2021 02:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639535803;
        bh=/epVu5H4CSAwixhWo+9ItdFGGJX0u5o/v9bf9ozfMrY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CDRcOYHjtZjXeLzpp11AT+I5CylbxQgvUGpILEzSY58YWiFWcO6SneKqNFXh5QTzk
         OAsMGm4d56QpNfPsGuae/MJcn0dsvsP/ukmrjNjARtQrMTAVDK7b4/h0n1GfADPbjB
         yW2gPLqyNTuYpEdpn34vNhtsoX5aLGL5JguOiebe8QDvIqI0OWQdIofIMvogEb+JT/
         sCV7UWKHknAOvmw9hM2VKnGskiKaHtE6cmBP9QKIhjhmteag/ePmTjBP3dXD9uCGGm
         Pm7YIdIXNPTagRRJglw1KmInicMyIvD3WVMkJvXh00FmKRZuKDY522onNfXDDwn2cp
         h7szQx12KGegw==
Date:   Tue, 14 Dec 2021 18:36:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, alsi@bang-olufsen.dk,
        =?UTF-8?B?QXLEsW7DpyA=?= =?UTF-8?B?w5xOQUw=?= 
        <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: rtl8365mb: add GMII as user port
 mode
Message-ID: <20211214183642.14abdab1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211214190705.12581-1-luizluca@gmail.com>
References: <20211214190705.12581-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 16:07:05 -0300 luizluca@gmail.com wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>=20
> Recent net-next fails to initialize ports with:
>=20
>  realtek-smi switch: phy mode gmii is unsupported on port 0
>  realtek-smi switch lan5 (uninitialized): validation of gmii with
>  support 0000000,00000000,000062ef and advertisement
>  0000000,00000000,000062ef failed: -22
>  realtek-smi switch lan5 (uninitialized): failed to connect to PHY:
>  -EINVAL
>  realtek-smi switch lan5 (uninitialized): error -22 setting up PHY
>  for tree 1, switch 0, port 0
>=20
> Current net branch(3dd7d40b43663f58d11ee7a3d3798813b26a48f1) is not
> affected.
>=20
> I also noticed the same issue before with older versions but using
> a MDIO interface driver, not realtek-smi.
>=20
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Please use get_maintainer.pl to find appropriate reviewers, and repost
with them CCed.
