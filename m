Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFB23823C9
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 07:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbhEQFsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 01:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234462AbhEQFry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 01:47:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CCF6108D;
        Mon, 17 May 2021 05:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621230378;
        bh=UssYIYbkL3qu2UXuoT41PmlhMhpzovvV5hj4VqQqw6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vna6C9/eXr0rr9wnsxamGgP6HY53+rapHkKqAnJK3sSoY631+u0j3cZ/Xjleivf8U
         lDAxln7hHa19MzfzYmHSkNzIK1K5pI/K/AyFyyommMzJ/FNr5UiqNJi1b78GTzBNCc
         OvydG874aqfpppXC7D0nP3i8lBieHyXygMg/IfKE=
Date:   Mon, 17 May 2021 07:46:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     aaro.koskinen@iki.fi, tony@atomide.com, linux@prisktech.co.nz,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, lee.jones@linaro.org,
        daniel.thompson@linaro.org, jingoohan1@gmail.com, mst@redhat.com,
        jasowang@redhat.com, zbr@ioremap.net, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, horms@verge.net.au, ja@ssi.bg,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Juerg Haefliger <juergh@canonical.com>
Subject: Re: [PATCH] treewide: Remove leading spaces in Kconfig files
Message-ID: <YKIDJIfuufBrTQ4f@kroah.com>
References: <20210516132209.59229-1-juergh@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516132209.59229-1-juergh@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 03:22:09PM +0200, Juerg Haefliger wrote:
> There are a few occurences of leading spaces before tabs in a couple of
> Kconfig files. Remove them by running the following command:
> 
>   $ find . -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'
> 
> Signed-off-by: Juerg Haefliger <juergh@canonical.com>
> ---
>  arch/arm/mach-omap1/Kconfig     | 12 ++++++------
>  arch/arm/mach-vt8500/Kconfig    |  6 +++---
>  arch/arm/mm/Kconfig             | 10 +++++-----
>  drivers/char/hw_random/Kconfig  |  8 ++++----
>  drivers/net/usb/Kconfig         | 10 +++++-----
>  drivers/net/wan/Kconfig         |  4 ++--
>  drivers/scsi/Kconfig            |  2 +-
>  drivers/uio/Kconfig             |  2 +-
>  drivers/video/backlight/Kconfig | 10 +++++-----
>  drivers/virtio/Kconfig          |  2 +-
>  drivers/w1/masters/Kconfig      |  6 +++---
>  fs/proc/Kconfig                 |  4 ++--
>  init/Kconfig                    |  2 +-
>  net/netfilter/Kconfig           |  2 +-
>  net/netfilter/ipvs/Kconfig      |  2 +-
>  15 files changed, 41 insertions(+), 41 deletions(-)

Please break this up into one patch per subsystem and resend to the
proper maintainers that way.

thanks,

greg k-h
