Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26C264E6A3
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiLPEU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 23:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLPEUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA1FF2B;
        Thu, 15 Dec 2022 20:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6135EB81C5F;
        Fri, 16 Dec 2022 04:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8DDC433D2;
        Fri, 16 Dec 2022 04:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671164419;
        bh=UV7EttHWMJIZuVOJ0edOTWjFGZkaDxECI1t+V3hmbWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mINiUs5Hcqf25JkuLCB7EQp4WpQgpQXUDZ1DyiisfTECwgOslC0Yxm5biRN+FgRnb
         PXLzuiTvVilRHGOzF1M+LMa6tvE83UB4BjmxdMOX7Y3zqOshO0T3IEelygPSXxKfwx
         iFrAFpa0ImIoCd6JtBibbMAqjiEDpeVdZ7ZxZSkzrtloxWkEmleSjaP5xWfW+X4Vjq
         ag6pvEHWHrnwqgZsG7RuWy7OZ6qqFd/jkSD0U14FBFjl0DbGVlLmXgoTT+NR8Nv14U
         1DtGp4i9vFqSYrfNCs95RASdroJ3JHlnw3Xvr9UG/rFsIcqvZmVC5Oqhp+2leAq1dO
         wSrx8OHxaUb5Q==
Date:   Thu, 15 Dec 2022 20:20:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20221215202017.4432ef25@kernel.org>
In-Reply-To: <20221215144536.3810578-1-lukma@denx.de>
References: <20221215144536.3810578-1-lukma@denx.de>
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

On Thu, 15 Dec 2022 15:45:34 +0100 Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent.
> 
> For example mv88e6185 supports max 1632 bytes, which is now in-driver
> standard value. On the other hand - mv88e6250 supports 2048 bytes.
> 
> As this value is internal and may be different for each switch IC,
> new entry in struct mv88e6xxx_info has been added to store it.

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.
