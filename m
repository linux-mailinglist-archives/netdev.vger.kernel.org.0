Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2184CCF2F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbiCDHmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiCDHmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:42:08 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F391D18C786
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 23:41:20 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646379678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yfEybpt1FZFQUx0bhvUQdjLM5shYjb2AwbFFI9JMzb0=;
        b=AsrTKhFHY5l737FClqjHQkrpA7b5WPLh/LEHvADgkKk3UoQuQoTkRxMv6w/owT0oyiyHR+
        HoWI4asfhTul28pJCXkbTnokvbgWV+5kGYSvsopH5sCgC/8uf2QGQKJXYgQoFq6AWgDimb
        SmhHroABjoa1jV+9au0u5S0kQMPDvNEXzhdXDj9RUlnrPeuCb8sYvuP/q/YmIZcvjxAqY9
        vGjcD3nyMbN9LHbTyYcBlH5OqFDhvf0wDKwS1I91dnTfUFBBR/GcZZMgQrozeQhm68xXo6
        qy8MzltqgZ3ZiIJS6SyJ88e2HUvephoXRDthGE7EQmqVftHV6jQj8Psxndlbcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646379678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yfEybpt1FZFQUx0bhvUQdjLM5shYjb2AwbFFI9JMzb0=;
        b=tmmPOPUY1TaXx9kqcOoP+Z5p0MK/h75zc2cQFPtqC25H65KJ7M32CwkIkToWyp3+UtSpBS
        vKPPGTP/30ZWCNDA==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 5/9] net: dsa: Use netif_rx().
In-Reply-To: <20220303171505.1604775-6-bigeasy@linutronix.de>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
 <20220303171505.1604775-6-bigeasy@linutronix.de>
Date:   Fri, 04 Mar 2022 08:41:17 +0100
Message-ID: <87wnhacggy.fsf@kurt>
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

On Thu Mar 03 2022, Sebastian Andrzej Siewior wrote:
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
>
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
>
> Use netif_rx().
>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIhwp0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgoYiD/9d65h6436tex8iS/GbW5zySVTq+4WN
3OXL5/Z9C3VBkcS65Zf2ZADabRfseWuABory7eMWZ0wHalN8zQ/bOCXGG7wx37Sq
OdDogVtLH40hwmqROh+FWPRblh9bAnxz/5ixJyjzApg9qVkPDEkglQFnuiRnNfE0
JeOwKjBiqSBSP1O1iBLxpU79BtL1WjddjZN4Fl9NNvVgR8wsN0EX+Uw4ox2RU8OV
LsVkAxPhfaXq2W205JChq20H9RhDKRK8f9AZxwz4hXC5z7K/Io6jA/r1fUBdHVVX
m5GlEtVBNFN407P9+j1loR4s02WxgmP6yhs1PV6W71FGHXwS/nD4T3MmMKHBg1Mp
cAki7LDs/7wD/sHCZpGBZu1qS5gJeKo6bxcjQDlcY3vRKHS4tksZPGa4nL2+Qxbr
WfsFklanlKUWiS2GFwkAT3FNndMaftfiqgwPtxZ6d5ieJA4o3cUvLkO4yhnwZbjw
QDjDABE3zqpe8pTTVu+AyosYy3k+vRfEWKqcHeK7+UoyHN06PyhlnUeHrDPiX6/6
rLqg9TmTFYZuConGy1FlqZRJIhDQ6flH8YglNDHorJkhAAGyncUyi7AnEWk1lWuq
5YvyejYAOUenFQEDO7SbnBrBHU3Zs495IWMJO52oodwIboIjqQsdVo97dACxGR1p
aEze15SaabKKxQ==
=HIBv
-----END PGP SIGNATURE-----
--=-=-=--
