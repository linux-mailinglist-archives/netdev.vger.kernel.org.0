Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF97ABC6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbfG3PBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:01:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59104 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbfG3PBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 11:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=65E/ZXh4vz3P8VI73lH3jp+lf5tDRwhBiGW2ssQEd30=; b=DYScE28+ygzReT+7bGbOKgUdOU
        BOwaFKuzKMd3f4dbnOlK0j1lR3bL9dT9mTbZzDJBgda9gxTFrnQnyJW4aNulFaY9ijZTnrXxxznv8
        M1rsVPuV9q5f/pwMXr0ypqlI6C5aMwfCz130GlZalVg34IS8dGKu6Yn0zjV8Pj0GTVqxnVgr/sZ27
        jFzIrFzqK5t/wQhrRjoFv57qxShs332W4Ax8QX4hr7E2eg5MCbljO2cDviT2oy0wdVQ4gCUeXDxIP
        5NAFKs+zOXOtrKR+KZQ9yaZwIELUBohrgSVuLM6NYXVhlBFqgnoF2H9l+b4WJJMfaMPG8rgr24Yyw
        sn02Uvqg==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hsTcW-0000Ic-JY; Tue, 30 Jul 2019 15:00:56 +0000
Subject: Re: linux-next: Tree for Jul 30 (drivers/net/phy/mdio-octeon.c: i386)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
References: <20190730151527.08f611b8@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5db8f58b-3f20-a7ba-fcae-18dd0aa7df50@infradead.org>
Date:   Tue, 30 Jul 2019 08:00:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730151527.08f611b8@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/19 10:15 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20190729:
> 

on i386:

../drivers/net/phy/mdio-octeon.c: In function ‘octeon_mdiobus_probe’:
../drivers/net/phy/mdio-octeon.c:48:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   (u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
   ^
In file included from ../drivers/net/phy/mdio-octeon.c:14:0:
../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of function ‘writeq’; did you mean ‘writel’? [-Werror=implicit-function-declaration]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                    ^
../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:111:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:111:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-octeon.c:77:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-octeon.c: In function ‘octeon_mdiobus_remove’:
../drivers/net/phy/mdio-cavium.h:111:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-octeon.c:91:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~



-- 
~Randy
