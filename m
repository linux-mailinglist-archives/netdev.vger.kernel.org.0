Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C99545B657
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbhKXIQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:16:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22920 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbhKXIQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637741586; x=1669277586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bqk5tbm4IZnDwOVzt/oq6oWR1FLYyl4yAvtq9+RMHeQ=;
  b=QTjwYcgDZVV6nyoVhTiUFT+prhatdNFTAI4BSrRx4KIF5TPRqioYXTma
   T4AR/iFEoY3n75qaTYF8R4nf6mQvh9ngLwRW+FW1iK+mcDdz7/5VvdKa5
   2i75ZugvMpKtfz04xqiUVXB7ku4GXwxBjJJKWzkzm6XInTcMltEQ0USlr
   9GcIlRQV8/9HyYy7fOS7jeot4vjSL8FTQ2AKGBG6+LSZNH1UVe4+L7osF
   2CYpPKKIS9OBY1OUNN65nsHYulC4U8kLt9sC9OLQ45qATuoMZH9ZD29VS
   D3WPVDoTXFgrb1dpIbVpG3heMCTT6ysmifbqTfeXmnUKytoqELBJTZVTn
   w==;
IronPort-SDR: N/oV9dqAvx9k8nzfwxpRkcEPxkH+btdjXiQWryAxzzOG8mq0MrmsNcy3Vi+6JXmSsohkwD7xKZ
 6d9/aTTpFMVyDJPGwU+KoOObEQAu3PaIhsTkt/fc3IX655Ft4UMmRXK77w9jEapHe6doXTAbpY
 EY6mJLLu0KUu8AwW7kQwwXPMBsiSbkvC6etS0K72RkJ9iGe33vxGaGgKvCAa+KB4/B4RkxSu0m
 BqqN7RCfJXymATJiytWAu47USdxcbyLVHD0ERDvTkBQdKNZVLT1APpCJ/xizCOL1bHH7vWzX0J
 Q2ccoMIa9lmqAJY+HGCMB2wZ
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="140154911"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 01:13:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 01:13:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 24 Nov 2021 01:13:05 -0700
Date:   Wed, 24 Nov 2021 09:14:58 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: lan966x: add the basic lan966x
 driver
Message-ID: <20211124081458.xwcg7naezbno6igu@soft-dev3-1.localhost>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
 <20211123135517.4037557-3-horatiu.vultur@microchip.com>
 <20211123193011.12cde5da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211123193011.12cde5da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/23/2021 19:30, Jakub Kicinski wrote:
> 
> On Tue, 23 Nov 2021 14:55:13 +0100 Horatiu Vultur wrote:
> > #include <asm/memory.h>
> 
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:3:10: fatal error: 'asm/memory.h' file not found
> #include <asm/memory.h>
>          ^~~~~~~~~~~~~~
> 
> Is this arch-specific? What do you need it for?

I don't need it.
I have another mistake with MODULE_DEVICE_TABLE.

Both of these issues will be fixed in the next version.

-- 
/Horatiu
