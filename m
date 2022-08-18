Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A552C597B6C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242719AbiHRCTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiHRCTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA97C6E8B6;
        Wed, 17 Aug 2022 19:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30FEF61448;
        Thu, 18 Aug 2022 02:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B61C433D7;
        Thu, 18 Aug 2022 02:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660789157;
        bh=lDCYO3+leCT8O9ybDEmYfB2gO6BNT27vpk8WTvXTE68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PIxCpluW56J3ci43B5Idxcpnog4TH/Wh+qfzV8KSTfxi9NfY8ZHuCCXzv50aEfwZK
         WmzrO9yJu9dHH95s44SV7gEAYJkYrAd2I7OPJ2VXUNTJUSo1f+bm24JTgiVb8fukmt
         /Nyik1tynZP5hFdi6EEyVXlJ+Wh1Wv8FBSoUCsQI7WyhWSICA/4Hzz3GBwN9V1dz+d
         iFCaCfl9G8+tV6k6fDkTzJ9hyq+tgZ+PULuMKU6SVjt+8901k0846yat2MabYwwtbT
         IbOGUrp2+/nMkIvVM8gEbvHAwSq4F4r767ewWs9l/JY7y6mkSdMjqK52XIP1/TzvgA
         uQkSwuENpWBWA==
Date:   Wed, 17 Aug 2022 19:19:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Beniamin Sandu <beniaminsandu@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Message-ID: <20220817191916.6043f04d@kernel.org>
In-Reply-To: <Yv2UMcVUSwiaFyH6@lunn.ch>
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
        <20220817085429.4f7e4aac@kernel.org>
        <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
        <20220817101916.10dec387@kernel.org>
        <Yv2UMcVUSwiaFyH6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 03:21:53 +0200 Andrew Lunn wrote:
> > > I had a quick look and couldn't see anything obviously wrong, but then
> > > I'm no expert with the hwmon code.  
> > 
> > That makes two of us, good enough! :) Thanks for taking a look.  
> 
> It would of been nice to Cc: the HWMON maintainer. His input would of
> been just as valuable as a PHY Maintainer.

Fair point, I lazy'd out and only checked that everyone get_maintainers
asks for was CCed. Perhaps it'd be worth extending the hwmon's keyword
match to trigger on the structs or the constants if it matters.
Adding hwmon@ to CC just in case.
