Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96A62B0EB
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiKPB7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiKPB7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:59:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D4D2A729;
        Tue, 15 Nov 2022 17:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 919CFB81BAD;
        Wed, 16 Nov 2022 01:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF045C433D6;
        Wed, 16 Nov 2022 01:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668563970;
        bh=3gbgW/mF3J+HySRfesQyRT+kCtF3aU4PVWLR4rJXKAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uGjS/ZhH2tdtr33vigSv782c/yVm0NjtspgLOl1M4z66HKgmu3iCsBcy5c8q3Ouqs
         SyVHKXhemtsWkGTFfAyI1Bn9P/ikATL4YKo1GXNMRsmIKewHlMJ5NiPDjLNhzE3PQx
         NEAFB9l7MMdtwrkjvmrHvOTuF8j+Gp6TOL1iThVs3skIkBzVr5wJD8wboVr5VNCwNL
         QP81dYsivOPpMND5qtN+IbQ9Lb1EldXdlq25M83kb2ZXYUSv1glL22CE5DOrzq2K+M
         oyuiu7Wjs4Jj6RgfgQq/IakJHmuOcUY78o9pWCNChru5agch+kMLvqzeh+O64tSPX9
         uM8pdNSYRAUKQ==
Date:   Tue, 15 Nov 2022 17:59:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: use more appropriate NET_NAME_* constants
 for user ports
Message-ID: <20221115175929.7ba1e566@kernel.org>
In-Reply-To: <708663f3-8e48-5e0d-a988-8d66ede02543@rasmusvillemoes.dk>
References: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
        <20221115074356.998747-1-linux@rasmusvillemoes.dk>
        <20221115083828.06cebab1@kernel.org>
        <708663f3-8e48-5e0d-a988-8d66ede02543@rasmusvillemoes.dk>
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

On Tue, 15 Nov 2022 19:55:24 +0100 Rasmus Villemoes wrote:
> OK. I think I'll actually do it in three steps, with the first being
> this patch but with NET_NAME_UNKNOWN kept in both places (i.e. pure
> refactoring), and the latter two just changing one assign_type at a
> time, so they can be reverted independently.

Even better :)
