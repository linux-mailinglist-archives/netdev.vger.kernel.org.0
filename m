Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A851CCB91
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgEJOdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:33:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbgEJOds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DHKL4VuhUaAt2s9d6dYgP/J17Fuwz8VOM/wgyOYlkH4=; b=5wRF39VxQgpdsDZ6UBx0OIiEAo
        Z+grIcnDhZ+tIVQ9KChnHL7j07IqnO2jFlhens9LrGd7sNpWX+pBZW0guEyMRNTAeSsyyj8/ujXT4
        ZNjAn1cN9yS7uoB3lyIc4zP6oXEzUSQXq3hPfenLNacN9e5WO7FJHkllwEBcva8svr/c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXn1X-001i7x-42; Sun, 10 May 2020 16:33:47 +0200
Date:   Sun, 10 May 2020 16:33:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/4] net: phy: broadcom: add bcm_phy_modify_exp()
Message-ID: <20200510143347.GH362499@lunn.ch>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509223714.30855-3-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 12:37:12AM +0200, Michael Walle wrote:
> Add the convenience function to do a read-modify-write. This has the
> additional benefit of saving one write to the selection register.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
