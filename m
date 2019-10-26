Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94381E58B7
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 07:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfJZF1F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 26 Oct 2019 01:27:05 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:51845 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfJZF1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 01:27:05 -0400
Received: from [172.20.19.11] (unknown [213.61.67.157])
        by mail.holtmann.org (Postfix) with ESMTPSA id CC3E8CED0C;
        Sat, 26 Oct 2019 07:36:03 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH 0/3] ARM: dts: rockchip: Use hci_bcm driver for bcm43540
 on Veyron devices
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191025215428.31607-1-abhishekpandit@chromium.org>
Date:   Sat, 26 Oct 2019 07:27:02 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        dianders@chromium.org, devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4680AA6A-599F-4D5E-9A96-0655569BAE94@holtmann.org>
References: <20191025215428.31607-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> This patch series enables using the Broadcom HCI UART driver with the
> BCM43540 Wi-Fi + Bluetooth chip. This chip is used on a RK3288 based
> board (Veyron) and these changes have been tested on the Minnie variant
> of the board (i.e. rk3288-veyron-minnie.dts).
> 
> 
> 
> Abhishek Pandit-Subedi (3):
>  Bluetooth: hci_bcm: Add compatible string for BCM43540
>  dt-bindings: net: broadcom-bluetooth: Add BCM43540 compatible string
>  ARM: dts: rockchip: Add brcm bluetooth module on uart0
> 
> .../bindings/net/broadcom-bluetooth.txt       |  1 +
> arch/arm/boot/dts/rk3288-veyron.dtsi          | 31 +++++--------------
> drivers/bluetooth/hci_bcm.c                   |  1 +
> 3 files changed, 9 insertions(+), 24 deletions(-)

patches 1 and 2 have been applied to bluetooth-next tree. I leave patch 3 to the appropriate ARM maintainer to pick up.

Regards

Marcel

