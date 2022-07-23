Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AE257F1C9
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 23:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiGWVnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 17:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGWVny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 17:43:54 -0400
Received: from yangtze.blisses.org (yangtze.blisses.org [144.202.50.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3821140CD
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 14:43:53 -0700 (PDT)
Received: from contoocook.blisses.org (contoocook.blisses.org [68.238.57.52])
        by yangtze.blisses.org (Postfix) with ESMTP id 337E817D7BE;
        Sat, 23 Jul 2022 17:43:51 -0400 (EDT)
Authentication-Results: yangtze.blisses.org;
        dkim=pass (2048-bit key; unprotected) header.d=blisses.org header.i=@blisses.org header.a=rsa-sha256 header.s=default header.b=krvPSCy4;
        dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blisses.org;
        s=default; t=1658612630;
        bh=oZtLEiMMZVXq+uqltJbZKTkI550vd63Jcvm7LCA1HoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=krvPSCy421wj+9GNtRLXRXChOuW0eUl4CXjubt2HODS+VGIKby2Iq3QK4kNB4yHgy
         prnozmxlh7YYfz7apBQ1EOWskIUTKkhilRhNICYo6xOy1754neyPxOdkPDSpbUP6Gl
         4n24FqNaOngwrHwjLHnjf/pTJoCMojAbJdy0CP7vQVfk6VuLojCpuJlsKFoltK76FN
         CkqaLGfCoqpnu85KAu/6ir2c1KcQyzXg6xTptGqss3E0IS/i326R12mTmjEYPMnfF6
         GVyhIRrJ+QZ9SN8LmPuCLQURXWzdLNol4efOK56vJIX5iLmJ9OoBKaoP1oSiW1CmNz
         ybJQ3mTVw8ORA==
Date:   Sat, 23 Jul 2022 17:43:49 -0400
From:   Mason Loring Bliss <mason@blisses.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Subject: Re: Issue with r8169 (using r8168 for now) driving 8111E
Message-ID: <YtxrlS34MHXdm7ME@blisses.org>
References: <YtxI7HedPjWCvuVm@blisses.org>
 <68983671-039d-ce1c-e5c2-33e0d03e6a5f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mmnKKjxe13yjOmWM"
Content-Disposition: inline
In-Reply-To: <68983671-039d-ce1c-e5c2-33e0d03e6a5f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mmnKKjxe13yjOmWM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2022 at 10:48:27PM +0200, Heiner Kallweit wrote:

> The error message indicates an incoming packet CRC error. 4.19 doesn't
> report rx errors per default whilst more recent kernel versions do.

Ah, thank you. That sounds like a complete answer, and not an issue the
driver would be causing. I will go back to the in-kernel driver and focus
on identifying the issue with my upstream connection now.

--=20
Mason Loring Bliss   ((  "In the drowsy dark cave of the mind dreams
mason@blisses.org     ))  build  their nest  with fragments  dropped
http://blisses.org/  ((   from day's caravan." - Rabindranath Tagore

--mmnKKjxe13yjOmWM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEEXtBZz1axB5rEDCEnrJXcHbvJVUFAmLca5MACgkQnrJXcHbv
JVVCKhAAxgPtkT2l7524P0JoaJeLgerqxp1U0Akt2nY1YvSwm8AzIQW+s/gHBavj
q6OwLLWSApzSGtav5d4m0HN1kSO8nUsByEZDDhz+/07Tsy/w6uidTgyEVlFJAwtv
35epmhoqTpWIrdVYWFBxFTAekIP6QwHlIu1RZ55bk77VF4R83zDxcJIIOh+2KBsP
xvasREGTipcaANVpuvciKUonNP0WfbaixNnNiFvQRyZmALuvNRQUshddIlK5x1l4
vs+sP1YGy0i1G/gGJEMgTPbg5CFIcLp2LkRBCfG8i+0oaGbugHDDzjp9Vaq1mnuw
nMCiQr9zuTgDDVuehHSMiT1zSeywQQCtI2TNwZul9oHjE+f3s8re06d2EYcUelz6
8Fb9sTt0USpn5SKIiTMhilPEurjF3KIfCxSz8O0HAwbcs9z1PhMFIwtlYhJeUL91
cOC9VbcR7V6MziRVVDudDJRjFzK1X6QUijo2tKNVAtnqedn/hRinq8SH5C51pOVR
dosoA7KD1UhSJPBI2eRxZdhD6H1gB2ysVU79hezQiilB4lhpJx02HKsuyXSIFQc6
gSD9LHpAB++phMaUAtre6kB0rwsVQxFtPkCt+fUqpSuwXsYq2q68CyRquzFTrDSX
7DzbtIYd593Vf9yaE9HqrkoWBk70cZeAnv9AAWR47DToqmBvt8c=
=2jOt
-----END PGP SIGNATURE-----

--mmnKKjxe13yjOmWM--
