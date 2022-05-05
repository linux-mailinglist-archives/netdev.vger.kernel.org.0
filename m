Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492EF51B4D1
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiEEAuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiEEAuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 20:50:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626C01FA7B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 17:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE89B82A5C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 00:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8DDC385A5;
        Thu,  5 May 2022 00:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651711634;
        bh=UCqFQPbRi+ozVPSlgqRbV8xyfVMhpi4t1rq/Ap5WH7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fzlK1xPUdGWZt26pVI1Z4KXu267/5YL0CxyatCXagI+cZo4ZbXqNoMuRfFz78w0+/
         EIl9BNM3YUkdeoKZjx4Wcouky5vGRkomQR6DRICu2vhmA07qnWr5uagtuA0uvuqCFP
         7+t64Dvco/fksAA40gDKwBsQDS4xtxPSLKamDZDrlN6HUi1V5hjNhHrdommJwZPiWT
         kPB6gEuK+mAAAOzlE0cV8E/nKpYlEsFYTM1EGplMp/yNi2rNuPtBrGvYwJat574G5r
         TIowz0LJ1DSS7j5BcX3hknOPLa9+RKgSFlz4tksqtXnJwhLl18SExyXWJgP7M5IiKR
         zNoV5Fy32LEPg==
Date:   Wed, 4 May 2022 17:47:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Yuiko Oshino <yuiko.oshino@microchip.com>,
        woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 2/2] net: phy: smsc: add LAN8742 phy
 support.
Message-ID: <20220504174713.58ad1111@kernel.org>
In-Reply-To: <YnL0BFPIbRbz9DMY@lunn.ch>
References: <20220504152822.11890-1-yuiko.oshino@microchip.com>
        <20220504152822.11890-3-yuiko.oshino@microchip.com>
        <YnL0BFPIbRbz9DMY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 23:45:40 +0200 Andrew Lunn wrote:
> > +	.suspend	= genphy_suspend,
> > +	.resume	= genphy_resume,  
> 
> Is the white space wrong here, or is it how tabs are displayed in my
> mailer?

It is off, doesn't align when applied either, please fix.
