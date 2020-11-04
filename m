Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0752A6506
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgKDNXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:23:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbgKDNXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:23:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaIl6-005CxM-8o; Wed, 04 Nov 2020 14:23:28 +0100
Date:   Wed, 4 Nov 2020 14:23:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/12] net: usb: lan78xx: Remove lots of set but unused
 'ret' variables
Message-ID: <20201104132328.GX933237@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104090610.1446616-2-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:05:59AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_read_raw_otp’:
>  drivers/net/usb/lan78xx.c:825:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_write_raw_otp’:
>  drivers/net/usb/lan78xx.c:879:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_deferred_multicast_write’:
>  drivers/net/usb/lan78xx.c:1041:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_update_flowcontrol’:
>  drivers/net/usb/lan78xx.c:1127:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_init_mac_address’:
>  drivers/net/usb/lan78xx.c:1666:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_link_status_change’:
>  drivers/net/usb/lan78xx.c:1841:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_irq_bus_sync_unlock’:
>  drivers/net/usb/lan78xx.c:1920:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan8835_fixup’:
>  drivers/net/usb/lan78xx.c:1994:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_rx_max_frame_length’:
>  drivers/net/usb/lan78xx.c:2192:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_change_mtu’:
>  drivers/net/usb/lan78xx.c:2270:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_mac_addr’:
>  drivers/net/usb/lan78xx.c:2299:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_features’:
>  drivers/net/usb/lan78xx.c:2333:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>  drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_suspend’:
>  drivers/net/usb/lan78xx.c:3807:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
> 
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
