Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CDD67F936
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjA1Pfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjA1PfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:35:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7718B2A171;
        Sat, 28 Jan 2023 07:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=x2AV/SIqqolUXWwxzjPvgVACWpAdAwwYp2eB0cTygQE=; b=enr7+6h4PrdSz+7eDeu3BddXOO
        vxu9JK1PXSaCo70D6hk0FOqALdIszkEBif6KLXjz4x773bZylj+aY4ybmxcDAgPDOSDoBkG6HW/bZ
        83/Aev4klm+xWFe4eaCPKFcN7Hd+HVVLvbibFZTviT6R6Js4813LaMJq6962p5RZOhtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pLnEM-003SMJ-Mu; Sat, 28 Jan 2023 16:35:02 +0100
Date:   Sat, 28 Jan 2023 16:35:02 +0100
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
Subject: Re: [PATCH net-next v2 4/5] net: phy: Add dts support for Motorcomm
 yt8531s gigabit ethernet phy
Message-ID: <Y9VApukAv7mLzDJI@lunn.ch>
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-5-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128031314.19752-5-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 11:13:13AM +0800, Frank Sae wrote:
>  Add dts support for Motorcomm yt8531s gigabit ethernet phy.
>  Change yt8521_probe to support clk config of yt8531s. Becase
>  yt8521_probe does the things which yt8531s is needed, so
>  removed yt8531s function.
>  This patch has been verified on AM335x platform with yt8531s board.
> 
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
