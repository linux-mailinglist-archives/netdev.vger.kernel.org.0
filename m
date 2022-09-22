Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4314F5E574C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIVA1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIVA1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:27:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9B19E6B2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B68DEB82856
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4669AC433D6;
        Thu, 22 Sep 2022 00:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663806428;
        bh=bBrd6qaVfzBZ82TGJ4/3yhTFzZOwl6fsovfp8STkEj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZrLo0OYzBGi+KhItuwLiamahsqCFoQsc8wb5go0KSx/S9KmH02vQhjLZW0B+l5WQ2
         khMwIlbp76vZqGzvsLpIo7fM8JmcEXVDkoG9OA1Curm4woxRiyzYYrjlU5C8szzh4p
         oRIPUyr1elXzXWTcA3UtUXdeaNbAJA+DWJBfHlpg9MEVGB3g/kfLJf/kZ9Q9BpPRf1
         NBgrrf92/ky7qSUmLaNCqmWZx/W9vwYkz9l52Q7zOSase/+PeGYDedcpuUZmwTTF1E
         zfE+7w8lSMJhJQuDtkmFxtiCgPuGkc/wRKHAsMjRkBTwHjWJcl8U3EJ1v3yknodzN1
         eOobc/MeIsvog==
Date:   Wed, 21 Sep 2022 17:27:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <hkallweit1@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Chunhao Lin <hau@realtek.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [PATCH net-next v4] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Message-ID: <20220921172707.2b1399cb@kernel.org>
In-Reply-To: <20220920145944.302f2b24@kernel.org>
References: <20220915144807.3602-1-hau@realtek.com>
        <20220920145944.302f2b24@kernel.org>
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

On Tue, 20 Sep 2022 14:59:44 -0700 Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 22:48:07 +0800 Chunhao Lin wrote:
> > rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> > rtl8168h is connected to rtl8211fs mdio bus via its eeprom or gpio pins.
> > 
> > In this patch, use bitbanged MDIO framework to access rtl8211fs via
> > rtl8168h's eeprom or gpio pins.
> > 
> > And set mdiobb_ops owner to NULL to avoid increase module's refcount to
> > prevent rmmod cannot be done.
> > https://patchwork.kernel.org/project/linux-renesas-soc/patch/20200730100151.7490-1-ashiduka@fujitsu.com/  
> 
> Heiner, Andrew, good?

Well, we need Hainer or Andrew to ack, I'm marking this patch 
as Deferred until such endorsement is obtained.
