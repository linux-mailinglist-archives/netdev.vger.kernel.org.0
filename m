Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BAC67F8F8
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjA1PLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjA1PLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:11:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075801D91D;
        Sat, 28 Jan 2023 07:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v85GOMI3umlIqXGUkxMlINEutXPTW68C7IrxkBNxC2s=; b=UG/EjOIQvQ6sPfAECvwpT+TNVf
        9oPxxCGmQ1LPkguGOxQRgZEjx6nzr3DO8Vwe42jjUhG5NtPGlaC/MEA3HY/vAHCL+fb+Lbk2ymFy4
        YO8ubG0GWY48c5vdw251T0iCC2mbtyNVVRpKXDrSo2GzzkA6sKSWrC9E5nD0fwYQU2Ng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pLmr1-003SGJ-6H; Sat, 28 Jan 2023 16:10:55 +0100
Date:   Sat, 28 Jan 2023 16:10:55 +0100
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
Subject: Re: [PATCH net-next v2 2/5] net: phy: Add BIT macro for Motorcomm
 yt8521/yt8531 gigabit ethernet phy
Message-ID: <Y9U6/+X+XQK4GYS5@lunn.ch>
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-3-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128031314.19752-3-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 11:13:11AM +0800, Frank Sae wrote:
>  Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet phy.
>  This is a preparatory patch. Add BIT macro for 0xA012 reg, and
>  supplement for 0xA001 and 0xA003 reg. These will be used to support dts.
> 
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
