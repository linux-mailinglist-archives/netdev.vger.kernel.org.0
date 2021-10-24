Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9793438B8D
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJXSxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:53:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232099AbhJXSxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WgYCSgQH0fqNh/JtYYcfd2rKvQYA3UM+wgdq1vzdV18=; b=G0d/9v3k7mqVkfmZrjBvOVzjX0
        zqYxyo529r9npd+tYEEwl53tZ47ZCPLT9F2pZHIfpchm/OEIkgrdRXhLxy1q2yHp1O01xGXT95qg+
        oTEAs9o14WVkPQRmqGzvJFGzBd+jo3MPEdX1UeSXXxxV7U4YFFwPPeXwrTDx3Peoc4Ng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiZx-00Ba7Q-F0; Sun, 24 Oct 2021 20:50:45 +0200
Date:   Sun, 24 Oct 2021 20:50:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org
Subject: Re: [net-next PATCH] net: convert users of bitmap_foo() to
 linkmode_foo()
Message-ID: <YXWrBZJGof6uIQnq@lunn.ch>
References: <20211022224104.3541725-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022224104.3541725-1-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 06:41:04PM -0400, Sean Anderson wrote:
> This converts instances of
> 	bitmap_foo(args..., __ETHTOOL_LINK_MODE_MASK_NBITS)
> to
> 	linkmode_foo(args...)

It does touch a lot of files, but it does help keep the API uniform.

> I manually fixed up some lines to prevent them from being excessively
> long. Otherwise, this change was generated with the following semantic
> patch:

How many did you fix?

> Because this touches so many files in the net tree, you may want to
> generate a new diff using the semantic patch above when you apply this.

If it still applies cleanly, i would just apply it. Otherwise maybe
Jakub could recreate it?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
