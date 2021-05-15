Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06AB38193E
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 16:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhEOOIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 10:08:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhEOOIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 10:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D0vB53EGV7pBSyBp8RPfA5JvjdEHg/tl7GOvHK6yzFU=; b=hQkSvwsQdB2DHxJP76JCUSJmmM
        mIovO0uUbEfz6iHKHD5w6eNvgR6RWUS5a9u3qMem6etk5VYqh8jCsZwNcTdZBVI7stWte013HbEfk
        EGokmkfzPvE3AExXR6iIR0mPSisGUHwwaUTv94Xo514nSo7yfVGDSasYjk3T3lrSLJqI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhuw5-004Kf7-UX; Sat, 15 May 2021 16:06:33 +0200
Date:   Sat, 15 May 2021 16:06:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: mdiobus: get rid of a BUG_ON()
Message-ID: <YJ/VaQW54hM5btjP@lunn.ch>
References: <YJ+b52c5bGLdewFz@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ+b52c5bGLdewFz@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 01:01:11PM +0300, Dan Carpenter wrote:
> We spotted a bug recently during a review where a driver was
> unregistering a bus that wasn't registered, which would trigger this
> BUG_ON().  Let's handle that situation more gracefully, and just print
> a warning and return.
> 
> Reported-by: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
