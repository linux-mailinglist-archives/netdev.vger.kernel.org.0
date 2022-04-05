Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600154F2DA5
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiDEJev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343886AbiDEJOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:14:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB5752E06;
        Tue,  5 Apr 2022 02:01:14 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649149273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rh9iNBZn1TytrAMYCuDnnKJmAsEgHeZEynUJiMvsZOk=;
        b=LqXhRsdwDnx50slIXYLrlXIl752amZvkIUa+s95z9opK0k7PBcMaDQEyDtbPGUTQc7zuKp
        Oi1YamAS9fyv758WO/F8pHuu7KLe5taH9kVzXq8z9W/3ma+zIYv1V/wrsQgsyFuBFx8XRp
        eDOKdiMFG9Mv0qenCxkSSN+y/739o2C39H5qdpKNEjQZdtILXtju9C0VZB7Hz2/w7ROoF/
        0m8DkPKMK1mEs3BEfkqAdfdbhp7orXEO06I9hLjm7oe8FcxcSdH4rMffV2h/p9GjTfSo3K
        JQ9wI2a6AWgnY7zANYUy1bCQepfqCFYazHgkAiUF6iLRg9rA7qQVdtxIlz8H7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649149273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rh9iNBZn1TytrAMYCuDnnKJmAsEgHeZEynUJiMvsZOk=;
        b=cjAF5UHNewgoGCOyWlqrCBrRJ8eRcQ9tFo8q1TaB6DLMNlhycV8uzT4L1UijpRYZBi4czh
        SuAsh9qDhvhk8sAQ==
To:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
Cc:     richardcochran@gmail.com, davem@davemloft.net,
        grygorii.strashko@ti.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
In-Reply-To: <e5a6f6193b86388ed7a081939b8745be@walle.cc>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc>
Date:   Tue, 05 Apr 2022 11:01:11 +0200
Message-ID: <877d83rjjc.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Apr 04 2022, Michael Walle wrote:
> That would make sense. I guess what bothers me with the current
> mechanism is that a feature addition to the PHY in the *future* (the
> timestamping support) might break a board - or at least changes the
> behavior by suddenly using PHY timestamping.

Currently PHY timestamping is hidden behind a configuration option
(NETWORK_PHY_TIMESTAMPING). By disabling this option the default
behavior should stay at MAC timestamping even if additional features
are added on top of the PHY drivers at later stages. Or not?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJMBVcTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsMiEACJ6hgiPJnF7jCixnXIaxDdO+mW5fZI
JPBCVnKJsrETFpGY2/cSr0aFN2KeNvF9S15jw36a+Tabnv6wNnYWnhqOdsyGBtE4
wQUfJrNCJ6BHx9qUmgY+WbLdUEvXMnEx+ko/co9FCFWijd94M4ctaEdBbxq3WfQS
3fzMpHssQfITgfgeaf+j+k+zR2i7UotKvQ7nTTZDiBgbQ1xn+4cDbR7uZZNPIKqj
IC+R8BcOJENXkm8HwB/JvcRhOynsPFCJjHoHqM8N4v2DXFRnV8pfzceyZO6Lr5XF
BEpaWfAHjcmnbzhC91oASXE5usbEqpQE5tAYK43m872DaHh+s1p4d4b3IzZU5uwt
rx8zheaRta4gqUdaJo5qQkvKdD2CAYyK9O3v0rQMJRrTCK3Z3sZM/IMWNsEOqdVP
QP1GxPByDHwwOsTJB4/v4DanuF39hSrZ4Ym2mi/PX76LmMZoL10JDzaU0rdg56nf
Vg0EkwnCDxYSZJpB3r+6zFMNKDQyA6uOJAeKpaEB4kpLUMjZsRfZOgP1FJW1Ndgc
Cggk0EckGKx5+zjTcHnVpr7VEVrSfeBGFnujzUx3TlduYJ8XBxLv7saUUlpE0O1O
TkXxhxodllu2X4eis/5mIctYGgWl2XL/KZUD3Uws9a0PLLVZwuTxsEcS6ov00eKM
NfqGdBj8KceuNg==
=dVoz
-----END PGP SIGNATURE-----
--=-=-=--
