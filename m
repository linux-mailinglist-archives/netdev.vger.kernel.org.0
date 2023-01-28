Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6961B67F8ED
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjA1PBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbjA1PBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:01:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C0D2BEDC;
        Sat, 28 Jan 2023 07:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Csy9YqNIUCJ4ESxJL2rrC/bEpaNlKF+HvgPOCzzxm2Y=; b=WKmgDVy4/R9+BwUbPJFavrnqfD
        AIRiZEPXcidEzue6GktwON2a3sBT3rKbC4J3qZMSTXvgKsoWhcfDsSY8EYDcAxWLWP6Nr9DQ8Aw6J
        ycXIXjKs77lvY4+MGCNhoMDcd1AgdSzPR/Jjk8dwTF/UXi4UsdpvOmNWJ0vSJUvGBIDI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pLmhs-003SBL-QI; Sat, 28 Jan 2023 16:01:28 +0100
Date:   Sat, 28 Jan 2023 16:01:28 +0100
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
Subject: Re: [PATCH net-next v1] net: phy: fix the spelling problem of
 Sentinel
Message-ID: <Y9U4yIWqVR7sJRfg@lunn.ch>
References: <20230128063558.5850-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128063558.5850-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 02:35:57PM +0800, Frank Sae wrote:
>  CHECK: 'sentinal' may be misspelled - perhaps 'sentinel'?
> 
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
