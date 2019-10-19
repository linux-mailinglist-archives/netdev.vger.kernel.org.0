Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB769DDB7A
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfJSXqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 19:46:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfJSXqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 19:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y/IIk71iGqijigb+f4kG5p+2zvpKfOGln9jP+Gs0yiY=; b=TcQyowABaOW5fybIp1Bc55Zz7m
        RTvouIc41epvcSsR36jzfsbRCKDVUUy3GZMJ1+PPaLGHN+i9enmRFL1I4idSGaz54Vvz5bLGlDwc5
        s9sBq7OwJBTlhGklqM1+BjYsiLnDZunRuAy2i/cy/7HzcuGgEYVhufLN4dNEZrh6Ym0k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLyA6-0007Jj-Di; Sun, 20 Oct 2019 01:29:30 +0200
Date:   Sun, 20 Oct 2019 01:29:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 1/3] ethtool: correctly interpret bitrate of 255
Message-ID: <20191019232930.GA28013@lunn.ch>
References: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:31:13PM +0100, Russell King wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> A bitrate of 255 is special, it means the bitrate is encoded in
> byte 66 in units of 250MBaud.  Add support for parsing these bit
> rates.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
