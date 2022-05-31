Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA1538C2D
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244579AbiEaHnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244578AbiEaHm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:42:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D45D49919
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:42:58 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvwWb-0004H2-UK; Tue, 31 May 2022 09:42:45 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvwWa-0008IW-1P; Tue, 31 May 2022 09:42:44 +0200
Date:   Tue, 31 May 2022 09:42:44 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Message-ID: <20220531074244.GN1615@pengutronix.de>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
 <20220530135457.1104091-11-s.hauer@pengutronix.de>
 <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 01:07:36AM +0000, Ping-Ke Shih wrote:
> On Mon, 2022-05-30 at 15:54 +0200, Sascha Hauer wrote:
> > The powersave modes do not work with USB devices (tested with a
> > RTW8822CU) properly. With powersave modes enabled the driver issues
> > messages like:
> > 
> > rtw_8822cu 1-1:1.2: firmware failed to leave lps state
> > rtw_8822cu 1-1:1.2: timed out to flush queue 3
> 
> Could you try module parameter rtw_disable_lps_deep_mode=1 to see
> if it can work?

No, this module parameter doesn't seem to make any difference.

# cat /sys/module/rtw88_core/parameters/disable_lps_deep
Y

Still "firmware failed to leave lps state" and poor performance.

Any other ideas what may go wrong here?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
