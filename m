Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42D015E68
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 09:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEGHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 03:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfEGHla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 03:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9115620989;
        Tue,  7 May 2019 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557214889;
        bh=bn9LxTz5PdUe1/eUSoWy21rExjTBSKgzZqLiQHJSJt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G9IZEx4Ac6qG5IHydgnkSVdU2W3m3DzHUL1a8UNorDAR3bT8YrmdfqPbnGovYAZqT
         gJPg1s4gm5MefjSAlyiTpxSL25/qZyI2uPZLngg5B69pvF4BDdV4Ro6afM2qi/0H5h
         BBPj0fkQFaLnYMa/n4Ir+xUQmGDzRY/bniniJQGg=
Date:   Tue, 7 May 2019 09:41:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Message-ID: <20190507074126.GA26478@kroah.com>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
 <20190507071914.GJ2269@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507071914.GJ2269@kadam>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 07, 2019 at 10:19:14AM +0300, Dan Carpenter wrote:
> On Mon, May 06, 2019 at 11:24:43PM +0200, Petr Štetiar wrote:
> > Hi,
> > 
> > this patch series is an attempt to fix the mess, I've somehow managed to
> > introduce.
> > 
> > First patch in this series is defacto v5 of the previous 05/10 patch in the
> > series, but since the v4 of this 05/10 patch wasn't picked up by the
> > patchwork for some unknown reason, this patch wasn't applied with the other
> > 9 patches in the series, so I'm resending it as a separate patch of this
> > fixup series again.
> 
> I feel sort of ridiculous asking this over and over...  Maybe your spam
> filter is eating my emails?
> 
> This bug was introduced in https://patchwork.ozlabs.org/patch/1094916/
> "[v4,01/10] of_net: add NVMEM support to of_get_mac_address" but it
> looks like no one applied it.
> 
> You're acting as if it *was* applied but you refuse to answer my
> question who applied it and which to which tree so I can figure out what
> went wrong.
> 
> I only see comments from last Friday that it shouldn't be applied...  I
> also told you on Friday in a different thread that that patch shouldn't
> be applied.  Breaking git bisect is a bug, and we never do that.  I'm
> just very confused right now...  What I'm trying to do is figure out in
> my head how this process failed so we can do better next time.

Just to resend this, so that it hopefully does _not_ get stuck in a spam
filter.

Petr, please address Dan's comments, do not ignore them.

greg k-h
