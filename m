Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429C1662498
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbjAILsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbjAILsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:48:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBF3C767;
        Mon,  9 Jan 2023 03:48:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 765E66102F;
        Mon,  9 Jan 2023 11:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A0BC433D2;
        Mon,  9 Jan 2023 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673264920;
        bh=XVe9ZIsJBVYmm1apnGM4DzZt37qBYjqTL/4caPg0IAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lVZc/+FUPE8QcOrtnqRxXZlRXAOoREyaa9a/YMj1p/937Jkdo4VD7sxKuUkywRPud
         /CQwgBnnwxe/WI6ITNCs4su1aWMNLUBDMzxbtXibosPINEJjleTHHTaPnIwoclkEDx
         FqdGooILgLdKBG5ZMYs/4b229Q5vLkODS3wEX8CB/xuEpgbxtSNsbA1iI1RHaHZRZ8
         wblCgYzhTOYw9f/w7fZNaPKiAkMwgZcix5uGnrcYaGULE/CT6L74nV/fC3tdllM/au
         NXcRy/6tu2DAo+fHpkGQWxFNb8AzEYlf+2T3jmzo7kHg8ghYhjh5G/zpai30iHhjfk
         4J6u7Ni/xo71A==
Date:   Mon, 9 Jan 2023 12:48:37 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v2 0/2] Add I2C fwnode lookup/get interfaces
Message-ID: <Y7v/FWpjt1MFLafG@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qLZiiXAOcTg86yPW"
Content-Disposition: inline
In-Reply-To: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qLZiiXAOcTg86yPW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Russell,

thank you for this series!

> This RFC series is intended for the next merge window, but we will need
> to decide how to merge it as it is split across two subsystems. These
> patches have been generated against the net-next, since patch 2 depends
> on a recently merged patch in that tree (which is now in mainline.)

I'd prefer to apply it all to my I2C tree then. I can also provide an
immutable branch for net if that is helpful.

> In order to reduce this complexity, this series adds fwnode interfaces
> to the I2C subsystem to allow I2C adapters to be looked up. I also
> accidentally also converted the I2C clients to also be looked up, so
> I've left that in patch 1 if people think that could be useful - if
> not, I'll remove it.

Because you also converted I2C ACPI to use the new function, I'd say
let's keep it.

> We could also convert the of_* functions to be inline in i2c.h and
> remove the stub of_* functions and exports.

I'd like that.

> Do we want these to live in i2c-core-fwnode.c ? I don't see a Kconfig

I don't think this is enough fwnode-specific code yet for a seperate
source file. I also don't think the helper functions are so large that
there should be an option to compile them out. I am open for other
opinions, but IMHO that part looks good as it is.

> symbol that indicates whether we want fwnode support, and I know there
> are people looking to use software nodes to lookup the SFP I2C bus
> (which is why the manual firmware-specific code in sfp.c is a problem.)

All the best,

   Wolfram


--qLZiiXAOcTg86yPW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmO7/xIACgkQFA3kzBSg
KbbKPQ/+IGwwAtYwJ64XvFGN53u6K7rCs//39Vxd6VIDaUZi3XR17sefWTLnTCMU
CI/wYx5es+KKPSNrtbS+oUt1pdfjK2diCm/p8Y5AhUHPJUlHYISgaCrOk5SwtWGn
Y9w+xfoN4cKrvl8mvJYJ8dseap86n3+fdYBamcaSsF+5R5qmuunzFhgTzuQgDnei
OF3jYAj1wUj5umG6R8uF+3oMTaJPvsNOlJZlQW31DEBHrUuelcm9pD/wLzXINaBu
yT3M80zgOR30O4s9LzE059/BuGu14nYZI52UdO8EoL/s02Ugn7rLegdpjymWof8/
lGEcyVwioNJ3lqkeKHEchBHthT385MrAHxnWlY6SJ6WayATgOFwkwBlXDaYD6P9M
FMrL1nCTWnI+XQlHcaj6Cpz1BWw1eVY75R4WdSnIoAEz21eRWlXlLGy7ttGc2wOD
vie4ieJyWRyzsjobw3DJBDdLYGWsq5ARMdJuMWx8HG8uVmrisb4aKTUmpq/0SO1i
GyiA8V2WCdJQ2Ne4zePMrIt00uSWoHuFr1muVikbkJSLkrIhV0wurbDHknuxuZ2P
x9/Zrapz+13qYY4Z+8qDIeQSTjSGsfWbRhn9SJlihPUdvJp+/V6ikBP0WfFXpNGu
JweZ46FeTsV3Yki+mZHu97+MVEh+UJ37Lz6+BWWnDXrSFW0S7lI=
=Xfqm
-----END PGP SIGNATURE-----

--qLZiiXAOcTg86yPW--
