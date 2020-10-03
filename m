Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601A82822EB
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCJKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgJCJKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 05:10:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE625206CA;
        Sat,  3 Oct 2020 09:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601716240;
        bh=lhSyJeU5dA2r3+7jjybpLd3bRjEFbAjirEVHfxlVGOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kf4098oB2XrDnGB+eroawQrNOeHsqe6zx8xCx9n/YdSWacCydKawY4sDW3bHRJZi1
         AdP6LvZQf9RV42mXlstTHSxoKfLZQOOJd1A1gPp6dQ18nkWEoOy9fKXiZNB/yZnZlQ
         X/nT19Kqn/X2m2pAqKhudhlf1pdPQMdluMUVZtrY=
Date:   Sat, 3 Oct 2020 11:10:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/6] Ancillary bus implementation and SOF multi-client
 support
Message-ID: <20201003091036.GA118157@kroah.com>
References: <20201001050534.890666-1-david.m.ertman@intel.com>
 <20201003090452.GF3094@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003090452.GF3094@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 12:04:52PM +0300, Leon Romanovsky wrote:
> Hi Dave,
> 
> I don't know why did you send this series separately to every mailing
> list, but it is not correct thing to do.
> 
> RDMA ML and discussion:
> https://lore.kernel.org/linux-rdma/20201001050534.890666-1-david.m.ertman@intel.com/T/#t
> Netdev ML (completely separated):
> https://lore.kernel.org/netdev/20201001050851.890722-1-david.m.ertman@intel.com/
> Alsa ML (separated too):
> https://lore.kernel.org/alsa-devel/20200930225051.889607-1-david.m.ertman@intel.com/

Seems like the goal was to spread it around to different places so that
no one could strongly object or review it :(

greg k-h
