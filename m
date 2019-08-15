Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BEC8EBA2
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbfHOMh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:37:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34622 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfHOMh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 08:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=792IXvfPHM5EwHA00LuEq/FkFQf4nC0DJXbr97dsd2E=; b=CQznTVu+17cP/dg1cZQ1u1gw/s
        e3VsKUMCgY45GH7kGYx9jh6g0fd0CfrADShI4bkg1eGRrC/cahOywcSyA6+N7JmULYti2RuBIFxqY
        Ti0dnyNastWDWVm+f7+4HeMy4bdrNKTKGBrB3cUWEbyMHmdHhRmtXpfClBWl35XyuiNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hyF0N-0008GB-DE; Thu, 15 Aug 2019 14:37:23 +0200
Date:   Thu, 15 Aug 2019 14:37:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: read MII_CTRL1000 in
 genphy_read_status only if needed
Message-ID: <20190815123723.GB31172@lunn.ch>
References: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 01:15:19PM +0200, Heiner Kallweit wrote:
> Value of MII_CTRL1000 is needed only if LPA_1000MSFAIL is set.
> Therefore move reading this register.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
