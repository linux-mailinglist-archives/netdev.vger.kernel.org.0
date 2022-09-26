Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38F55EAC42
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiIZQRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbiIZQQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CFA7E315;
        Mon, 26 Sep 2022 08:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2364860E8A;
        Mon, 26 Sep 2022 15:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651C7C433D7;
        Mon, 26 Sep 2022 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664204747;
        bh=Aov3/htKvwTgeLQbsF1d8tAKy0N1QUy2ectm30sdcNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihe0QJe+e0jIrJwHJOGn1goH+ihHG3gLY3A1T+UkRE83krXWNZ+U7R7QqBB7aiaky
         T76XyMrw13QTxm7kjfOC8NpK8MAetVPB2+IrwrkkuQX95Eh3o7Z8rS5/aY2r08vKyd
         seYv30vLQEja3ARXi97JNIjGHYRCaLTcFXV9Ffh4b0uDvm3JtwmzqmvD8lVXXFN0tB
         d6pIUBs6zHLG2xmYQ7HmGb4xqnyFIKonqJ1rhHGhVBAwhW8Eu8DTZkIuja71sf0HjK
         m6PSn+YU8EdUHvHOuQ1nXZiYBkptaoXRgwB4ew0ukQua4brQkhPCjSiE8NNsbdsbj1
         xumf0pWjCpcdA==
Date:   Mon, 26 Sep 2022 08:05:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Divya.Koppera@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [patch v2 net-next] net: phy: micrel: PEROUT support in lan8814
Message-ID: <20220926080545.64f5d08d@kernel.org>
In-Reply-To: <CO1PR11MB47713D1140834D937435A6CBE2529@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220916121809.16924-1-Divya.Koppera@microchip.com>
        <CO1PR11MB47713D1140834D937435A6CBE2529@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 04:46:35 +0000 Divya.Koppera@microchip.com wrote:
> Gentle ping.

Who are you pinging? The patch is in "Needs ACK" state, try to find
someone to review it. Better still try reviewing patches posted by
others, I don't see a single review or ack from you in the history.
Just saying "ping" to the list that owes you nothing is really low
effort.

I'm tossing your patch from patchwork. Go review something, then
repost.
