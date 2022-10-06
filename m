Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6371D5F6A9B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiJFP3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiJFP3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:29:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC464D5
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:29:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 97E231F388;
        Thu,  6 Oct 2022 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665070187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CfFKAl5irm0Ff+GTnUK9xr9qUO36+95YZAY+a7oJC2c=;
        b=Q1pP9/qSzMsk21dJC+1e2NN6iTww9AQ9f18MhJ4t/4UFtbAbXBHbwTtdAGYbdi5rtXTwlV
        LNpzObQHy9WFBCoOc1So7FyVtw71/uakiS0N5rhXyZG4gdHk0kcRiCIovB0/2JTUhvykdB
        Iz8SJD/jNzUrplxRVOLGZWTZKAThvF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665070187;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CfFKAl5irm0Ff+GTnUK9xr9qUO36+95YZAY+a7oJC2c=;
        b=eJvg6ShoUGiSmcRgYcXoNPOd/lrt1724jEmB65PgKZNMBRAHFh9343TRCX0cQRlACT4FNU
        iR7rXmRj+8nVSMCA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 84BE02C171;
        Thu,  6 Oct 2022 15:29:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5EC4E6093B; Thu,  6 Oct 2022 17:29:47 +0200 (CEST)
Date:   Thu, 6 Oct 2022 17:29:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Mathew McBride <matt@traverse.com.au>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/2] ethtool: add JSON output to --module-info
Message-ID: <20221006152947.fjllbflj32g3pj2c@lion.mk-sys.cz>
References: <20220704054114.22582-1-matt@traverse.com.au>
 <20220704054114.22582-2-matt@traverse.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vb5ajteurr74qofm"
Content-Disposition: inline
In-Reply-To: <20220704054114.22582-2-matt@traverse.com.au>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vb5ajteurr74qofm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2022 at 05:41:13AM +0000, Mathew McBride wrote:
> This provides JSON output support for 'ethtool -m' / --module-info
>=20
> To make presenting the module data as simple as possible,
> both the raw bytes/codes and formatted descriptions are provided
> where available.
>=20
> A sample output (edited and formatted for brevity) is shown below:
> $ ethtool --json -m eth8
> [
> 	{
> 		"identifier": 3,
> 		"identifier_description": "SFP",
> 		"vendor_name": "UBNT",
> 		"vendor_oui": "00:00:00",
> 		"vendor_pn": "UF-MM-10G",
> 		"vendor_sn": "FT17072604079",
> 		"date_code": "170727__",
> 		"extended_identifier": 4,
> 		"extended_identifier_description": "GBIC/SFP defined by 2-wire interfac=
e ID",
> 		"connector": 7,
> 		"connector_description": "LC",
> 		"transceiver_codes": [
> 			16,
> 			0,
> 			0,
> 			0,
> 			64,
> 			64,
> 			12,
> 			85,
> 			0
> 		],
> 		"transceiver_types": [
> 			"10G Ethernet: 10G Base-SR"
> 		],
> 		"encoding": 6,
> 		"encoding_description": "64B/66B",
> 		"bitrate_nominal": 10300,
> 		"rate_identifier": 0,
> 		"rate_identifier_description": "unspecified",
> 		"laser_wavelength": 850,
> 		"vendor_rev": "",
> 		"option_byte1": 0,
> 		"option_byte2": 26,
> 		"option_descriptions": [
> 			"RX_LOS implemented",
> 			"TX_FAULT implemented",
> 			"TX_DISABLE implemented"
> 		],
> 		"br_margin_max": 0,
> 		"br_margin_min": 0,
> 		"optical_diagnostics_supported": true,
> 		"bias_current": 11.516,
> 		"tx_power": 0.4872,
> 		"module_temp": 47.1719,
> 		"module_voltage": 3.2784
> 	}
> ]
>=20
> Signed-off-by: Mathew McBride <matt@traverse.com.au>

IIUC this patch implements the JSON output only for some modules, in
particular those handled by sff8079_show_all_nl(). Similar to my
comment on patch 2/2, I believe it's wrong to show JSON output for some
modules and silently fall back to plain text for others. Unless you can
provide JSON output for all modules, the command should fail when --json
is used but JSON output is unavailable.

Michal

--vb5ajteurr74qofm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmM+9GYACgkQ538sG/LR
dpUZUggAx+YYJB6fP17q8RJiHoA3dKuZa82QLWu+Gs2RQlpTrA5cMzvkO96agfd5
9ivYZjVnhe9zP1i482sX9SRs7g8VvH649mbO54icpAGKFAqVeyk5lmEfsSENiwd6
k3xIGF6yLf6/RUmNPwZFA1W3Kk5rd335dq0bmx4QZoeSNRa0E7Z3zljFBKGawm+Q
douhjlYJcKDJv4dGXqn5LOuIfdaUUDD/cTEDWPMau4Gbovip8Yw0sw7lXGD8RQB6
OGqoPTz6UuNG+JKP+bVJKtIHn9rf6z3iH0e5IYPRGbFwD/ss2uJZMl11b4CxcZvE
4QAoqROg+PCW22ZdBI1iv9EoIdqHiQ==
=WXcp
-----END PGP SIGNATURE-----

--vb5ajteurr74qofm--
