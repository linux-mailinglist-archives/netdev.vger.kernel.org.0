Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB9741836F
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhIYQuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 12:50:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhIYQuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 12:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AO7nZEoX1Ce080rrF77oQrUGzsVqgA/vEiDcOWCs+uw=; b=heAbR6405Blg3IbJTfYTQ+FdsK
        4odDXE4Fats9E4AfcH/R+YB4QuykT8GYJLub5J7LACpO6hVt3aCSi2LN0FXBl+NqPAPb9DVnr3O4/
        quSAD+sDVtPgmdfLVF4U9+C4Z6cx05PHr83qhp7s1uXv1l1khLnp2CeoVYPqTDpyWpHQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUAqu-008Dxc-DW; Sat, 25 Sep 2021 18:48:40 +0200
Date:   Sat, 25 Sep 2021 18:48:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: bgmac-platform: handle mac-address deferral
Message-ID: <YU9S6ITeQCRJAAJv@lunn.ch>
References: <20210925113628.1044111-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925113628.1044111-1-mnhagan88@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 11:36:27AM +0000, Matthew Hagan wrote:
> This patch is a replication of Christian Lamparter's "net: bgmac-bcma:
> handle deferred probe error due to mac-address" patch for the
> bgmac-platform driver [1].
> 
> As is the case with the bgmac-bcma driver, this change is to cover the
> scenario where the MAC address cannot yet be discovered due to reliance
> on an nvmem provider which is yet to be instantiated, resulting in a
> random address being assigned that has to be manually overridden.
> 
> [1] https://lore.kernel.org/netdev/20210919115725.29064-1-chunkeey@gmail.com
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
