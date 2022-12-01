Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A8263E96D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiLAFsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLAFsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:48:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F93D2228C;
        Wed, 30 Nov 2022 21:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F057AB81E12;
        Thu,  1 Dec 2022 05:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4FEC433C1;
        Thu,  1 Dec 2022 05:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669873694;
        bh=S83IUJvMU6D7/rh2IlJZMaM/frPC2iCsAaOgXAhdmks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fx9R1RssswyJTHx3VWTpNB2wTsE2+kZBhVATjkaVI/vaCm3m9yvFjES3/WiaeQHaK
         aoi5OofNqCi8TQrwpnG83a+etH/p5pyYxIsd+sag6BtENvxQznlwriZgJK3QyyaqeZ
         F/18hPnM3DqT9Gv4+VtXbWvMyMTSTXXTuZMcQO6DWmK2ZPCecXatm+B9+y6qZNQ/NY
         YxAhmb4UL/jU0IVT1XyHpjDDmjx+SdtlrfDhMdYCggV8Xzx9Kzkpamuf0vRTZ2PlTn
         pxFhtZRU06YeuILV4Dibrzxo1NqNOMlOERFER8pQojGJseLc1GRTBRiQFgK9J2RJho
         wIBbMAKPLLDHA==
Date:   Wed, 30 Nov 2022 21:48:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chukun Pan <amadeus@jmu.edu.cn>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: motorcomm: change the phy id of yt8521 to
 lowercase
Message-ID: <20221130214813.1026c727@kernel.org>
In-Reply-To: <20221129080005.24780-1-amadeus@jmu.edu.cn>
References: <20221129080005.24780-1-amadeus@jmu.edu.cn>
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

On Tue, 29 Nov 2022 16:00:05 +0800 Chukun Pan wrote:
> The phy id is usually defined in lower case, also align the indents.

does not apply, please rebase on netdev/net-next/main and repost.
