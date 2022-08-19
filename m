Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFAA599709
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347609AbiHSIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347662AbiHSIQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:16:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4115E86B4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:16:25 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660896983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iAeHbgTyNuAgltUk0EQOJUeOMfI3vmCTDz4juTkJdO4=;
        b=vPHSawoGTITd9lM7nNsLME0UA7ornVZ4kgXhwTNAlNOplAZvos/pbiOrqPuXVU5gUFL9Ef
        3J7f0uzKuxXU+kH/r07I2UsmRqeHIc9fRyth5rbikSqddXwhYgn7QaEM7m5zRbFtozi/Wl
        WKP3iym3DDJHUCKeOz8mLZX7cG/QPwL7WAdZeMT8KbhjiXXE119w6+Z8HuH5PiBgjMrBq9
        4D4G4BOurVHtBbyNQuPGcFl+CDxmk6hsfk/CxWdETTqy8FKsvcgrSTPo/Gf7CPpP7ihgmw
        FCNuNvzOcUIUbmxDjdyoH94THm36yraSLxl6BA5W0XbW0TNh6bv/hpkx+J0sYg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660896983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iAeHbgTyNuAgltUk0EQOJUeOMfI3vmCTDz4juTkJdO4=;
        b=NtkoEBEk7AcA9X+aygRCWZYu6/UrIFoa6coqcnicEcv5+djgVLa+7bJvQMs3cOdOgrwmte
        +ph3Xvh+4nGBWUAA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Date:   Fri, 19 Aug 2022 10:16:20 +0200
Message-ID: <87czcwk5rf.fsf@kurt>
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

On Wed Aug 17 2022, Vladimir Oltean wrote:
> Vinicius' progress on upstreaming frame preemption support for Intel I226
> seemed to stall, so I decided to give it a go using my own view as well.
> https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.1098888-1-vinicius.gomes@intel.com/

Great to see progress on FPE :-).

[snip]

> - Finally, the hardware I'm working with (here, the test vehicle is the
>   NXP ENETC from LS1028A, although I have patches for the Felix switch
>   as well, but those need a bit of a revolution in the driver to go in
>   first). This hardware is not without its flaws, but at least allows me
>   to concentrate on the UAPI portions for this series.
>
> I also have a kselftest written, but it's for the Felix switch (covers
> forwarding latency) and so it's not included here.

What kind of selftest did you implement? So far I've been doing this:
Using a cyclic real time application to create high priority frames and
running iperf3 in parallel to simulate low priority traffic
constantly. Afterwards, checking the NIC statistics for fragments and so
on. Also checking the latency of the RT frames with FPE on/off.

BTW, if you guys need help with testing of patches, i do have access to
i225 and stmmacs which both support FPE. Also the Hirschmann switches
should support it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmL/RtQTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzglqND/4iy+aPQWca1zix13EL28YvAFOnGyj3
dJ7flU9eETU0Ga1gn3hVl8NFx8jzYjef1t+HWWa54LOIEmaWX1mCJRP/bH3s2IlB
hxk76X86o8Bq47N1FqUC4YlrPpQ41XfemwL4zKYW3JAMnYboxwDECnfcitivdU7Q
iL2m0AU4enJzQn+b+Fes59449ITbUBQf9ZdEB1Hwxi1yyRedvGHdgjyjWMovKD1T
YQ+Hhi+OfUvK4UQXh/m/IPBiGIC2d1b250HhUpXcvgk0qLU3PMtSk4G5OwEUCgbB
jn7PuMlhsSvNHo5qILbLYctRA81XmUyWxnIvZVfjB77vO0gC8wZlh9rIIWO7af98
zlO6EwF3TZ3bzl9nUdlzXafUd9nqY7e4MuRqPDnEgw2Sm5Iqk+smCuQO6AfKPbkL
Z0tIFYMb1fB6N1YJpHxfNYP4BmlapKJL188oFkvqSLKiV+KNCrJPCXUeWeVsPISV
UUmuzg3L/AGPsYVk6n2ctsXHGHHJWrW9mLaGi1RPy5JFaRBlGEjFgqLrZrDvpvWF
rl8XIKYCD1h65XSGc8GOiTsa6AhQsPswNybCsmMHsdPMtJ93YuUD5KHUHAAIDBP6
immXrAuuf4AmWv/P5se75Hwmx69dQsS8EyjjdItniONkhY3Xl7N/EkzeIIg1cGlP
7oLS/RBr1H5k6g==
=/vVI
-----END PGP SIGNATURE-----
--=-=-=--
