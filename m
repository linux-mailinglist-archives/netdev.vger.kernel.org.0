Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9D3282317
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCJYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgJCJYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 05:24:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E5F206CA;
        Sat,  3 Oct 2020 09:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601717052;
        bh=kL1oT9jESZhdHr78QJxp6JYT0/KTUQ2i0XtO3OHsZp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a2pJ7ORPNftPezUtGNDEo3IdF+22iGYUbdI48c71wE2Bl7X3PX2d1E2Lf8SWD5kjT
         d3m5SeRIm/MbiiobKPxgT9GQmXlTtncOpRjQRHQueXRMYvo5ZfW9tt7Q85qCa8zDeZ
         sv/wTeiiprt2oRHGkiHuF4E+6OZX2Tt5QacDkr3A=
Date:   Sat, 3 Oct 2020 12:24:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/6] Ancillary bus implementation and SOF multi-client
 support
Message-ID: <20201003092407.GG3094@unreal>
References: <20201001050534.890666-1-david.m.ertman@intel.com>
 <20201003090452.GF3094@unreal>
 <20201003091036.GA118157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003091036.GA118157@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 11:10:36AM +0200, Greg KH wrote:
> On Sat, Oct 03, 2020 at 12:04:52PM +0300, Leon Romanovsky wrote:
> > Hi Dave,
> >
> > I don't know why did you send this series separately to every mailing
> > list, but it is not correct thing to do.
> >
> > RDMA ML and discussion:
> > https://lore.kernel.org/linux-rdma/20201001050534.890666-1-david.m.ertman@intel.com/T/#t
> > Netdev ML (completely separated):
> > https://lore.kernel.org/netdev/20201001050851.890722-1-david.m.ertman@intel.com/
> > Alsa ML (separated too):
> > https://lore.kernel.org/alsa-devel/20200930225051.889607-1-david.m.ertman@intel.com/
>
> Seems like the goal was to spread it around to different places so that
> no one could strongly object or review it :(

It took me time to realize why I was alone expressing my thoughts :).

BTW, I'm looking on ALSA thread and happy to see that people didn't like
"ancillary" name. It is far from intuitive name for any non-English speaker.

Thanks

>
> greg k-h
