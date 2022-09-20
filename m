Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59DC5BEF87
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiITV7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiITV7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:59:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BA212ABE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90850CE1BAF
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 21:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2756C433D6;
        Tue, 20 Sep 2022 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663711186;
        bh=IGNjdFrkFFr5bt4eAj59wt4gAB9+uFvgzCSRffxKkF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mR596QSe9RKq9SecrYenfcNSH8RkPjoZfOyuv+vuSlaSKfv4IF2ZJiJqfoipq18Ip
         k6Dch8fFdF8tCQCZYMUy4i0C8gnXbUi9GyajIYXUx16wQWMEQCrtN4k066iGHJ+NJk
         Fb8LysMbCvatVCm7PI4mYeiFRAK/sRzwoIBsWZdXTSEMyMCFzJHnayRSedGT10GiDJ
         sE4BBXZXiZELK66OUch2skQbP/fSrj33fA7ccWtplaUNkgtijWeqUy8+bmyxfg5+kB
         1pswfugPr1vZ7VK4rpbv2UF4ZxLsVFHjVpGp6y64iJARW/eVLDLD0XiTWF3xClwkSa
         fPGjcJv0l16vQ==
Date:   Tue, 20 Sep 2022 14:59:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <hkallweit1@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Chunhao Lin <hau@realtek.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [PATCH net-next v4] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Message-ID: <20220920145944.302f2b24@kernel.org>
In-Reply-To: <20220915144807.3602-1-hau@realtek.com>
References: <20220915144807.3602-1-hau@realtek.com>
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

On Thu, 15 Sep 2022 22:48:07 +0800 Chunhao Lin wrote:
> rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> rtl8168h is connected to rtl8211fs mdio bus via its eeprom or gpio pins.
> 
> In this patch, use bitbanged MDIO framework to access rtl8211fs via
> rtl8168h's eeprom or gpio pins.
> 
> And set mdiobb_ops owner to NULL to avoid increase module's refcount to
> prevent rmmod cannot be done.
> https://patchwork.kernel.org/project/linux-renesas-soc/patch/20200730100151.7490-1-ashiduka@fujitsu.com/

Heiner, Andrew, good?
