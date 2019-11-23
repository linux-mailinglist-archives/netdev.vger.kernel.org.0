Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10E2107DFE
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 11:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKWKEn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 23 Nov 2019 05:04:43 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:55063 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKWKEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 05:04:43 -0500
Received: from marcel-macbook.holtmann.net (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8BD31CECBE;
        Sat, 23 Nov 2019 11:13:48 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v6 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354
 support
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191118192123.82430-1-abhishekpandit@chromium.org>
Date:   Sat, 23 Nov 2019 11:04:40 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org, dianders@chromium.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1CEDCBDC-221C-4E5F-90E9-898B02304562@holtmann.org>
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> While adding support for the BCM4354, I discovered a few more things
> that weren't working as they should have.
> 
> First, we disallow serdev from setting the baudrate on BCM4354. Serdev
> sets the oper_speed first before calling hu->setup() in
> hci_uart_setup(). On the BCM4354, this results in bcm_setup() failing
> when the hci reset times out.
> 
> Next, we add support for setting the PCM parameters, which consists of
> a pair of vendor specific opcodes to set the pcm parameters. The
> documentation for these params are available in the brcm_patchram_plus
> package (i.e. https://github.com/balena-os/brcm_patchram_plus). This is
> necessary for PCM to work properly.
> 
> All changes were tested with rk3288-veyron-minnie.dts.

so I have re-factored your patch set now to apply to latest bluetooth-next tree and posted it to the mailing list. Please have a look at it if this works for you. If it does, then we might just apply it this way and focus on getting detailed PCM codec configuration for all vendors in once we have a second vendor to unify it.

Regards

Marcel

