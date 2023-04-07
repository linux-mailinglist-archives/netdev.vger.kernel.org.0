Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06986DB2A0
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjDGSPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDGSPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:15:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E242D6A53;
        Fri,  7 Apr 2023 11:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a3Y12OpLPkFr5Y01kdUj0Z1lgfj73ew18jkEUMw4oSE=; b=aNbGZ6SljA7nUPH3MwVfsH7SeA
        Qmmpxs4Lb/OOeqK9pgpKXSEuFnril667PgSqVwsuurDp1zuagAsD7f+LnG9TTPbuFn4qoU1JMBh9J
        z1OcHf+nuU+0qoXFnjUGwDQeKKeVfoAaRBSB97s8J4rXcPugxZiDkNUlY/+h1UZoHbfc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkqc0-009kef-Ak; Fri, 07 Apr 2023 20:15:00 +0200
Date:   Fri, 7 Apr 2023 20:15:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
Message-ID: <b9bd7373-f544-45fc-be3b-736d20f0841a@lunn.ch>
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
 <cf1dd1a9-2e2d-473e-89f0-8e2c51226dfe@lunn.ch>
 <104c1190-cd18-d7c9-7b27-af367ac539bb@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104c1190-cd18-d7c9-7b27-af367ac539bb@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do you need to disable interrupts? I suppose the real question is, is
> > it guaranteed phy_disconnect() is called before the driver is removed?
> The MAC driver should call phy_disconnect() when it is removed. Also, the
> user should not be able to remove the PHY driver if is in uses.

That was what i was thinking. But i've never unloaded a PHY driver, so
i've no idea what actually happens.

     Andrew
