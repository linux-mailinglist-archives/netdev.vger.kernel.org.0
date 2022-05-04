Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A12519310
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiEDA5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244828AbiEDA5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070E541615
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 17:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D025B82299
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E5C385A4;
        Wed,  4 May 2022 00:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651625623;
        bh=/20H7tVNle9lQAuBhxgPJGkVpGc5EVbFcGjppj+ApYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ORBjyKm3+/OhaYBqqBlmK0mRLQR7MaAyv2e2WGjvIrTSwXIyHNkX215/M/5MGT87E
         aJp0kU0WJGNZvt19SEWar+8q2veIWRfdRK/SHZDSvmI6SxXe8/hKLE6MKee4rm0537
         Sht20Jr/GiM9bAlHn6JAwgMkBZ8m73DRhI8NVb9LkQDkHgg9yCrKXwlOxWp13a88aj
         /CThlg9ESaTodj1/2Z5CE2nMtIFADbtB57dDzUV9jtFpiH4u6hz9JxtJpJL1JADHFP
         tkGHzNUgQzgB7GQzhKJZzG3CtuJmT3noImcsYbUonoEc2SeXkBBIgwSluppu9C8a5d
         fEHfDDJeywvUg==
Date:   Tue, 3 May 2022 17:53:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: Re: [PATCH net-next 0/3] Streamline the tc_flower_chains Ocelot
 selftest
Message-ID: <20220503175341.661d6e4d@kernel.org>
In-Reply-To: <20220503124332.857499-1-vladimir.oltean@nxp.com>
References: <20220503124332.857499-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 May 2022 15:43:29 +0300 Vladimir Oltean wrote:
> The forwarding selftest framework has conventions for the test output
> format, interface names and order. The driver-specific tc_flower_chains.sh
> follows none of those conventions. This change set addresses that.

Both of the 3-patch series did not apply at the time of posting :(
