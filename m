Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01787637503
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiKXJUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiKXJUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:20:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5286E116060
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:20:34 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oy8P4-000651-P6; Thu, 24 Nov 2022 10:20:18 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oy8P4-0001iy-5Z; Thu, 24 Nov 2022 10:20:18 +0100
Date:   Thu, 24 Nov 2022 10:20:18 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Bernie Huang <phhuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>
Subject: Re: [PATCH v3 00/11] RTW88: Add support for USB variants
Message-ID: <20221124092018.GG29978@pengutronix.de>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
 <20221122145527.GA29978@pengutronix.de>
 <015051d9a5b94bbca5135c58d2cfebf3@realtek.com>
 <20221124082158.GE29978@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124082158.GE29978@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 09:21:58AM +0100, Sascha Hauer wrote:
> On Thu, Nov 24, 2022 at 06:48:23AM +0000, Ping-Ke Shih wrote:
> > 
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Tuesday, November 22, 2022 10:55 PM
> > > To: Bernie Huang <phhuang@realtek.com>
> > > Cc: linux-wireless@vger.kernel.org; Ping-Ke Shih <pkshih@realtek.com>; Hans Ulli Kroll
> > > <linux@ulli-kroll.de>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>; netdev@vger.kernel.org;
> > > Kalle Valo <kvalo@kernel.org>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; linux-kernel@vger.kernel.org;
> > > Viktor Petrenko <g0000ga@gmail.com>; Neo Jou <neojou@gmail.com>; Bernie Huang <phhuang@realtek.com>;
> > > kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> > > Da Xue <da@libre.computer>
> > > Subject: Re: [PATCH v3 00/11] RTW88: Add support for USB variants
> > > 
> > > On Tue, Nov 22, 2022 at 03:52:15PM +0100, Sascha Hauer wrote:
> > > > This is the third round of adding support for the USB variants to the
> > > > RTW88 driver. There are a few changes to the last version which make it
> > > > worth looking at this version.
> > > >
> > > > First of all RTL8723du and RTL8821cu are tested working now. The issue
> > > > here was that the txdesc checksum calculation was wrong. I found the
> > > > correct calculation in various downstream drivers found on github.
> > > >
> > > > The second big issue was that TX packet aggregation was wrong. When
> > > > aggregating packets each packet start has to be aligned to eight bytes.
> > > > The necessary alignment was added to the total URB length before
> > > > checking if there is another packet to aggregate, so the URB length
> > > > included that padding after the last packet, which is wrong.  Fixing
> > > > this makes the driver work much more reliably.
> > > >
> > > > I added all people to Cc: who showed interest in this driver and I want
> > > > to welcome you for testing and reviewing.
> > > 
> > > There still is a problem with the RTL8822cu chipset I have here.  When
> > > using NetworkManager I immediately lose the connection to the AP after
> > > it has been connected:
> > > 
> > > [  376.213846] wlan0: authenticate with 76:83:c2:ce:81:b1
> > > [  380.085463] wlan0: send auth to 76:83:c2:ce:81:b1 (try 1/3)
> > > [  380.091446] wlan0: authenticated
> > > [  380.108864] wlan0: associate with 76:83:c2:ce:81:b1 (try 1/3)
> > > [  380.136448] wlan0: RX AssocResp from 76:83:c2:ce:81:b1 (capab=0x1411 status=0 aid=2)
> > > [  380.202955] wlan0: associated
> > > [  380.268140] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > > [  380.275328] wlan0: Connection to AP 76:83:c2:ce:81:b1 lost
> > > 
> > > That doesn't happen when using plain wpa_supplicant. This seems to go
> > > down to cd96e22bc1da ("rtw88: add beacon filter support"). After being
> > > connected I get a BCN_FILTER_CONNECTION_LOSS beacon. Plain
> > > wpa_supplicant seems to go another code patch and doesn't activate
> > > connection quality monitoring.
> > > 
> > > The connection to the AP works fluently also with NetworkManager though
> > > when I just ignore the BCN_FILTER_CONNECTION_LOSS beacon.
> > > 
> > > Any idea what may be wrong here?
> > > 
> > 
> > Please reference to below patch to see if it can work to you.
> > 
> > https://lore.kernel.org/linux-wireless/20221124064442.28042-1-pkshih@realtek.com/T/#u
> 
> Great! That solves this issue \o/

I am also happy to say that this patch is a real performance boost.
Here are some numbers:

RTL8723DU, no patch
===================
tx [  5]   0.00-10.00  sec  1.08 MBytes   903 Kbits/sec    1 sender
rx [  5]   0.00-10.26  sec  10.3 MBytes  8.41 Mbits/sec    0 sender

RTL8723DU, with patch
=====================
tx [  5]   0.00-10.00  sec  34.7 MBytes  29.1 Mbits/sec    9 sender
rx [  5]   0.00-10.05  sec  34.4 MBytes  28.7 Mbits/sec    5 sender

RTL8821CU, no patch
===================
tx [  5]   0.00-10.00  sec  6.01 MBytes  5.04 Mbits/sec    0 sender
rx [  5]   0.00-10.44  sec  53.4 MBytes  42.9 Mbits/sec    0 sender

RTL8821CU, with patch
===================
tx [  5]   0.00-10.00  sec  57.9 MBytes  48.6 Mbits/sec    0 sender
rx [  5]   0.00-10.15  sec  66.3 MBytes  54.8 Mbits/sec  419 sender

RTL8822CU, no patch
===================
tx [  5]   0.00-10.00  sec  11.8 MBytes  9.91 Mbits/sec    1 sender
rx [  5]   0.00-10.18  sec   105 MBytes  86.3 Mbits/sec  805 sender

RTL8822CU, with patch
===================
tx [  5]   0.00-10.01  sec  80.0 MBytes  67.1 Mbits/sec    0 sender
rx [  5]   0.00-10.12  sec   117 MBytes  97.2 Mbits/sec  658 sender

Tested with:

tx: iperf3 -c 192.168.0.57 -i0
rx: iperf3 -c 192.168.0.57 -i0 -R

Especially the RTL8723DU now starts being useful.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
