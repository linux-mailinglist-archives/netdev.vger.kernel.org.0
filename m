Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654EF6AE152
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCGNvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCGNvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:51:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E486546A;
        Tue,  7 Mar 2023 05:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u0VybxYH9pOYT4pDKIJKdf8R678kxMXuEhS3QNEYi5U=; b=AVusjUEMSOv463mcsmTJwJ9TDk
        1WyDA5kgn1W0yrajU2nRAUhymG4g3EaSX2rd17NhIqNHJ1RL1cwgc3ErUqriflOD248EdS9UUgm4F
        xmFssmLZKEqhbQ1sEum+d5yheKlApa9yl8jfM7BxovbsttXFaacwhXYz3wGSnm2P95GU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZXh1-006fJ2-65; Tue, 07 Mar 2023 14:49:27 +0100
Date:   Tue, 7 Mar 2023 14:49:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     sean.anderson@seco.com, davem@davemloft.net, edumazet@google.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com,
        tobias@waldekranz.com
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <684c859a-02e2-4652-9a40-9607410f95e6@lunn.ch>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <20230307112307.777207-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307112307.777207-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:23:07PM +0100, Michael Walle wrote:
> > To prevent userspace phy drivers, writes are disabled by default, and can
> > only be enabled by editing the source.
> 
> Maybe we can just taint the kernel using add_taint()? I'm not sure if
> that will prevent vendors writing user space drivers. Thoughts?

I was thinking about taint as well. But keep the same code structure,
you need to edit it to enable write.

    Andrew
