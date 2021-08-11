Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA33E9797
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhHKSXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:23:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhHKSXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TRGj6dbMSGqJuo7VxARfKcBHrtxIRic/Swrh3n8R1HQ=; b=FqA2X11gyQK+MEJpDWdYCnPv0z
        +kqPkJHc1CvigeD3ZdDaBpTSIcuitwui3fuPJVr1jb8QgWd5FGf7vDSzHHmp8t+q2QmxCwfWYllpz
        henqDrmmnwYtlScLXQVh8OgmbB56rum3KIlkdh9ZdCZESAW2hqn+ozeKLObVsZh4Aic4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDssa-00HAB2-Eo; Wed, 11 Aug 2021 20:23:04 +0200
Date:   Wed, 11 Aug 2021 20:23:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YRQViFYGsoG3OUCc@lunn.ch>
References: <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
 <YQ6pc6EZRLftmRh3@lunn.ch>
 <20191b895a56e2a29f7fee8063d9cc0900f55bfe.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191b895a56e2a29f7fee8063d9cc0900f55bfe.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I hope that using "*-internal-delay-ps" for Mac would be the right option.
> Shall i include these changes as we discussed in next revision of the patch? 

Yes, that seems sensible. But please limit them to the CPU port. Maybe
return -EINVAL for other ports.

     Andrew
