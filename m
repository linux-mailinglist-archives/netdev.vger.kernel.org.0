Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8FFBF400
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfIZNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:25:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfIZNZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=68EUeIcqzm0IDdui4uPgc7+UzIGgJxLM3+5RWzrkNwE=; b=YK1CmwZfwg6eeemCn2ElCGJgdY
        NozcH3EE6/qRLVUs7Fg4CqJ8T+F51fxwBpYzogSQ2sxDV0GQla5QvtMecFwQYLymANLdEn2dXrmyD
        0k4vScol/2OBcc/fTNVEA6r7rYIde5/4xCYZ6VCcU+RuiGygWlvGfg/s+l+rc2qxtTfc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDTlS-0002X1-92; Thu, 26 Sep 2019 15:24:58 +0200
Date:   Thu, 26 Sep 2019 15:24:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Alvaro G. M" <alvaro.gamez@hazent.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: axienet: fix a signedness bug in probe
Message-ID: <20190926132458.GC20927@lunn.ch>
References: <20190925105911.GI3264@mwanda>
 <20190925110542.GA21923@salem.gmr.ssr.upm.es>
 <20190926131811.GG29696@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926131811.GG29696@kadam>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The get_phy_mode() function seem like they lend themselves to creating
> these bugs.  The ->phy_mode variables tend to be declared in the driver
> so it would require quite a few patches to make them all int and I'm not
> sure that's more beautiful.  Andrew Lunn's idea to update the API would
> probably be a good idea.

Hi Dan

I started on it. Once net-next has opened, and 0-day has compile
tested my changes, i will post the code for review.

       Andrew
