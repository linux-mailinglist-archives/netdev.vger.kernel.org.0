Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B205E5B4A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiIVGXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIVGXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:23:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE2951420
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:23:51 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663827829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AMIdeNrZdSOz7HG3S6r/8VxZrcthN7xA4I8BHzCIo+E=;
        b=BHGxaBI2+WfOP7vNa9pCzELc+M24HpbsQ0XEi9Oz/ef5VciGKmSSTSeLqEl4i+Ds9De73z
        SUvA1fh3pYvDS+/L1xZ4gQ7YrKW/v+Stl7mbVtl/ekeVf3CGz5vG9KH4P7DAzSxG5h3Dz9
        QcNznztDdyx0afLzTCKKa494uYBxfSXbLGX/XPQTswGX5WGWQYPy5psPZzXI9Raw6j24HY
        I41+IM8eQSo7b8Suda3b25v9IFrAv94OZs8U+vO7Q+SQxCSJ44SHJnEBUAUeUAhP0se2v3
        bmCvNvmk1UW7d9N0LwWHhJdcirmPnKrVY9S1FeW/Km3AOQvTzWpXTYdoJjR7eg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663827829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AMIdeNrZdSOz7HG3S6r/8VxZrcthN7xA4I8BHzCIo+E=;
        b=DTToVDY9GKzgWGw0Ce65N5zjl9sk9TXdotYRNVrsfTiRipGiMiuHNGy670zd+qLEyMB4lS
        vWxykcxOo7XuuXDA==
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, hauke@hauke-m.de, Woojung.Huh@microchip.com,
        sean.wang@mediatek.com, linus.walleij@linaro.org,
        clement.leger@bootlin.com, george.mccollister@gmail.com
Subject: Re: [PATCH net-next 04/18] net: dsa: hellcreek: remove unnecessary
 platform_set_drvdata()
In-Reply-To: <20220921140524.3831101-5-yangyingliang@huawei.com>
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
 <20220921140524.3831101-5-yangyingliang@huawei.com>
Date:   Thu, 22 Sep 2022 08:23:47 +0200
Message-ID: <87mtasq64s.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Sep 21 2022, Yang Yingliang wrote:
> Remove unnecessary platform_set_drvdata() in ->remove(), the driver_data
> will be set to NULL in device_unbind_cleanup() after calling ->remove().
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMr/3MTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzghk/EACprYB7JS9TaFYh9mzi+PFI/NW3sD9v
9boYT48ZRrwEul15TOJjZ+T8PZ20HJSHFZlm3b+IgaYrGi/ZVqjiem43unCnF+N9
AIRkZGnrEtMGuKPARZZTAgKkIfkyuC+a/RiTYM/DOcpAVSSH2vt2C1CylhhVvVjl
NnwzCX6UGj8O3z/VoSa0FolPkr5pz7M2GmaAGsrA0IM7iIhpN8nBjWXys+jyZdB2
S3Cdd0Cg4NuDhk0P7T4/KoOq847/1EfNbHD2+92Dkf5d9A1yTwubSi7YIG0W/3IZ
My8JchIFte+fCBin2/G2+mSqREmZ9WUQ6O3MqA2coGXzEvrSJ69voUkn5ABzHtoH
PVYdbVKy27XmBkHR69G/UUulP1byxNNjBsX1yiphO4pgZ0+OnGMBmRDPvtMMfT0y
sAYY0FDeeaRMcmRTt45cdXpUBTf6vhi0tIjEszAJulR4opQ9+9L99zWy+53yHEUr
YT4FGxkfXsSz8Jlv4TzdfZe1AYql9mezIXy94e6nTcw1ZVvxJIC2pahL8JwNv+Tq
MoD1woyuKpnErbyqN5yyO0eSU6MltkcIFklnOUaR4oxIJ/gypfekENunvb/uYgx8
uX4upkCV+jBCWpE2rk2b9UTA21jampK02Rwj+Do/BvEgPsmclctS3hvaOWKpSwQl
tBJgq4eLhqrpRw==
=5c+e
-----END PGP SIGNATURE-----
--=-=-=--
