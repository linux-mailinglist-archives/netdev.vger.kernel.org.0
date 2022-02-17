Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36BB4B9B96
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiBQI7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:59:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiBQI7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B082A7970;
        Thu, 17 Feb 2022 00:59:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30A8F61CAE;
        Thu, 17 Feb 2022 08:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD6CC340E8;
        Thu, 17 Feb 2022 08:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645088343;
        bh=3/VnyvHjW2S03x8n/HFwgjlbQS0c77+4Z8QLz176paY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDX4V/Ass6Y+1GZE2DcNXr5VjnHSKaums8ShCH3Pa/OlAr9ifz8VGQrMYNwKx/1zc
         JaFdMbvSG7cq2lzilk0Sr/xo1pKetoovmQJ1Ak4Aqi678O7nLpXuWV3LPljYSf4eBC
         Uw8FCXdHU+mlGyGRZq7UZEnzDFFix2+/xybqUGgyJHzukm3tanwQEJ4PWgqV4GuZ+i
         aCP10K7jowsZ8oqBDazERk7V9WB3Y0n4xNzSLXysWDqZek8bu8Yz9y9M+CE6uXKMJQ
         RG6ZP3KRFA/nlttRpp49EEoGuYHrOcEzMy3W5VQvGJSDIKZR5Li3DrrQUF7x/CFkeQ
         po1gfnRv4A2dQ==
Date:   Thu, 17 Feb 2022 09:58:53 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <Yg4N1SYeCdSPDR+V@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
 <20220210063651.798007-3-matt@codeconstruct.com.au>
 <Yg0jMkt56EhrBybc@ninjato>
 <eaee265147f14982c89d400f80e4482a029cdf98.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZHZqbK1PlzjPYe7D"
Content-Disposition: inline
In-Reply-To: <eaee265147f14982c89d400f80e4482a029cdf98.camel@codeconstruct.com.au>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZHZqbK1PlzjPYe7D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Matt,


> I'll tidy up the comments. A filled /* first line is part of the netdev
> style.

Interesting, I didn't know that.

> I think 'slave' might be a bit unclear - the driver's acting as an I2C master
> too.

Right. Yet, AFAIU only when sending responses to other nodes, or? It
does not drive this one remote device with address 0xNN but acts itself
as device 0xMM.

> It also is more baggage moving to inclusive naming. Maybe mctp-i2c-
> transport or mctp-i2c-interface would suit?

+1 for inclusive naming. I like the "interface" addition.

Oh, and one other question I have meanwhile: do you really need
"mctp_current_mux" as a device attribute or is it mere debug and could
go away when upstream?

Thanks,

   Wolfram


--ZHZqbK1PlzjPYe7D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIODk0ACgkQFA3kzBSg
KbbUzA//T25SdL1pgc802/YVv2bM4Rmm8zKW8VNMRsW6/RB/x2VXNq0MHUyQQ14W
o234nAmQbX5J6vI0RdwgTiL3sHTu6ydVdd2kMveNCpn/9+eEkfUM35qeZXe0qpqv
ig3ozSgbpYk7sBSwLVzSkv4QpEWC2iqlcAyGQ1NLgVqGMir0LC+SwUFtiUMIS78Q
YCBH5iITzUDmLHZmuhRmsXZrfve930ZqaNfOrJS0uS24T9I1b7z8OdpWJxoU6KZ5
LG4PgOexDMqbOS9O0FpK/j9MARDcXaB76tGU28ZxnLGjQtoYOvycoDKXjvc0crLv
fF4KtDug81dBt2Vd5ELQ/LktBy8YHZSAKQkilZJypZ54p3I5ai4KbF7Ad/KpZM5p
1PN5zzoEys6iH+ixY5zTzJ9kMueUtAdXYPwg0jcC86UjWCHLVdR6T9jjmB3xGg/H
Rbdz0K6wwQbjRoxYReS3PpJTs5uMDj7ncBuII7vKDOH2K5Q4Ifl3lkcGA+3IxxaE
wyXKwUgc+Vgm5NON4u1HnWFpFJ91g2XuZE4tLfW8ksIgaKlF7DAD1FQvP3XYPvX4
5Lq0cfCgeorJJGomQVMpyR5Ay4yiVFtK5nOtwHGnBvCC+rhC6f5LlsIoc9NkKIgE
4/yh83PxAhJNLs5XbkuMs/KlhhvtGko+EtIaPwiBkWxkFnYZItY=
=9u+1
-----END PGP SIGNATURE-----

--ZHZqbK1PlzjPYe7D--
