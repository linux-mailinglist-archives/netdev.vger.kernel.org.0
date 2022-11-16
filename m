Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC562C612
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiKPRPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiKPRPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:15:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FF158BDE;
        Wed, 16 Nov 2022 09:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F08EB81DEA;
        Wed, 16 Nov 2022 17:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9122EC433D6;
        Wed, 16 Nov 2022 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668618936;
        bh=PrNayE18WdJpr6ek/Bor8UULn1wmquQBj0Nmi5bKC1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bUzSmWpezVqfWyumZ7fieAeIRA7Abj++hxfxPG02XH/IOujqqtcmo9p44wfT813Tx
         WgP50dRK7qn+/379exBwvdbZbX1vMfZs5kMBoiK4awDV2x7ww9ZQduP+o0eRkRH7WY
         ozYDuUKMUCSO/6MwH+oMKMrxSDz+7oyPD+eefKY2NcEl+7LvqujKqr+1q9pNxIWMZz
         PlLwTMcK25y5rnfWc9FJcLvgQ8jSXO10tYtYOzoaQWiJqflJjWDw5r1tDK4IEr4w/h
         94+VOcbBWqbN1/gD+xtMoxxaxqqHPptxzQvy9CY+2AGEvqJ/6N/MCv0JI6DD5EsYH+
         VTN5e4AtdqEUA==
Date:   Wed, 16 Nov 2022 09:15:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux@armlinux.org.uk, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2] net:macb: driver support acpi mode
Message-ID: <20221116091534.42ae8045@kernel.org>
In-Reply-To: <20221114114126.1881-1-xiaowu.ding@jaguarmicro.com>
References: <YxYuRaXxtyMIF/A6@lunn.ch>
        <20221114114126.1881-1-xiaowu.ding@jaguarmicro.com>
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

On Mon, 14 Nov 2022 19:41:26 +0800 xiaowu.ding wrote:
> From: Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
> 
> Cadence gem driver suuport acpi mode. Current the macb driver
> just support device tree mode.So we add new acpi mode code with
> this driver.

Does not apply cleanly. Rebase on top of net-next and put 
[PATCH net-next v3] in the subject, please.
