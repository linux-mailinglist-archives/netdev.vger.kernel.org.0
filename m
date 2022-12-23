Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9155C654B14
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbiLWCRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiLWCR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:17:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1057B4
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 18:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B836B8203D
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395BC433D2;
        Fri, 23 Dec 2022 02:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671761817;
        bh=lxqzOzRevW9tRFkE+J4NeYKfSHoBowUDMhzrZq0yGbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uTXqTZRLyzdxa11mhhA2LhhlaSmO/Dfe/RMckAtOxs5ton10bb13bUSr8E12k/3Ew
         tx2BCoeOIt0Vtoe5zGt9KncSQNEc4rfvVyjdBBuIDlrdFgEC/PLJzaVvHTl7B43N/5
         hb6x/3plwa19LYVYvWQ4YeGurpBUPt6HPxlvz4BvZAuqPuUGZ90Hr+LLBCExHGHZxM
         InQ2JyyfGViVLezBj2cRQT1jkd2Ldl+J8IK8YD8+SE9CySSdQxMkpcPHYYXqUVwgOK
         nm77O2oW00EHdfq6B276ZipMsq2am5Cff9S9yuPKsWloz7uDQZsw3hSbglAHjDKWmT
         LXvNA76KkUcOw==
Date:   Thu, 22 Dec 2022 18:16:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, <kernel@pengutronix.de>
Subject: Re: [PATCH] net: fec: Refactor: rename `adapter` to `fep`
Message-ID: <20221222181656.55c56774@kernel.org>
In-Reply-To: <20221222094951.11234-1-csokas.bence@prolan.hu>
References: <20221222094951.11234-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Dec 2022 10:49:52 +0100 Cs=C3=B3k=C3=A1s Bence wrote:
> Commit 01b825f reverted a style fix, which renamed
> `struct fec_enet_private *adapter` to `fep` to match
> the rest of the driver. This commit factors out
> that style fix.

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.
