Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F2C6D23EC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjCaP0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjCaP0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:26:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1381D2EF;
        Fri, 31 Mar 2023 08:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QYTwTqxmMh/uQqXk6w/oXrxdaifToNPKhtTVuaawN4U=; b=l3tJxvZIcaX85ZoHQ1a6ckBJLI
        MMJp8rUhWPxD9GVQeZUoQgHmcv/6WsFdKyhYkkYWpbkteurJV/4/Caj7ZpoeKH1wmF/Rw1pBTLnM3
        a7B4meAOvTRhGdhwGY5DyvpRNoqgPd7iB8347GCBmW68q0/WmvDVnK8qFtVx3e7XjuXc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1piGdb-0092iH-CG; Fri, 31 Mar 2023 17:25:59 +0200
Date:   Fri, 31 Mar 2023 17:25:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] net: phy: introduce phy_reg_field interface
Message-ID: <f59e4f9b-e3a3-44b6-bcd9-0f74edecdc3e@lunn.ch>
References: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
 <d001e708-b5ac-4aa5-9624-4d9ae375d282@lunn.ch>
 <76eb7a6b861ea4b06056552e08c01cc2b378a137.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76eb7a6b861ea4b06056552e08c01cc2b378a137.camel@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am trying to protect the __phy_read_mmd and __phy_read calls, not the
> reg_field->mmd.

You are?

Then why not use phy_read_mmd() and phy_read()?

    Andrew
