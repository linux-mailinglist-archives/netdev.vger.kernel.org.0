Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4642AA88A0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfIDOTk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 10:19:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56859 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDOTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:19:40 -0400
Received: from marcel-macbook.fritz.box (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id 15095CECB0;
        Wed,  4 Sep 2019 16:28:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RESEND PATCH 0/5] Add bluetooth support for Orange Pi 3
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190830132034.u65arlv7umh64lx6@flea>
Date:   Wed, 4 Sep 2019 16:19:37 +0200
Cc:     megous@megous.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <76FD40C7-10C5-4818-8EF9-60326ECA4243@holtmann.org>
References: <20190823103139.17687-1-megous@megous.com>
 <5524D5E9-FA82-4244-A91F-78CF1C3FB3FB@holtmann.org>
 <20190830092104.odipmbflounqpffo@flea>
 <D02B89FB-F8C0-40AD-A99A-6C1B4FEB72A0@holtmann.org>
 <20190830132034.u65arlv7umh64lx6@flea>
To:     Maxime Ripard <mripard@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

>>>>> (Resend to add missing lists, sorry for the noise.)
>>>>> 
>>>>> This series implements bluetooth support for Xunlong Orange Pi 3 board.
>>>>> 
>>>>> The board uses AP6256 WiFi/BT 5.0 chip.
>>>>> 
>>>>> Summary of changes:
>>>>> 
>>>>> - add more delay to let initialize the chip
>>>>> - let the kernel detect firmware file path
>>>>> - add new compatible and update dt-bindings
>>>>> - update Orange Pi 3 / H6 DTS
>>>>> 
>>>>> Please take a look.
>>>>> 
>>>>> thank you and regards,
>>>>> Ondrej Jirman
>>>>> 
>>>>> Ondrej Jirman (5):
>>>>> dt-bindings: net: Add compatible for BCM4345C5 bluetooth device
>>>>> bluetooth: bcm: Add support for loading firmware for BCM4345C5
>>>>> bluetooth: hci_bcm: Give more time to come out of reset
>>>>> arm64: dts: allwinner: h6: Add pin configs for uart1
>>>>> arm64: dts: allwinner: orange-pi-3: Enable UART1 / Bluetooth
>>>>> 
>>>>> .../bindings/net/broadcom-bluetooth.txt       |  1 +
>>>>> .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 19 +++++++++++++++++++
>>>>> arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  | 10 ++++++++++
>>>>> drivers/bluetooth/btbcm.c                     |  3 +++
>>>>> drivers/bluetooth/hci_bcm.c                   |  3 ++-
>>>>> 5 files changed, 35 insertions(+), 1 deletion(-)
>>>> 
>>>> all 5 patches have been applied to bluetooth-next tree.
>>> 
>>> The DTS patches (last 2) should go through the arm-soc tree, can you
>>> drop them?
>> 
>> why is that? We have included DTS changes for Bluetooth devices
>> directly all the time. What is different with this hardware?
> 
> I guess some maintainers are more relaxed with it than we are then,
> but for the why, well, it's the usual reasons, the most immediate one
> being that it reduces to a minimum the conflicts between trees.
> 
> The other being that it's not really usual to merge patches supposed
> to be handled by another maintainer without (at least) his
> consent. I'm pretty sure you would have asked the same request if I
> would have merged the bluetooth patches through my tree without
> notice.

I took the two DTS patches out now and let the submitter deal with getting these merged.

Regards

Marcel

