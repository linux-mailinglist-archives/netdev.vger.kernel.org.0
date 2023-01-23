Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D41B67865F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjAWT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjAWT3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:29:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA46635267;
        Mon, 23 Jan 2023 11:28:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 374AE61028;
        Mon, 23 Jan 2023 19:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D05EC4339B;
        Mon, 23 Jan 2023 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674502136;
        bh=9NZXkPdmw/iB9Zkyv6wXQtlGAjxqyjWERvaxcrJqUrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPXXFP4UpDa/wyVGKxnJhAw75MJAFwnhNF/TMHqQdXN/wKQ/dfUM9cRBvIOMFP+oe
         lcdbBuVkbA5BK8dY3/yK0IflJTdU213skxB5wW8DJmSNsGBY3FBIUrEFXaS4I3/lz7
         dMiXuLgrBeRDdLqpHepeh4+6C0RFXlnQuwz8xsVE2pndVxIsdhmkEOqRCJbdYlc4pm
         /fdTEdVwHltWcZ0RDmn0ZDmHhOsrLXk5X1eWKCwvpHucQ1wjp/N4FZMjz46+oRGNrO
         LUtsfjdeaH6m8asTOLqaamUkFK63c/jA4txZmEzZO+/jicbSH1eFQP57nZV4JFn8t9
         911fNT9Dv7FCA==
Date:   Mon, 23 Jan 2023 20:28:44 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 00/12] can: rcar_canfd: Add support for R-Car V4H systems
Message-ID: <Y87f7BPchIcT2BQa@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+GiX6MlQAA4givF7"
Content-Disposition: inline
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+GiX6MlQAA4givF7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Geert,

thanks for this work! You not only added V4H support bu fixed/improved
quite some things on the way.

> Hence despite the new fixes, the test results are similar to what Ulrich
> Hecht reported for R-Car V3U on the Falcon development board before,
> i.e. only channels 0 and 1 work (FTR, [2] does not help).

IIRC Ulrich reported that the other channels did not even work with the
BSP on V3U.

Happy hacking,

   Wolfram


--+GiX6MlQAA4givF7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmPO3+gACgkQFA3kzBSg
Kbb92w//ZDtw+CG21FXOjfI3qtgakd1FudDQYcDoSv+JiVYwSQxD1gMvGcoT+R4S
1mep29/AXaz9WFNRA+L7lej8wwP+BXfGne2PcXhJSv3qXRyYhxaooN1Ws/Ut3nrX
RZLaDZIjhctd2OgJ1qJlYCW8OTLq6oksbmaWD7BEMfRB9lkh6/HHo3dKG327QMaG
hOjvx2Wp0w92SjTf9WBq4DZn17TuTdTslAdwzgXiQRWNqdEO99nGVc9mz3fnU3SM
7ADxWmnUDmXI0dwLvRu28AvWIzuHdz5tto++AD//miNKJVf9rHuOI8wceDcb4JpR
XAs/lgGLaBwCd7AkZnTijaTZuJfmWqxcNiLHfhDJVn4kYy+IWFQOPppzPAPef4oK
soFiUBpgeCuujqOPwrOyNbwVuI15S1C8xfYxZguc1ZNrF52iKR3G3n13xXVmkoy/
x1NiKza5ueFnJrisopWj8rOdChUwdaFt2k5zTRXmwYE1C5KW7J5AA1DQrAyYmgc0
WpuvfN56cBrseAuSdi5156+xKJnN7gY9DTJcVUw3PzY8KmTeY8fcvNNXrGw914Bn
dkVajyH5Ju7dYp49Sf3RCb7o61AWUMn0tbDbQBfmHPBVDcGHQeRECyKIbNo7RfHH
FkN29pw9izxIT1ewuokGW4nUkKT7f4dvnuJCsPG4Bcl4H3Z+ZL8=
=m5rR
-----END PGP SIGNATURE-----

--+GiX6MlQAA4givF7--
