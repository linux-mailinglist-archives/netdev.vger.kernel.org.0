Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8513D32831
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 07:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfFCF6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 01:58:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36666 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfFCF6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 01:58:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id v22so9611348wml.1
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 22:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RRCrBtqQ50i0dqnCfgUWwVGvdY2wWRuGnSamSruzrEc=;
        b=TnDUytZiV7FKKJhwqRsHJy+askgeSrwawryHKD3gyWR8tjjH9LUxldrbUhDPmiPB83
         maZwtztqeLl5oW8ya1rjhz07NvTOLJ3kYRY7QN4aUEjpny7la1Ba54QvsEug3NuSWRWs
         pRtjZYOFBu9u2XUsRhnX9435mS36p9GRvNcs1B4v5ZPNtUK8dBXchIvvJb5RcG7KbbJG
         uqU90fA+XCXhTzFx7i4xAswGcC98d4DsrZz4keAHSM+IU19tWbz/q4KffjCqFhkQs7uc
         vFSRJ2F23Gzrh1xolEXv0FMuAWU0vpgqx8yfNXtHcpjMFG+ZtXAn3RCemL37E2qIS3ve
         y9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RRCrBtqQ50i0dqnCfgUWwVGvdY2wWRuGnSamSruzrEc=;
        b=Csb+btiOisFpZzajrObgA6fjouKlVPwEe+nnrkkxK1x6LxvBGJSy8TbQrN8Ksj4rJF
         DMsrIXEa2+tTDvGzWyxlOrk7kUjA3FDMTzezB3DHtxSu2+r3ucS0g3sEv2K+bZbdwD5N
         MHjllNwFLwoRqWAd0FSd9nCS1PD3jFiTkpFLU5l86mGD0dLh3PCRW5S0epxSTUvmH+cm
         YOUguLoPB2HH09eDHU1OIylqmd6RH1mvN4T4Y7PD7J4u5Yo8n7kO1mm9Vd79fwJXw0p0
         Gfw3xPHDs+t4KrCGQ7E29TVd+Pqs00GxXdOLtMQACyiXzy7wAgvXYPsVPEk+/Em3094y
         V+4w==
X-Gm-Message-State: APjAAAXsfOKE7gWlG/jjrLXoWn0q6yIS0NOTl5cbQyqPwDrZnf5NNnj+
        fhQPPD+RIloc8wNDPjcvzZtoXA==
X-Google-Smtp-Source: APXvYqwNJ2MW37Fzt+6IshF0Z7LSFNcTv5PZE8zTgf38GcWet2vX9w6KequETQPGrISFzhDFQUbpTw==
X-Received: by 2002:a1c:407:: with SMTP id 7mr1057302wme.113.1559541522919;
        Sun, 02 Jun 2019 22:58:42 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b69sm9587781wme.44.2019.06.02.22.58.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 02 Jun 2019 22:58:42 -0700 (PDT)
Date:   Mon, 3 Jun 2019 07:58:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] devlink: fix libc and kernel headers collision
Message-ID: <20190603055841.GA2202@nanopsycho>
References: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 30, 2019 at 05:32:27PM CEST, baruch@tkos.co.il wrote:
>Since commit 2f1242efe9d ("devlink: Add devlink health show command") we
>use the sys/sysinfo.h header for the sysinfo(2) system call. But since
>iproute2 carries a local version of the kernel struct sysinfo, this
>causes a collision with libc that do not rely on kernel defined sysinfo
>like musl libc:
>
>In file included from devlink.c:25:0:
>.../sysroot/usr/include/sys/sysinfo.h:10:8: error: redefinition of 'struct sysinfo'
> struct sysinfo {
>        ^~~~~~~
>In file included from ../include/uapi/linux/kernel.h:5:0,
>                 from ../include/uapi/linux/netlink.h:5,
>                 from ../include/uapi/linux/genetlink.h:6,
>                 from devlink.c:21:
>../include/uapi/linux/sysinfo.h:8:8: note: originally defined here
> struct sysinfo {
>		^~~~~~~
>
>Rely on the kernel header alone to avoid kernel and userspace headers
>collision of definitions.
>
>Cc: Aya Levin <ayal@mellanox.com>
>Cc: Moshe Shemesh <moshe@mellanox.com>
>Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Acked-by: Jiri Pirko <jiri@mellanox.com>
