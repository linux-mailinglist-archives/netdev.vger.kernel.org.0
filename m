Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAFB69986F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBPPJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjBPPJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:09:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16F556EE8;
        Thu, 16 Feb 2023 07:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AT8Mg5rZaMNiVJ6QIjhnsAbcAFktls+xpfZCh3HOjL8=; b=vaeT1NQ6ThWoPnGzrx14wnwGxe
        QJHSiQ5T5j9JXVpxNnkyLt1EYenfA4rqZhemPTGZWFjVfgD5+Cq+2tvUkLnq/VetfoXaAhQisS1zH
        X4GjcrRcSqidAQ9TAp7thyJCQgWRUvPLi1ULY+A0lrxrtf6jQAEYV0cI3VUig/audgRU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSfsN-005C1d-3B; Thu, 16 Feb 2023 16:08:47 +0100
Date:   Thu, 16 Feb 2023 16:08:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     enguerrand.de-ribaucourt@savoirfairelinux.com,
        woojung.huh@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        edumazet@google.com, linux-usb@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Message-ID: <Y+5G/yc7UB+ahylb@lunn.ch>
References: <cover.1676490952.git.yuiko.oshino@microchip.com>
 <b317787e1e55f9c59c55a3cf5f9f02d477dd5a59.1676490952.git.yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b317787e1e55f9c59c55a3cf5f9f02d477dd5a59.1676490952.git.yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 07:20:53AM -0700, Yuiko Oshino wrote:
> Move the LAN7800 internal phy (phy ID  0x0007c132) specific register accesses to the phy driver (microchip.c).
> 
> Fixes: 14437e3fa284f465dbbc8611fd4331ca8d60e986 ("lan78xx: workaround of forced 100 Full/Half duplex mode error")

I would not say this is a fix which needs putting into stable. The
architecture is wrong to do it in the MAC driver, but i don't think it
causes real issues?

So please submit this to net-next, not net.

   Andrew
