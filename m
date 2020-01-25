Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDA91497E1
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgAYVF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 16:05:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgAYVF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 16:05:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rXIsDSjvBRJPY7sgoaos1PgdMBf/Hm8O/MfyenIDSWQ=; b=Zj+B3O+sfM8ZtDxinO/YcfLxko
        yK7CDhEqdcrQpiXZx52lxq7gO2ctW3Xbbt6mLnAQYHHd4VPaFdThxh6s25+tWYV9mO2yVLTB/Ntl3
        n7ImZAxeGFnMIMLJ0mZWjL1b2lOSXLkUP5XPhqcS72Q0S3Qcqhnhx0qdLZ4Aht3I49bY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivSco-0007q7-Gx; Sat, 25 Jan 2020 22:05:50 +0100
Date:   Sat, 25 Jan 2020 22:05:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Message-ID: <20200125210550.GH18311@lunn.ch>
References: <20200125051039.59165-1-saeedm@mellanox.com>
 <20200125051039.59165-12-saeedm@mellanox.com>
 <20200125114037.203e63ca@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125114037.203e63ca@cakuba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 11:40:37AM -0800, Jakub Kicinski wrote:
> On Sat, 25 Jan 2020 05:11:52 +0000, Saeed Mahameed wrote:
> > From: Aya Levin <ayal@mellanox.com>
> > 
> > Add support for low latency Reed Solomon FEC as LLRS.
> > 
> > Signed-off-by: Aya Levin <ayal@mellanox.com>
> > Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> This is kind of buried in the midst of the driver patches.
> It'd preferably be a small series of its own. 
> Let's at least try to CC PHY folk now.

Thanks Jakuv

> Is this from some standard?

A reference would be good.

I assume the existing ETHTOOL_LINK_MODE_FEC_RS_BIT is for Clause 91.
What clause does this LLRS refer to?

Thanks
	Andrew
