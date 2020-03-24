Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA20191602
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgCXQRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:17:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbgCXQRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 12:17:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l/Zak/7MvBlo35F80/0Qtbwql3wRm7oFjvXS/12eDiw=; b=FVJBHZNyW84huu5klxpaF1peAl
        qJf7UWZbC2O7n1Ja01im2JLjva2xkUOq6y6Ql1vKotDKIjThjjHnipM4DwIFyGVMBTJtql0wBBVug
        gn1IMoBrVHBhmMW2S/8QCpM8xPCMDq+eWlzzRe22MA9BRSafqlzR5UfdSpCZj1Fei09k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGmFH-0003Zd-5t; Tue, 24 Mar 2020 17:17:39 +0100
Date:   Tue, 24 Mar 2020 17:17:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: Re: [PATCH] net: PHY: bcm-unimac: Fix clock handling
Message-ID: <20200324161739.GE14512@lunn.ch>
References: <20200324161010.81107-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324161010.81107-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 04:10:10PM +0000, Andre Przywara wrote:
> The DT binding for this PHY describes an *optional* clock property.
> Due to a bug in the error handling logic, we are actually ignoring this
> clock *all* of the time so far.
> 
> Fix this by using devm_clk_get_optional() to handle this clock properly.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Hi Andre

Do you have a fixes: tag for this?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
