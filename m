Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA3803B7
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 03:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390442AbfHCBag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 21:30:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52411 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388638AbfHCBag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 21:30:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so69540284wms.2;
        Fri, 02 Aug 2019 18:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ogf+QVoHZtK9iZfwgzb4P/UWGbW9VrBZvDIl55S3hPY=;
        b=KGkroKFjol78GrJj8Z3aHbKWLMrcSiwfex8ESVqf5pCyjcNBYG+ZPXlzN5iCRO4k4S
         j+kWSLfRx1gW9uTsbVilRV/mKw5vnJRnyRovCESrqPj485QPsEXeHmM1ohRfevsYjhl+
         bVqgoWYlnrNbPYUfDRYgNeFptq0zUwF8iaVEaW6Y91hTzIKVEhttusPL7xNJjagJgfPx
         Qmm+hhLcyFpZUGNoAb7uaqmLy2yvIu/dqrpx4BAoA8q5ZPCHBLZqpQBELIiFi0jGG2Yl
         HbTxR+5W2mtoj7+ef493cG+HiMMsq/Ot47bUXyCg3DdLbc7lKcrFA4E477Jh3bin1LxM
         lI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ogf+QVoHZtK9iZfwgzb4P/UWGbW9VrBZvDIl55S3hPY=;
        b=O1LHYWS6RJDdRWCjHBlN665JF4xGb1dkQ9/isMHGDMB2qeoNeHhIgr2MOvkqYbN++6
         3Bq61WNDsUgm42Om7WF4akN6DUDe6fwltUTffibie9vhYkOTfgMRI0hXu6ANz/bAcyhi
         HczY8sRl7k8UpW0kXOXKuMAvCZaknGAboKaie6crVQB5j4A4ZR7YIQhH6556Fn8oatx0
         WlJz67Plm0a5h8mry5wr3c9O6X4Pr++Nde9Dp/zfkXvGIXXo1NW0dcGLnoRNzXaB3pHd
         g/xQr93Z1PT5xID5VzeSPcG546TgjpwW1wt5ihw9H0y50F2cHw0PnIO56VOM1PCCX9Pp
         gYYA==
X-Gm-Message-State: APjAAAWTGH2d5Q+h6+KJN5MDSH3dqF85MU+YOgyV2mPs0VuolgbNaUSz
        bMkAqaCbkuLAxrS3AWomqtQ=
X-Google-Smtp-Source: APXvYqxqjFQJ9s+K2nHgDoEAg28+wlCsmvPhcNE3ueZNH5NsBPgHWuzjZM3lffnaX7s2DnS6f/1HMQ==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr6269283wmg.65.1564795833805;
        Fri, 02 Aug 2019 18:30:33 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id c4sm62233010wrt.86.2019.08.02.18.30.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 18:30:33 -0700 (PDT)
Date:   Fri, 2 Aug 2019 18:30:31 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, broonie@kernel.org, devel@driverdev.osuosl.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        hkallweit1@gmail.com, kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, willy@infradead.org, lkp@intel.com,
        rdunlap@infradead.org
Subject: Re: [PATCH] net: mdio-octeon: Fix build error and Kconfig warning
Message-ID: <20190803013031.GA76252@archlinux-threadripper>
References: <20190731.094150.851749535529247096.davem@davemloft.net>
 <20190731185023.20954-1-natechancellor@gmail.com>
 <20190802.181132.1425585873361511856.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802.181132.1425585873361511856.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 06:11:32PM -0700, David Miller wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Wed, 31 Jul 2019 11:50:24 -0700
> 
> > arm allyesconfig warns:
> > 
> > WARNING: unmet direct dependencies detected for MDIO_OCTEON
> >   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y]
> > && 64BIT && HAS_IOMEM [=y] && OF_MDIO [=y]
> >   Selected by [y]:
> >   - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC &&
> > NETDEVICES [=y] || COMPILE_TEST [=y])
> > 
> > and errors:
> > 
> > In file included from ../drivers/net/phy/mdio-octeon.c:14:
> > ../drivers/net/phy/mdio-octeon.c: In function 'octeon_mdiobus_probe':
> > ../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of
> > function 'writeq'; did you mean 'writeb'?
> 
> The proper way to fix this is to include either
> 
> 	linux/io-64-nonatomic-hi-lo.h
> 
> or
> 
> 	linux/io-64-nonatomic-lo-hi.h
> 
> whichever is appropriate.

Hmmmm, is that not what I did?

Although I did not know about io-64-nonatomic-hi-lo.h. What is the
difference and which one is needed here?

There is apparently another failure when OF_MDIO is not set, I guess I
can try to look into that as well and respin into a series if
necessary.

Cheers,
Nathan
