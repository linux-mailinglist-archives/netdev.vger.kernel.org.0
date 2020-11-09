Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208092AC7F7
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgKIWEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgKIWEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:04:30 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF38A206CB;
        Mon,  9 Nov 2020 22:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604959470;
        bh=2p7xrJwLAiQnxbvjflc5/qx28vVqY3y7ZTK4VXqX0P8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KAbPzUPqy4su0uBPg+DvcYf4VOZiRMc/q5OwztRJQkm+mWryOS1g/3y6jUdIHiXkg
         LEpwEdTwiLrTGuE3Md7mxK6gEigDfbkbrgWqAge5Vy6hCybQ8iZswXXer94kNypmOv
         5aaIw03fOK/7yaL7ko5Gyg26ASX4IPlUDgXB22Dw=
Date:   Mon, 9 Nov 2020 14:04:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
Message-ID: <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
References: <20201109193117.2017-1-TheSven73@gmail.com>
        <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
        <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 16:29:19 -0500 Sven Van Asbroeck wrote:
> On Mon, Nov 9, 2020 at 4:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > the commit
> > which introduced the assignment in the client driver.  
> 
> That's the commit which adds the initial driver to the tree, back in 2011.
> Should I use that for Fixes?

Yup
