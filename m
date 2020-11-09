Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD292AC8DD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgKIWuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgKIWuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:50:51 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFCB3206C0;
        Mon,  9 Nov 2020 22:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604962251;
        bh=apQ2qdH9FTTvtkF02IPDqcoq8TgCgCDbRlAv5SA6baM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cgALtHFVZ6r93CS3CJASGpLf7pmZFnw/iB3Q0ZI0FhMDKsUG5LKF96uJqKnjdlbFe
         /4iIeupM9h9GrTKRadp7Xz2OQoG76ItGruYuZAKOVTPuId+vAPm21b+YHg7jz5Py17
         4rmD5yLY3feZw8qR1nTt45G30UxW/niMCwEe4LVk=
Date:   Mon, 9 Nov 2020 14:50:49 -0800
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
Message-ID: <20201109145049.42e0abe5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAGngYiWYKsTURi0pRMxX=SjzPnx-OF0cC43dnaGc+o15kLwk_A@mail.gmail.com>
References: <20201109193117.2017-1-TheSven73@gmail.com>
        <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
        <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
        <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiWUJ=bdJVMjzXBOc54H4Ubx5vQmaFnUbAWUjhaZ8nvP3A@mail.gmail.com>
        <20201109142322.782b9495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiVaQ4u7-2HJ6X92vJ9D4ZuC+GZhGmr2LhSMjCKBYfbZuA@mail.gmail.com>
        <20201109143605.0a60b2ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiWYKsTURi0pRMxX=SjzPnx-OF0cC43dnaGc+o15kLwk_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 17:39:22 -0500 Sven Van Asbroeck wrote:
> What I already posted (as v1) should be the minimal fix.
> Can we proceed on that basis? I'll follow up with the helper
> after the net -> net-next merge, as you suggested.

Well, you cut off the relevant part of my email where I said:

  But please at least repost for net and CC Mark and the SPI list 
  for input.

Maybe Mark has a different idea on how client drivers should behave.

Also please obviously CC the author of the patch who introduced 
the breakage.
