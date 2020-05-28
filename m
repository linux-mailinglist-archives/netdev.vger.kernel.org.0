Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845661E5801
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgE1G5r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 02:57:47 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:44941 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgE1G5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 02:57:47 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id E914E40013;
        Thu, 28 May 2020 06:57:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200527103513.05ee36e9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20200527164158.313025-1-antoine.tenart@bootlin.com> <20200527164158.313025-6-antoine.tenart@bootlin.com> <20200527103513.05ee36e9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net
To:     Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 5/8] net: phy: mscc: 1588 block initialization
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Message-ID: <159064906267.314251.13734785844479438819@kwain>
Date:   Thu, 28 May 2020 08:57:42 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Quoting Jakub Kicinski (2020-05-27 19:35:13)
> 
> This doesn't build on my system :S

I'll have a look at this and fix it for v2.

Thanks for reporting it!
Antoine

> 
> In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
> ../include/linux/unaligned/be_byteshift.h:41:19: error: redefinition of â€˜get_unaligned_be16â€™
>    41 | static inline u16 get_unaligned_be16(const void *p)
>       |                   ^~~~~~~~~~~~~~~~~~
> In file included from ../arch/x86/include/asm/unaligned.h:9,
>                  from ../include/linux/etherdevice.h:24,
>                  from ../include/linux/if_vlan.h:11,
>                  from ../include/linux/filter.h:22,
>                  from ../include/net/sock.h:59,
>                  from ../include/net/inet_sock.h:22,
>                  from ../include/linux/udp.h:16,
>                  from ../drivers/net/phy/mscc/mscc_ptp.c:17:
> ../include/linux/unaligned/access_ok.h:23:28: note: previous definition of â€˜get_unaligned_be16â€™ was here
>    23 | static __always_inline u16 get_unaligned_be16(const void *p)
>       |                            ^~~~~~~~~~~~~~~~~~
> In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
> ../include/linux/unaligned/be_byteshift.h:46:19: error: redefinition of â€˜get_unaligned_be32â€™
>    46 | static inline u32 get_unaligned_be32(const void *p)
>       |                   ^~~~~~~~~~~~~~~~~~
> In file included from ../arch/x86/include/asm/unaligned.h:9,
>                  from ../include/linux/etherdevice.h:24,
>                  from ../include/linux/if_vlan.h:11,
>                  from ../include/linux/filter.h:22,
>                  from ../include/net/sock.h:59,
>                  from ../include/net/inet_sock.h:22,
>                  from ../include/linux/udp.h:16,
>                  from ../drivers/net/phy/mscc/mscc_ptp.c:17:
> ../include/linux/unaligned/access_ok.h:28:28: note: previous definition of â€˜get_unaligned_be32â€™ was here
>    28 | static __always_inline u32 get_unaligned_be32(const void *p)
>       |                            ^~~~~~~~~~~~~~~~~~
> In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
> ../include/linux/unaligned/be_byteshift.h:51:19: error: redefinition of â€˜get_unaligned_be64â€™
>    51 | static inline u64 get_unaligned_be64(const void *p)
>       |                   ^~~~~~~~~~~~~~~~~~
> In file included from ../arch/x86/include/asm/unaligned.h:9,
>                  from ../include/linux/etherdevice.h:24,
>                  from ../include/linux/if_vlan.h:11,
>                  from ../include/linux/filter.h:22,
>                  from ../include/net/sock.h:59,
>                  from ../include/net/inet_sock.h:22,
>                  from ../include/linux/udp.h:16,
>                  from ../drivers/net/phy/mscc/mscc_ptp.c:17:
> ../include/linux/unaligned/access_ok.h:33:28: note: previous definition of â€˜get_unaligned_be64â€™ was here
>    33 | static __always_inline u64 get_unaligned_be64(const void *p)
>       |                            ^~~~~~~~~~~~~~~~~~
> In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
> ../include/linux/unaligned/be_byteshift.h:56:20: error: redefinition of â€˜put_unaligned_be16â€™
>    56 | static inline void put_unaligned_be16(u16 val, void *p)
>       |                    ^~~~~~~~~~~~~~~~~~
> In file included from ../arch/x86/include/asm/unaligned.h:9,
>                  from ../include/linux/etherdevice.h:24,
>                  from ../include/linux/if_vlan.h:11,
>                  from ../include/linux/filter.h:22,
>                  from ../include/net/sock.h:59,
>                  from ../include/net/inet_sock.h:22,
>                  from ../include/linux/udp.h:16,
>                  from ../drivers/net/phy/mscc/mscc_ptp.c:17:
> ../include/linux/unaligned/access_ok.h:53:29: note: previous definition of â€˜put_unaligned_be16â€™ was here
>    53 | static __always_inline void put_unaligned_be16(u16 val, void *p)
>       |                             ^~~~~~~~~~~~~~~~~~
> In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
> ../include/linux/unaligned/be_byteshift.h:61:20: error: redefinition of â€˜put_unaligned_be32â€™
>    61 | static inline void put_unaligned_be32(u32 val, void *p)
>       |                    ^~~~~~~~~~~~~~~~~~
> In file included from ../arch/x86/include/asm/unaligned.h:9,
>                  from ../include/linux/etherdevice.h:24,
>                  from ../include/linux/if_vlan.h:11,
>                  from ../include/linux/filter.h:22,
>                  from ../include/net/sock.h:59,
>                  from ../include/net/inet_sock.h:22,
>                  from ../include/linux/udp.h:16,
>                  from ../drivers/net/phy/mscc/mscc_ptp.c:17:
> ../include/linux/unaligned/access_ok.h:58:29: note: previous definition of â€˜put_unaligned_be32â€™ was here
>    58 | static __always_inline void put_unaligned_be32(u32 val, void *p)
>       |                             ^~~~~~~~~~~~~~~~~~
> In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
> ../include/linux/unaligned/be_byteshift.h:66:20: error: redefinition of â€˜put_unaligned_be64â€™
>    66 | static inline void put_unaligned_be64(u64 val, void *p)
>       |                    ^~~~~~~~~~~~~~~~~~
> In file included from ../arch/x86/include/asm/unaligned.h:9,
>                  from ../include/linux/etherdevice.h:24,
>                  from ../include/linux/if_vlan.h:11,
>                  from ../include/linux/filter.h:22,
>                  from ../include/net/sock.h:59,
>                  from ../include/net/inet_sock.h:22,
>                  from ../include/linux/udp.h:16,
>                  from ../drivers/net/phy/mscc/mscc_ptp.c:17:
> ../include/linux/unaligned/access_ok.h:63:29: note: previous definition of â€˜put_unaligned_be64â€™ was here
>    63 | static __always_inline void put_unaligned_be64(u64 val, void *p)
>       |                             ^~~~~~~~~~~~~~~~~~
> ../drivers/net/phy/mscc/mscc_ptp.c:658:12: warning: â€˜vsc85xx_ts_engine_initâ€™ defined but not used [-Wunused-function]
>   658 | static int vsc85xx_ts_engine_init(struct phy_device *phydev, bool one_step)
>       |            ^~~~~~~~~~~~~~~~~~~~~~
> make[5]: *** [drivers/net/phy/mscc/mscc_ptp.o] Error 1
> make[4]: *** [drivers/net/phy/mscc] Error 2
> make[3]: *** [drivers/net/phy] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [drivers/net] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
