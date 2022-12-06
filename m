Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C055643B26
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiLFCFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiLFCFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:05:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEF8233B7;
        Mon,  5 Dec 2022 18:05:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E9B61407;
        Tue,  6 Dec 2022 02:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7893CC433D6;
        Tue,  6 Dec 2022 02:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670292328;
        bh=qiuErOcN7JUc2YO13uuK4+UNytnm71xxkRzs+qlmYAc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rBWL30/swqRnqprtZuHKVMIO0pc6S1Zz7E9dv7U88GXShlo6tJZCdkqjMX7KrOZPS
         wqIZFTNe/Sjd7/VlKpOMXBvslmVP8KMMN0QUiIlpwtCarSNbZhC1QTx+CJS108vaex
         0Ts5K4vddBR36iQHYT5jf/spklsr7ygum2mE5XvYv2dLK2brGFkhNsE4lHgrz43KvA
         xcf3Sf3+E40EGHt7x6bURIR6H2qymmRzHvYJgklbU0qNVnD67ifHRJE1nA7YeXCSNh
         4MMypwHYHoRk0cFxP5JR5hfJFs21nnJ8cMZzm+kFLsDm3zNMdXbUO9Q5KHpxS/rgrM
         01IFukhHYpH1A==
Date:   Mon, 5 Dec 2022 18:05:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 0/2] ethtool: add PLCA RS support
Message-ID: <20221205180527.7cad354c@kernel.org>
In-Reply-To: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
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

On Sun, 4 Dec 2022 03:37:57 +0100 Piergiorgio Beruto wrote:
> This patchset is related to the proposed "add PLCA RS support and onsemi
> NCN26000" patchset on the kernel. It adds userland support for
> getting/setting the configuration of the Physical Layer Collision
> Avoidance (PLCA) Reconciliation Sublayer (RS) defined in the IEEE 802.3
> specifications, amended by IEEE802.3cg-2019.

nit: for the user space patches use the tool name in the subject tag
[PATCH ethtool-next], I bet quite a few people looked at your set
expecting kernel changes ;)
