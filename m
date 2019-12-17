Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C021230C0
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfLQPqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:46:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57716 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfLQPqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lN4o+C+7O3mxm6/RSCNWkpyAANZLrg/HrBhkODEoCdg=; b=lrC7ez7xo8jCJm3JKPH5RjuPtH
        cmHjLhLb+KR6eBK9R6P3l3AxDQ6y8TiB+Y84w3b7gX1iB2u5RjcsUkIhYrWDcyEgNtUzKB0hGRsCx
        QVBoV3Nn3+5hDAQ36FrzgyYEGLcL41dvBC+z+lw/qj4fLg+QZcwpLe+coXW9Mq6rdx9c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihF3D-0002lk-Mv; Tue, 17 Dec 2019 16:46:19 +0100
Date:   Tue, 17 Dec 2019 16:46:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 07/11] net: phy: marvell: use positive logic for
 link state
Message-ID: <20191217154619.GO17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4V-0001z2-O5@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4V-0001z2-O5@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:31PM +0000, Russell King wrote:
> Rather than using negative logic:
> 
> 	if (there is no link)
> 		set link = 0
> 	else
> 		set link = 1
> 
> use the more natural positive logic:
> 
> 	if (there is link)
> 		set link = 1
> 	else
> 		set link = 0
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
