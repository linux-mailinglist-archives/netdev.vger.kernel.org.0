Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA07ACE4CA
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfJGOL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:11:56 -0400
Received: from vps.xff.cz ([195.181.215.36]:55952 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfJGOL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 10:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1570457513; bh=vCAFf9C0br5VOI1ZEU2yHBKcKssDrCWtMjeUus4lEvs=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=tKFYuF7CIbqBRHvfCbUenSAaxcz2/NEiihFPgquA588JE7l65OI+ZFs3BxqUXBeb3
         TkIIg1l8zsVvcLmp9N/rKDlseQuzb2rM4cGMspVzIb7OTTU72+40vWEHTpVi6zq6NH
         qiiN7TechdSJTKlkvQz+q9S8zk3HZuGQXQGL2Ylk=
Date:   Mon, 7 Oct 2019 16:11:53 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH 0/5] Add bluetooth support for Orange Pi 3
Message-ID: <20191007141153.7b76t4ntdzdojj5m@core.my.home>
Mail-Followup-To: Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20190823103139.17687-1-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823103139.17687-1-megous@megous.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Fri, Aug 23, 2019 at 12:31:34PM +0200, megous hlavni wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> (Resend to add missing lists, sorry for the noise.)
> 
> This series implements bluetooth support for Xunlong Orange Pi 3 board.
> 
> The board uses AP6256 WiFi/BT 5.0 chip.
> 
> Summary of changes:
> 
> - add more delay to let initialize the chip
> - let the kernel detect firmware file path
> - add new compatible and update dt-bindings
> - update Orange Pi 3 / H6 DTS

Please consider the DTS patches for 5.5.

Thanks,
	Ondrej

> Please take a look.
> 
> thank you and regards,
>   Ondrej Jirman
> 
> Ondrej Jirman (5):
>   dt-bindings: net: Add compatible for BCM4345C5 bluetooth device
>   bluetooth: bcm: Add support for loading firmware for BCM4345C5
>   bluetooth: hci_bcm: Give more time to come out of reset
>   arm64: dts: allwinner: h6: Add pin configs for uart1
>   arm64: dts: allwinner: orange-pi-3: Enable UART1 / Bluetooth
> 
>  .../bindings/net/broadcom-bluetooth.txt       |  1 +
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 19 +++++++++++++++++++
>  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  | 10 ++++++++++
>  drivers/bluetooth/btbcm.c                     |  3 +++
>  drivers/bluetooth/hci_bcm.c                   |  3 ++-
>  5 files changed, 35 insertions(+), 1 deletion(-)
> 
> -- 
> 2.23.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
