Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4516B471641
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 21:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhLKUqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 15:46:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhLKUqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 15:46:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HEl/swM1ZBv7jIUIdHIPZHFW3X0mwM4UGZxkHpmZucA=; b=RzQ037eXHgHcBYA6X8JKhvAVpw
        Fq/lNYVEN3tRY7+4v4lQ7whbrc+nfZCpFBKYQo2s2xWsQfxAhC2mJXmy1PFxxJq9Gx7mJC5x3CEx6
        qUIg2h3HaYJvQbSfkN77TwGnMSSRqesgnpqbmSJwSCCcJSgrKCMr40URioO+7lL5meL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mw9G9-00GHhr-NU; Sat, 11 Dec 2021 21:46:21 +0100
Date:   Sat, 11 Dec 2021 21:46:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/7] ethtool: Add 10base-T1L link mode entry
Message-ID: <YbUOHZKSLtYSn8Kj@lunn.ch>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
 <20211210110509.20970-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210110509.20970-2-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 01:05:03PM +0200, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add entry for the 10base-T1L full duplex mode.
> 
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
