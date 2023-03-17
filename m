Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60E66BDD85
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCQAWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCQAWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:22:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F81E5038;
        Thu, 16 Mar 2023 17:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F9F962161;
        Fri, 17 Mar 2023 00:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08207C433D2;
        Fri, 17 Mar 2023 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679012569;
        bh=4g9LTlLaYE3kacEznOgMJk6HocV0DFXGW5BGuLMjR1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=srCuaYO2jTw8X0C3hS178up0Vf7qQ2i17zSSOYHBb1UO84yCq4fe8UE/BzJUeMsjh
         BCWk8Fn/vrwhe8Fh2ExrDPkcGm342KBioES4AOHyfM2BwhRTh9KSoXhkyT6H6c0Yah
         nSbMIf9zc3MqmZeqwc+XRL4nNtL7APHvYJiKjNikBE2Hg9CE6TEAU5bUlJFuPvFRCy
         CChTPk8aQDMlGP3HWApKvafihnOzDffQExKoq2i7aAK3Ku6slxxjaF3ymNhrNBHNte
         LZDRPftHwfD/H6/KpIcNT22SSj82cYDfmXwYetJkWL7mZ+LKn8hoFYoJfb9RkhZ/cv
         6UcqjX1ROn4/w==
Date:   Thu, 16 Mar 2023 17:22:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     <Durai.ManickamKR@microchip.com>,
        <michal.swiatkowski@linux.intel.com>,
        <Hari.PrasathGE@microchip.com>,
        <Balamanikandan.Gunasundar@microchip.com>,
        <Manikandan.M@microchip.com>, <Varshini.Rajendran@microchip.com>,
        <Dharma.B@microchip.com>, <Nayabbasha.Sayed@microchip.com>,
        <Balakrishnan.S@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <Cristian.Birsan@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <palmer@dabbelt.com>,
        <paul.walmsley@sifive.com>, <netdev@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <pabeni@redhat.com>
Subject: Re: [PATCH 0/2] Add PTP support for sama7g5
Message-ID: <20230316172248.7e05016c@kernel.org>
In-Reply-To: <ZBG9ZVjitIT5rMf0@nimitz>
References: <20230315095053.53969-1-durai.manickamkr@microchip.com>
        <ZBGvbuue5e3vR8Fs@localhost.localdomain>
        <cedc50dc-bbfa-d44c-1420-f72acba4bb81@microchip.com>
        <ZBG9ZVjitIT5rMf0@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 13:43:17 +0100 Piotr Raczynski wrote:
> > It is already implemented. Here the scope is to just enable it for sama7g5.
> 
> Also, since commits lack target tree (net-next?) I'm not sure if the
> patches will be picked by bot and tested.

The tree_selection check reports what tree it ended up picking, FWIW
