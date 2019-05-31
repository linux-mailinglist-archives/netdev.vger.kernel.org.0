Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B711E30DFD
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfEaMVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:21:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbfEaMVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OICwzJUG9ru3GANBUzmVbH105fpmRRWmaVDgmJDGPbs=; b=dCWXbd/Mb8MzX3pnUtUoZmyYwD
        eFsswQtjy7JSX/9I/S3CGod0PyKv/5n7QW+KVhgmi3cdQsoec6775cL9C6FUoL3QLbtCie35BtfGd
        hlK8l3yuNmSsU7ok3bsIlA+sVrHra9CJ2EO0B/3Ps7z1AY8scoNnTlXt8FPali1OrDAk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWgWn-0005Ax-JY; Fri, 31 May 2019 14:20:57 +0200
Date:   Fri, 31 May 2019 14:20:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: phy: support C45 phys in SIOCGMIIREG/SIOCSMIIREG
 ioctls
Message-ID: <20190531122057.GA19572@lunn.ch>
References: <20190531074727.3257-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531074727.3257-1-nikita.yoush@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:47:27AM +0300, Nikita Yushchenko wrote:
> This change allows phytool [1] and similar tools to read and write C45 phy
> registers from userspace.
> 
> This is useful for debugging and for porting vendor phy diagnostics tools.
> 
> [1] https://github.com/wkz/phytool

Hi Nikita

Russell King submitted a similar patch a couple of days ago.

https://patchwork.ozlabs.org/patch/1102091/

Since he was first, we should probably take his, once he respins the
series.

Florian: Could you take a second look at
[net-next,1/4] net: phylink: support for link gpio interrupt
https://patchwork.ozlabs.org/patch/1102090/

Everything else in that patchset is good to go.

	Thanks
	   Andrew
