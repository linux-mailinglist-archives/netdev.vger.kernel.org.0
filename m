Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257BB59ECDB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiHWTux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiHWTui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:50:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF19275F1;
        Tue, 23 Aug 2022 11:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CCT8l4Jdhsxcwji/TezZ/Fu/OlayOt1KuTU85zcfZEQ=; b=t39JR/pXmQeA63Hmxn5waOEGPr
        gwFqebqip2LAbcyXX6WwD5pK3lMT+1kDRCeo4WijkiiLVdzX/KvsSGPsQDooau7LpSxPiF6aEcmD4
        dPD40jdcm//RgAi5YOkqWGEtltHJaxRvxO7n3DKtUVDAFEm8/E6vfmapj8uxqotOhp/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQZ2A-00ENXw-RO; Tue, 23 Aug 2022 20:53:54 +0200
Date:   Tue, 23 Aug 2022 20:53:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.4] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <YwUiQgSGBhbvk7T6@lunn.ch>
References: <20220817112554.383-1-Frank.Sae@motor-comm.com>
 <20220822202147.4be904de@kernel.org>
 <YwTguA0azox3j5vi@lunn.ch>
 <20220823113712.4c530516@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823113712.4c530516@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The user could of changed the pause settings, which are going to be
> > ignored here. Also, you should not assume the MAC can actually do
> > asymmetric pause, not all can. phydev->advertising will be set to only
> > include what the MAC can actually do.
 
> Interesting. Just to confirm - regardless of the two-sided design..
> -edness.. IIUC my question has merit and we need v5?

Yes, phydev->advertising should be take into account.

     Andrew
