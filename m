Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA80665CD4
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbjAKNlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbjAKNlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:41:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7621BEBD
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1cBTgxyMQrZaI1t4GyZXhq5BAZcl2C55ohBYW9hjfVY=; b=UCcDL4sduiGBelJ0pW4o2xA6rm
        GBdXukFE7PgWo4u0yxvo2msQezFV4hFmEfPeZv5CE+Kff4ZzJyrBRR7zDuJ7/55vyc01oe6E+B+4D
        EULjJoTecG+85EiItcHi0slmcGhIlv47bl4qzSKEvRogbyxResSK67r82uSQcicvo0js=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFbKr-001mRD-QZ; Wed, 11 Jan 2023 14:40:09 +0100
Date:   Wed, 11 Jan 2023 14:40:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com,
        edumazet@google.com, michael@walle.cc, pabeni@redhat.com
Subject: Re: [PATCH net-next v3] net: phy: mxl-gpy: fix delay time required
 by loopback disable function
Message-ID: <Y768OYPhiOzkvUxC@lunn.ch>
References: <20230111082201.15181-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111082201.15181-1-lxu@maxlinear.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 04:22:01PM +0800, Xu Liang wrote:
> GPY2xx devices need 3 seconds to fully switch out of loopback mode
> before it can safely re-enter loopback mode.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
