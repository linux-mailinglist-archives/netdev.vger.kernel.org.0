Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2AD6B11D2
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCHTLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjCHTK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:10:58 -0500
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2D793E8;
        Wed,  8 Mar 2023 11:10:54 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        by mail11.truemail.it (Postfix) with ESMTPA id A6A03207B0;
        Wed,  8 Mar 2023 20:10:49 +0100 (CET)
Date:   Wed, 8 Mar 2023 20:10:45 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v7 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <ZAjdtRQEEycCw+52@francesco-nb.int.toradex.com>
References: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
 <20230306170525.3732605-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306170525.3732605-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 10:35:25PM +0530, Neeraj Sanjay Kale wrote:
> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into sleep state
> whenever there is no activity for 2000ms, and will be woken up when any
> activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending the vendor
> specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the chip
> by waiting for the bootloader signature, and downloads device specific FW
> file into the chip over UART if bootloader signature is received..
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

Hello Neeraj Sanjay Kale,
please do not forget to have a look at the questions [0] I send on v6.

Thanks,
Francesco

[0] https://lore.kernel.org/all/ZAX%2FHHyy2yL76N0K@francesco-nb.int.toradex.com/

