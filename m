Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A05EDD54
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiI1NAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiI1NAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:00:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E958531;
        Wed, 28 Sep 2022 06:00:22 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664370020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=slNPlDPKhBtEYORa9458NVH2TNWWj9CRmNIugr/9qTM=;
        b=evuB4xiJdx4xHzdArfNE7yrZP3y5f3nROq+TPZB0adLH59Ma2/thXr4OI8C9OzGnPBhGLQ
        7SA/LDf169fPSQmd9USxJvxa9pA43+gv1KQLSGL5kBA9ukpyEPPIpZ9YBVMlSw61KGSQcG
        NOBcsUQoLXlasoxLpkmHYY+n+ACo/kMdBqm8GysssXkT/JKxANeYlIXbKApBv3jMqPwFre
        ebSUq2wFIldI0XEE87/UXpkd+LF4dwLItP65yA5oLEB0Wht42lc2m9yfxUp9/grYRKkI5l
        ielQjv3RzDzqspYfziHqMd+Xb5ksluTZDUTihn02dZaf1sLl9R6W/ICWM4Qbqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664370020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=slNPlDPKhBtEYORa9458NVH2TNWWj9CRmNIugr/9qTM=;
        b=1VhEAfY8XavXDJ27ruAoAf0rPr1Ikgllls56RZlvk1TBLESakilIjkwSrCUDQh2GgGX+ZM
        adS/VIkyiBhPggCA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 4/8] net: dsa: hellcreek: refactor
 hellcreek_port_setup_tc() to use switch/case
In-Reply-To: <20220928095204.2093716-5-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
 <20220928095204.2093716-5-vladimir.oltean@nxp.com>
Date:   Wed, 28 Sep 2022 15:00:17 +0200
Message-ID: <87mtajfyce.fsf@kurt>
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

On Wed Sep 28 2022, Vladimir Oltean wrote:
> The following patch will need to make this function also respond to
> TC_QUERY_BASE, so make the processing more structured around the
> tc_setup_type.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmM0RWETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsuoD/9GJk5XsKgClARmnNqZQCdyzroU2wr1
PiQH7ClWHFxaGbs0KVYmT02uXBCvWzb2/yNkOjIdHkEsjaM4x3dGwCZEcnFd4jHF
MXzJIRDlsDGWNmlVKxKMxQ8gyzxKVzd2o6xN2vzbWF2ANQY6x73Y99bvEH7yA9g9
vDvW+akDXPxBiOpG3zBGMsHNChOO1J+hoBHjnW9oNloKirfkON4DvKi5wmvoksbx
P7lWb+fLA5CkubHhftf5UuS2PfKSJsAhJrMrZnqSuH1MTK4f7oUdiJwOBmYxpE1o
+oo7nw14qQZNp8XmaPCYXddDkFKHa0ZkomtEYMjnstgQCllREs9PY4/4SfwptGVS
6Y3PYHvdvR6oasIHuU3CuEuKzd80877BO9McEWxqgTNn4SdIkDzm9blxvz/Pc5Mc
Phv5g/m6gU2R3Ce16x3dVlZdLabi9uGN81p7Zl35uUz8x2k9eSHV30+fyNdlO/Ts
TeLYOI2lzXa3d7srGjaa+NkT83UpHeh97B4M2VYKL8dgE0LHq6V55S+XO58Pb5h6
uSaXD67qa5T9Laon4SE2RPHPFhwL0Eik2MZ3+aOL8/gcnA4XKWbY3ZmeLjDfIfeC
vTksOlR46JGJGf77fk5ZaHiab2YhI9386plUKuHQp3p51xB4yE513Fth2h5J/I7Y
Sl+cJ33b8487BA==
=H7iT
-----END PGP SIGNATURE-----
--=-=-=--
