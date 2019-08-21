Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4696EED
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 03:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfHUBam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 21:30:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfHUBal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 21:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n9NfRrNjW9ZmPNGYlS0pnekVjreVKm7SkH9+1Fb6KgY=; b=RTLAS8/vzzJ4TlTtwyLt5dcpzK
        P6eP+u76mLoL9zNoLZOyDs8/FiNMksxWcbLOwH2bKf2NdJu6eqbjUpbyO6nptuDi1Q+ORcybIYRig
        gxlRebC74hbgKzStpmS7DcN64y0gZYdVCB21mqertqNHhfHXFa20W5ri6PBHXo69wCbU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0FSO-0001jY-CG; Wed, 21 Aug 2019 03:30:36 +0200
Date:   Wed, 21 Aug 2019 03:30:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Charles.Hyde@dellteam.com
Cc:     linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        gregkh@linuxfoundation.org, Mario.Limonciello@dell.com,
        oliver@neukum.org, netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [RFC 3/4] Move ACPI functionality out of r8152 driver
Message-ID: <20190821013036.GC4285@lunn.ch>
References: <1566339738195.2913@Dellteam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566339738195.2913@Dellteam.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 10:22:18PM +0000, Charles.Hyde@dellteam.com wrote:
> This change moves ACPI functionality out of the Realtek r8152 driver to
> its own source and header file, making it available to other drivers as
> needed now and into the future.  At the time this ACPI snippet was
> introduced in 2016, only the Realtek driver made use of it in support of
> Dell's enterprise IT policy efforts.  There comes now a need for this
> same support in a different driver, also in support of Dell's enterprise
> IT policy efforts.
> 
> Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>
> Cc: Mario Limonciello <mario.limonciello@dell.com>
> Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/net/usb/r8152.c | 44 ++++-------------------------------------
>  lib/Makefile            |  3 ++-

Hi Charles

I think your forgot to add the new files?

  Andrew
