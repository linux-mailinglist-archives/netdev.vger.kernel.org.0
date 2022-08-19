Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238CD59A984
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiHSXcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiHSXcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:32:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EAE1141AE
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 16:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC172B8299C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 23:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9ADC433D7;
        Fri, 19 Aug 2022 23:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660951932;
        bh=CGWKXkxEFwAXcQDH/Eyv3/Fv91wmQAh2WToo2ewnxxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UPgTctViYTWQ+DS8W/XetzCvpvaFcuAvurkkVHdVcf6YLGIdAkM9OZ82GGbxMYvKK
         QVL2j+NSA47RwcMne0tTea01Xg6wK4TDoYHQVzVakE2P8XdrZYor2TsmNxMqWLsFQr
         J8tskLl7Gj+9nndwOrohe97v3kRnQlbV/hwmKVMpOYqNy6/lEHUE9r0c2ij0LvF2cS
         GWa6o7PN4SkhmtDh3Y3KzTYy0YrcUSnlon+mf1FHGA7aVl48D42FQYOeeHWB9JcNr/
         8p3nsbXC+NZT+PI5qyHsrvyUc8mfU88wSBkQKh7B7e6EluhTgbK4U76ttb1CuAXoBl
         r11ZwJlDRn95A==
Date:   Fri, 19 Aug 2022 16:32:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Alvin =?UTF-8?B?xaBpcHJh?= =?UTF-8?B?Z2E=?= 
        <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Message-ID: <20220819163211.633bafc3@kernel.org>
In-Reply-To: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 17:32:50 +0300 Vladimir Oltean wrote:
> DSA has multiple ways of specifying a MAC connection to an internal PHY.
> One requires a DT description like this:

Too much side-conversations going on here for me to grasp, this is good
to go in, correct?
