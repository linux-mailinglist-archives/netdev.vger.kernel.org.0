Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9767F903
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbjA1PP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjA1PP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:15:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF5526861;
        Sat, 28 Jan 2023 07:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VIcOhcEjFjMz8RBMwdrZjsPXTXPMkg4e8tUenoMMR3s=; b=AIpfrAy//7ig9R9xoH5xxZpDOQ
        UWa0Iy5NtOQtDPg/gW5VOrAjWzK/JOeQmZQ0XPxMex25ano/6oDbOafD4a91R0j7Ndmq6akaYLKfD
        w8//1Rr0PyPMhelwmS4OsyNJ67RImr6f4G62C37euFhUbXDHx9LSNjis2JZhSVG8nJIM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pLmvi-003SHw-I3; Sat, 28 Jan 2023 16:15:46 +0100
Date:   Sat, 28 Jan 2023 16:15:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/5] net: phy: Add dts support for Motorcomm
 yt8521 gigabit ethernet phy
Message-ID: <Y9U8Inha2WfDpNL2@lunn.ch>
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-4-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128031314.19752-4-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 11:13:12AM +0800, Frank Sae wrote:
>  Add dts support for Motorcomm yt8521 gigabit ethernet phy.
>  Add ytphy_rgmii_clk_delay_config function to support dst config for
>  the delay of rgmii clk. This funciont is common for yt8521, yt8531s
>  and yt8531.
>  This patch has been verified on AM335x platform.
> 
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>

Apart from the implementation of the odd TX delay default:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
