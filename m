Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7842AC8A9
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgKIWgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIWgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:36:07 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EB2206CB;
        Mon,  9 Nov 2020 22:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604961366;
        bh=R6YeRBJW3Qb23iLnWuo6uS/1oJ5EIJ6iegsm1LuQ5dI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UmFeKjuhd+Xm0DbM97m9Pornk8gOUKJgERC6eRuuUa5VrqwOlasqu9GuckVX70OHm
         7e78mtMwTWEUtA3XLuvaPF0xGtSaD+0TSVWFYpOxAv/RgTPxFULOviHsDnALguVN+n
         HRuYRZKUpg6e70Rsihve+iRoF5Sj23aNFvED6JDo=
Date:   Mon, 9 Nov 2020 14:36:05 -0800
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
Message-ID: <20201109143605.0a60b2ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAGngYiVaQ4u7-2HJ6X92vJ9D4ZuC+GZhGmr2LhSMjCKBYfbZuA@mail.gmail.com>
References: <20201109193117.2017-1-TheSven73@gmail.com>
        <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
        <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
        <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiWUJ=bdJVMjzXBOc54H4Ubx5vQmaFnUbAWUjhaZ8nvP3A@mail.gmail.com>
        <20201109142322.782b9495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiVaQ4u7-2HJ6X92vJ9D4ZuC+GZhGmr2LhSMjCKBYfbZuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 17:27:28 -0500 Sven Van Asbroeck wrote:
> On Mon, Nov 9, 2020 at 5:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Is it only broken for you in linux-next or just in the current 5.10
> > release?  
> 
> It's broken for me in the current 5.10 release. That means it should
> go to net, not net-next, correct?

Yes, most certainly. Especially with 5.10 being LTS.

You can send a minimal fix (perhaps what you got already?), and follow
up with the helper as suggested by Andrew after ~a week when net is
merged into net-next.

But please at least repost for net and CC Mark and the SPI list for
input.
