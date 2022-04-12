Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03CF4FE666
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356159AbiDLRAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiDLRAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:00:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B085F4DA;
        Tue, 12 Apr 2022 09:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ca/PobVuuugLsLlVKWC9+miV8+H16um9gFhD916Locc=; b=Tvy81zNTMlR4rVAWDi+negn2Nv
        1y1W6DxynCxSlSj5Xtf0D7vy/w0Baf1+m6LPB79oaRU4Sxyq0F3/0GzBM7VlL9dyadnvfuMF6BKhe
        lXPRI1S9aiSVoUw+0/A6/1ovxj+u0G7w+ogWG7Ydcq5yoc9RVAQl/AGuiytV3aQkktWg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neJpl-00FUFn-IG; Tue, 12 Apr 2022 18:57:41 +0200
Date:   Tue, 12 Apr 2022 18:57:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [Patch net-next 2/3] net: phy: LAN87xx: add ethtool SQI support
Message-ID: <YlWvhatIIPxurgiO@lunn.ch>
References: <20220412063317.4173-1-arun.ramadoss@microchip.com>
 <20220412063317.4173-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412063317.4173-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 12:03:16PM +0530, Arun Ramadoss wrote:
> This patch add the support for measuring Signal Quality Index for
> LAN87xx and LAN937x T1 Phy. It uses the SQI Method 5 for obtaining the
> values.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
