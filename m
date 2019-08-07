Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F1384391
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfHGFKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:10:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35478 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfHGFKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 01:10:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so4104555wrq.2;
        Tue, 06 Aug 2019 22:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=J8q3C8XNtyFn5o0cwi/6TaYLXcXbfFKt+Egf2sjlgy4=;
        b=kORicJpztHIAwdM1j6OiXotMjAmnbeuzPVZK1OaRQqPj3TihOURdk3RfNJcrNYn71+
         rkYlRYB8UN8FvSCEU7NhsxslbjiCQZziRQytKjphOWY3pDterZ5KGGg5JrXEVIlSOHYl
         n+cJhGcjrw0vhAqoc/2wyY/qPptwNTsyJtbx/ulhiGkEHKSHXx00c2GlqpDuB1Jq/T4F
         pdyjiC2s65LPItL7nqmur9LPmsu9wFUROtYC+RWRagdcw3lV3E35Fn8Ln3xOo5oUUtO2
         ADawuzcz2reCB0yu9FvBoFKqzXWCsfhbE/Q4FV+6aiBn4BOjUH5DqiO8KMApy2GknrLT
         FECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=J8q3C8XNtyFn5o0cwi/6TaYLXcXbfFKt+Egf2sjlgy4=;
        b=bOXwrDw4grGHVNzb0q7qsRvPCZSA9am/SF13wdfiXMNE3dOBfYqhEpJsJDrQFdDfvt
         fBWYGNp6ZxHSwH0mVqP+n5Cvl9DavdgHFxL2JiQ0BGNQ2+Q9HmPdo1a8KWjwzhYY7P46
         ocZQRU2c/yXNvWTiIETGJx258j2EIze5+Kn95oKg7VmHW8YrRQeRJefOZa11EOe7t2n1
         foE44XZ64TsVaykdkh3v40wtyskgo8Do3Ln9Qf+d3QF1oewv3W5YI2zaDZWo+LXdRNW5
         cJV3uoesyJUcAjVEjeqjQauvGycV3UA7lkURwXkix8U39FIAtmoyjXeKN9YKrldB11zp
         Av6w==
X-Gm-Message-State: APjAAAW4KugBy0X7ksU4RkbnO8nRjan0vtLn7cpwetnafbWbUaGlo5fm
        oY5/uv6XSZWPq5JZOfn7fms=
X-Google-Smtp-Source: APXvYqyjCQmPGVso7ydC60Zaa2gys5Ws3aDZ25TP0UeAxXRLDn2hGC0AAUKFdh/ro7Y4q3pZ1dRHLg==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr7822802wrs.225.1565154643044;
        Tue, 06 Aug 2019 22:10:43 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id o20sm227955236wrh.8.2019.08.06.22.10.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 22:10:41 -0700 (PDT)
Date:   Tue, 6 Aug 2019 22:10:40 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, broonie@kernel.org, devel@driverdev.osuosl.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        hkallweit1@gmail.com, kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        lkp@intel.com, netdev@vger.kernel.org, rdunlap@infradead.org,
        willy@infradead.org
Subject: Re: [PATCH v2] net: mdio-octeon: Fix Kconfig warnings and build
 errors
Message-ID: <20190807051040.GA117554@archlinux-threadripper>
References: <20190731185023.20954-1-natechancellor@gmail.com>
 <20190803060155.89548-1-natechancellor@gmail.com>
 <20190806.141133.1365654857955536268.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190806.141133.1365654857955536268.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 02:11:33PM -0700, David Miller wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Fri,  2 Aug 2019 23:01:56 -0700
> 
> > After commit 171a9bae68c7 ("staging/octeon: Allow test build on
> > !MIPS"), the following combination of configs cause a few Kconfig
> > warnings and build errors (distilled from arm allyesconfig and Randy's
> > randconfig builds):
> > 
> >     CONFIG_NETDEVICES=y
> >     CONFIG_STAGING=y
> >     CONFIG_COMPILE_TEST=y
> > 
> > and CONFIG_OCTEON_ETHERNET as either a module or built-in.
> > 
> > WARNING: unmet direct dependencies detected for MDIO_OCTEON
> >   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y]
> > && 64BIT [=n] && HAS_IOMEM [=y] && OF_MDIO [=n]
> >   Selected by [y]:
> >   - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC ||
> > COMPILE_TEST [=y]) && NETDEVICES [=y]
> > 
> > In file included from ../drivers/net/phy/mdio-octeon.c:14:
> > ../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of
> > function ‘writeq’; did you mean ‘writel’?
> > [-Werror=implicit-function-declaration]
> >   111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
> >       |                                    ^~~~~~
> > 
> > CONFIG_64BIT is not strictly necessary if the proper readq/writeq
> > definitions are included from io-64-nonatomic-lo-hi.h.
> > 
> > CONFIG_OF_MDIO is not needed when CONFIG_COMPILE_TEST is enabled because
> > of commit f9dc9ac51610 ("of/mdio: Add dummy functions in of_mdio.h.").
> > 
> > Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Reported-by: Mark Brown <broonie@kernel.org>
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Applied to net-next.
> 
> Please make it clear what tree your changes are targetting in the future,
> thank you.

Sorry for the confusion, I'll do my best to add a patch suffix in the
future.

Thank you for picking this up!
Nathan
