Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A043530835
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 06:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiEWEOz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 May 2022 00:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiEWEOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 00:14:53 -0400
X-Greylist: delayed 447 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 May 2022 21:14:49 PDT
Received: from mailproxy06.manitu.net (mailproxy06.manitu.net [217.11.48.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9087D140BC;
        Sun, 22 May 2022 21:14:49 -0700 (PDT)
Received: from [192.168.3.184] (cable-78-34-17-55.nc.de [78.34.17.55])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: linux@ulli-kroll.de)
        by mailproxy06.manitu.net (Postfix) with ESMTPSA id 60DD358011B;
        Mon, 23 May 2022 06:07:16 +0200 (CEST)
Message-ID: <55f569899e4e894970b826548cd5439f5def2183.camel@ulli-kroll.de>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
From:   Hans Ulli Kroll <linux@ulli-kroll.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Date:   Mon, 23 May 2022 06:07:16 +0200
In-Reply-To: <20220518082318.3898514-1-s.hauer@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> This series adds support for the USB chip variants to the RTW88 driver.
> 

Hi Sascha

glad you found some *working* devices for rtw88 !

I spend some of the weekend testing your driver submission.

for rtl8821cu devices I get following output

some Logilink device

[ 1686.605567] usb 1-5.1.2: New USB device found, idVendor=0bda, idProduct=c811, bcdDevice=
2.00
[ 1686.614186] usb 1-5.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1686.621721] usb 1-5.1.2: Product: 802.11ac NIC
[ 1686.626227] usb 1-5.1.2: Manufacturer: Realtek
[ 1686.630695] usb 1-5.1.2: SerialNumber: 123456
[ 1686.640480] rtw_8821cu 1-5.1.2:1.0: Firmware version 24.5.0, H2C version 12
[ 1686.932828] rtw_8821cu 1-5.1.2:1.0: failed to download firmware
[ 1686.945206] rtw_8821cu 1-5.1.2:1.0: failed to setup chip efuse info
[ 1686.951538] rtw_8821cu 1-5.1.2:1.0: failed to setup chip information
[ 1686.958402] rtw_8821cu: probe of 1-5.1.2:1.0 failed with error -22

above is same with some from Comfast

The worst in the list is one from EDUP

[ 1817.855704] rtw_8821cu 1-5.1.2:1.2: Firmware version 24.5.0, H2C version 12
[ 1818.153918] rtw_8821cu 1-5.1.2:1.2: rfe 255 isn't supported
[ 1818.165176] rtw_8821cu 1-5.1.2:1.2: failed to setup chip efuse info
[ 1818.171505] rtw_8821cu 1-5.1.2:1.2: failed to setup chip information

rtl8822bu devices are working fine ...

Hans Ulli
