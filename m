Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD9514009
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345010AbiD2BLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343714AbiD2BLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:11:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B44B4BBB0;
        Thu, 28 Apr 2022 18:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=am+pp1n2tR7U1f2aW4eLg9zcq/bG7wx/3AAqhSrs4UI=; b=U72M/kfhKhhGo/IL+Y5OjkRKA1
        wkapVPbgcTecThgS/KDDY9bB+KPbjP7BSn1GStt7xJ0K/BLVAcptFzXZtJkT33YyqWsR1/ACKZGA5
        bwmfrPSa5yECjrgSYsjXjenJwDslEaWPapNUCgJGYPA02GGIKEVfOaEmgHPEBmigGvps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkF7C-000P1c-F2; Fri, 29 Apr 2022 03:08:10 +0200
Date:   Fri, 29 Apr 2022 03:08:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, Shravya Kumbham <shravya.kumbham@xilinx.com>
Subject: Re: [PATCH 1/2] net: emaclite: Don't advertise 1000BASE-T and do
 auto negotiation
Message-ID: <Yms6evfMxr1JZ2eZ@lunn.ch>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1651163278-12701-2-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651163278-12701-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 09:57:57PM +0530, Radhey Shyam Pandey wrote:
> From: Shravya Kumbham <shravya.kumbham@xilinx.com>
> 
> In xemaclite_open() function we are setting the max speed of
> emaclite to 100Mb using phy_set_max_speed() function so,
> there is no need to write the advertising registers to stop
> giga-bit speed and the phy_start() function starts the
> auto-negotiation so, there is no need to handle it separately
> using advertising registers. Remove the phy_read and phy_write
> of advertising registers in xemaclite_open() function.
> 
> Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
