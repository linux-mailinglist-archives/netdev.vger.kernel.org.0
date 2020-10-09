Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFE7289942
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391859AbgJIUKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391461AbgJIUIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 16:08:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BDBB2053B;
        Fri,  9 Oct 2020 20:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602274130;
        bh=+b0UCmaVjCJ5quEyA7IpdwMvpZ6JEzMZlAcmNpTuLhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QyOcojAY7sJxrU8c4l1eyv/lWzJ9W80BxOHse72GrnXQe0mOzQaL84GO6jxBRa9Fl
         DZ1uWHRpvJk4c0nl5bUqwWKfANgZGG/Bhr9+1qnlXq4ndjEyJeh6D7kaix5ysk6bbr
         wBvmS4lSrN7StpAI0QtoHbUyCW8JaAw8r7vR4NUA=
Date:   Fri, 9 Oct 2020 13:08:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: add ksz9563 to ksz9477
 I2C driver
Message-ID: <20201009130848.0ed59601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007132002.GG56634@lunn.ch>
References: <20201007093049.13078-1-ceggers@arri.de>
        <20201007132002.GG56634@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Oct 2020 15:20:02 +0200 Andrew Lunn wrote:
> On Wed, Oct 07, 2020 at 11:30:49AM +0200, Christian Eggers wrote:
> > Add support for the KSZ9563 3-Port Gigabit Ethernet Switch to the
> > ksz9477 driver. The KSZ9563 supports both SPI (already in) and I2C. The
> > ksz9563 is already in the device tree binding documentation.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
