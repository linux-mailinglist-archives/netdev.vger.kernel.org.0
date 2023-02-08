Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD45168E77A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBHF0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBHF0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:26:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A6635AE;
        Tue,  7 Feb 2023 21:26:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BEE8B81C0D;
        Wed,  8 Feb 2023 05:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0454AC433EF;
        Wed,  8 Feb 2023 05:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675833956;
        bh=dVPtYgDR8H752PdO0OfEoeUEtay31tVR8DSjLTPBMZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CJNPlivDL0az7Jq96Hkv/RLiazKmkb9GdnFLKN7UzCBeB8I+WU+XusTI4cLDWPLjj
         CB1p+wRPEBTqqh3HjyIe5aqo7WuDR9oSn4JVs2enFChzhjLUyXKbhxr4jCcLaIy5+E
         P1IsjgIi8CWpMaDH3MxsApj+5GDCkyVzdwlQaxhatRkHJX3irh3aOuF9Pu6L3X/zj0
         Kl8Lmlj2swiZAQ4B/ArnO95ZxcJUZ/FGI2yaEwWbQCm0DkyE23Kp8dzqoeQnPfxt7j
         BxmBAJcoaM/y+uN+fBulquXZ20SltnMYPOmH6EFb5N1j0mTIQipNwxbKYvjUobiVUm
         zpCFHbxkHhNPw==
Date:   Tue, 7 Feb 2023 21:25:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 00/23] net: add EEE support for KSZ9477 and
 AR8035 with i.MX6
Message-ID: <20230207212555.79ffbc26@kernel.org>
In-Reply-To: <20230206135050.3237952-1-o.rempel@pengutronix.de>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Feb 2023 14:50:27 +0100 Oleksij Rempel wrote:
> With this patch series we provide EEE control for KSZ9477 family of switches and
> AR8035 with i.MX6 configuration.
> According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
> we consume 0,192W less power per port if EEE is enabled.

Can we carve this series up a little bit to avoid large reposts?
Perhaps you can hold off on reposting the cleanup patches starting
at patch 17 - repost those separately after the first 16 go in?
