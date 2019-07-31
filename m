Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96427C8CB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfGaQfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:35:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35200 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbfGaQfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 12:35:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so70418100wrm.2;
        Wed, 31 Jul 2019 09:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=yAjEQyZodCr08YAboEYwoqZJvAo0oHxkikmOr+pozrQ=;
        b=R60oGN5kWvEbHesJPw/XvDID5/dDGBW2ltPHWrTjo/r6I0wREmVwpyI79G4Jw2lkkT
         TsRo/AfXHnLh8J7hJYZieYA0nj2EwU/6MjccGyeAF5trdBquCafCwTMnfmM4sGf1Wakt
         WPjH4MKNZ4ZxRqb6og7hYZVwr52kPui8+vA7oa6kTjahSwMYIHk6hShU11cdNKlRalxT
         3N/M2kuVcY7e69FOX4qQvylYkO5GQhwg4jN7zhl4kHdk9Eb9nqwsJWncERuRyQ7dLBcL
         uGzE70Ydq1bFQ7NJBXHEPvkssNF/nOmDGDFC8X2jv+VWIn3eVhmC2w8KUiH+snu+prUY
         8qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=yAjEQyZodCr08YAboEYwoqZJvAo0oHxkikmOr+pozrQ=;
        b=Dz+sGen2ubroP9pseHwR+26En40eAItG2B+XZJGV8Py0gPEsPfRogrznjO4mlK2GhR
         52JPe5Rwqkrrxx6pxYDxyDE+DlArl/DzwiVG/FSSCkqxr/7wR97NtulrnbjhhpJ8TTFp
         ENtH/DfNZoi9Fx0O8C0veGKfp0kXBH7Gj+qKQH723rW4kV9JeJoDq99nDvjzsvDIp6Bh
         YISNfMsmEUxdQj3PGyGUDSmovmC8l9JjvPr2F0eDVi8jG1jY8IdvFqIjGCqPe+G83D57
         fnDunOOHcEhdrd4QTrEGXY1MJDh2mD1v0qejcIDpasrH4eI0+AF9o2Fniv8rkHSsbcsC
         HS9w==
X-Gm-Message-State: APjAAAXj4+Gx4nwyeB1lLNrLYeCAZC1r5bu9fbqHAngXE4owDmAEkZux
        oW5liM7f3KRizPNEyo1SQoA=
X-Google-Smtp-Source: APXvYqy99Kyk9xLby2T0bVAd+GOAXz9UpXHXC0+PRE1TqCjVllfYJ7+I3EnWVdrP2U5sxtCh0KLANg==
X-Received: by 2002:adf:de90:: with SMTP id w16mr795512wrl.217.1564590911914;
        Wed, 31 Jul 2019 09:35:11 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id w23sm73532989wmi.45.2019.07.31.09.35.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:35:11 -0700 (PDT)
Date:   Wed, 31 Jul 2019 09:35:09 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, devel@driverdev.osuosl.org,
        andrew@lunn.ch, f.fainelli@gmail.com,
        kernel-build-reports@lists.linaro.org, netdev@vger.kernel.org,
        willy@infradead.org, broonie@kernel.org,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        hkallweit1@gmail.com
Subject: Re: next/master build: 221 builds: 11 failed, 210 passed, 13 errors,
 1174 warnings (next-20190731)
Message-ID: <20190731163509.GA90028@archlinux-threadripper>
References: <5d41767d.1c69fb81.d6304.4c8c@mx.google.com>
 <20190731112441.GB4369@sirena.org.uk>
 <20190731113522.GA3426@kroah.com>
 <20190731.084824.2244928058443049.davem@davemloft.net>
 <20190731160043.GA15520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190731160043.GA15520@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 06:00:43PM +0200, Greg KH wrote:
> On Wed, Jul 31, 2019 at 08:48:24AM -0700, David Miller wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date: Wed, 31 Jul 2019 13:35:22 +0200
> > 
> > > On Wed, Jul 31, 2019 at 12:24:41PM +0100, Mark Brown wrote:
> > >> On Wed, Jul 31, 2019 at 04:07:41AM -0700, kernelci.org bot wrote:
> > >> 
> > >> Today's -next fails to build an ARM allmodconfig due to:
> > >> 
> > >> > allmodconfig (arm, gcc-8) ― FAIL, 1 error, 40 warnings, 0 section mismatches
> > >> > 
> > >> > Errors:
> > >> >     drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of function 'writeq'; did you mean 'writel'? [-Werror=implicit-function-declaration]
> > >> 
> > >> as a result of the changes that introduced:
> > >> 
> > >> WARNING: unmet direct dependencies detected for MDIO_OCTEON
> > >>   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=m] && MDIO_BUS [=m] && 64BIT && HAS_IOMEM [=y] && OF_MDIO [=m]
> > >>   Selected by [m]:
> > >>   - OCTEON_ETHERNET [=m] && STAGING [=y] && (CAVIUM_OCTEON_SOC && NETDEVICES [=y] || COMPILE_TEST [=y])
> > >> 
> > >> which is triggered by the staging OCTEON_ETHERNET driver which misses a
> > >> 64BIT dependency but added COMPILE_TEST in 171a9bae68c72f2
> > >> (staging/octeon: Allow test build on !MIPS).
> > > 
> > > A patch was posted for this, but it needs to go through the netdev tree
> > > as that's where the offending patches are coming from.
> > 
> > I didn't catch that, was netdev CC:'d?
> 
> Nope, just you :(
> 
> I'll resend it now and cc: netdev.
> 
> thanks,
> 
> greg k-h

If it is this patch:

https://lore.kernel.org/netdev/20190731160219.GA2114@kroah.com/

It doesn't resolve that issue. I applied it and tested on next-20190731.

$ make -j$(nproc) -s ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- O=out distclean allyesconfig drivers/net/phy/

WARNING: unmet direct dependencies detected for MDIO_OCTEON
  Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y] && 64BIT && HAS_IOMEM [=y] && OF_MDIO [=y]
  Selected by [y]:
  - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC || COMPILE_TEST [=y]) && NETDEVICES [=y]
../drivers/net/phy/mdio-octeon.c: In function 'octeon_mdiobus_probe':
../drivers/net/phy/mdio-octeon.c:48:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   48 |   (u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
      |   ^
In file included from ../drivers/net/phy/mdio-octeon.c:14:
../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of function 'writeq'; did you mean 'writeb'? [-Werror=implicit-function-declaration]
  111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
      |                                    ^~~~~~
../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro 'oct_mdio_writeq'
   56 |  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
      |  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:111:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
      |                                                ^
../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro 'oct_mdio_writeq'
   56 |  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
      |  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:111:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
      |                                                ^
../drivers/net/phy/mdio-octeon.c:77:2: note: in expansion of macro 'oct_mdio_writeq'
   77 |  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
      |  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-octeon.c: In function 'octeon_mdiobus_remove':
../drivers/net/phy/mdio-cavium.h:111:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
      |                                                ^
../drivers/net/phy/mdio-octeon.c:91:2: note: in expansion of macro 'oct_mdio_writeq'
   91 |  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
      |  ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[3]: *** [../scripts/Makefile.build:274: drivers/net/phy/mdio-octeon.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [../Makefile:1780: drivers/net/phy/] Error 2
make[1]: *** [/home/nathan/cbl/linux-next/Makefile:330: __build_one_by_one] Error 2
make: *** [Makefile:179: sub-make] Error 2

This is the diff that I came up with to solve the errors plus the casting
warnings but it doesn't feel proper to me. If you all feel otherwise, I
can draft up a formal commit message.

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 20f14c5fbb7e..ed2edf4b5b0e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -159,7 +159,7 @@ config MDIO_MSCC_MIIM
 
 config MDIO_OCTEON
 	tristate "Octeon and some ThunderX SOCs MDIO buses"
-	depends on 64BIT
+	depends on 64BIT || COMPILE_TEST
 	depends on HAS_IOMEM && OF_MDIO
 	select MDIO_CAVIUM
 	help
diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
index ed5f9bb5448d..4b71b733edb4 100644
--- a/drivers/net/phy/mdio-cavium.h
+++ b/drivers/net/phy/mdio-cavium.h
@@ -108,8 +108,10 @@ static inline u64 oct_mdio_readq(u64 addr)
 	return cvmx_read_csr(addr);
 }
 #else
-#define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
-#define oct_mdio_readq(addr)		readq((void *)addr)
+#include <linux/io-64-nonatomic-lo-hi.h>
+
+#define oct_mdio_writeq(val, addr)	writeq(val, (void *)(uintptr_t)addr)
+#define oct_mdio_readq(addr)		readq((void *)(uintptr_t)addr)
 #endif
 
 int cavium_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum);
diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
index 8327382aa568..ab0d8ab588e4 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -45,7 +45,7 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 	}
 
 	bus->register_base =
-		(u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
+		(u64)(uintptr_t)devm_ioremap(&pdev->dev, mdio_phys, regsize);
 	if (!bus->register_base) {
 		dev_err(&pdev->dev, "dev_ioremap failed\n");
 		return -ENOMEM;
