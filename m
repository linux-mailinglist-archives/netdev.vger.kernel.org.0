Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600641B7C23
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgDXQsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:48:23 -0400
Received: from mail.cccmz.de ([5.9.50.157]:43236 "EHLO mail.cccmz.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgDXQsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 12:48:23 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Apr 2020 12:48:21 EDT
Received: from [192.168.178.49] (x4d0c44b2.dyn.telefonica.de [77.12.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tanjeff@cccmz.de)
        by mail.cccmz.de (Postfix) with ESMTPSA id 7970417A07B2
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:41:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cccmz.de; s=2019;
        t=1587746478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
        bh=RHTODPy6lHM+TxPhcs0V4FsknvydDcIJZ+kIr55Sovc=;
        b=JrTabuNLznnI+WczuDCUV21lli6gT6U0e2pyfDj42u7zQWjGp3kcZ2BIsMe3ac+it+QfTv
        WaY1u1RDXoMYOxACQhjSBU5yaa4i8x53aZc2DXSaQTVzRgwTB5IbPa3oz3twKM8tvh7o8D
        n3yBrUfuTv1VWsqhdJY12QzFRoyrjTc=
To:     Networking <netdev@vger.kernel.org>
From:   Tanjeff Moos <tanjeff@cccmz.de>
Subject: How to operate 10Gbit SFP+ module if driver doesn't support SFP+?
Autocrypt: addr=tanjeff@cccmz.de; prefer-encrypt=mutual; keydata=
 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
 YAC/BUWuon8xl+Sm7fKHytJTyQ==
Message-ID: <25058311-191c-055a-5966-aeb14440db2b@cccmz.de>
Date:   Fri, 24 Apr 2020 18:41:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev list,

I hope that I'm at the right mailinglist for my question. If not, let me
know.


Abstract
--------

I'm trying to get a 10GBASE-SR SFP+ module running on a self-made board.
The MAC driver doesn't support phylink (i.e. no I²C accesses to the SFP+
registers), therefore I want to use PHY-less mode. On the other hand,
the "fixed-link" mode supports only up to 1 Gbit. The "in-band-status"
mode is said to not work with my setup. Thus I'm running out of options.
I ask you if there are further options to get things running.


About the hardware
------------------

My company built an access point containing an NXP QorIQ T1023 Soc. This
SoC includes a MAC which is connected to an SFP+ cage. We use XFI for
the connection between MAC and SFP+. In addition, the SFP+ module is
connected to the SoC via I²C to access its registers.


About the software
------------------

I am running OpenWRT with a Linux 4.14.137 kernel. There are patches on
that kernel (mostly from the OpenWRT project, some by us).


Details about the problem
-------------------------

For the MAC, I use the DPAA driver. This driver uses the kernels phylib
(a.k.a. PHY Abstraction Layer) to access its PHY. However, phylib
supports only MDIO-connected PHYs, not I²C connected devices. The kernel
also provides phylink which can access I²C devices *and* MDIO devices
(according to my understanding), but the DPAA driver does not support
phylink. Therefore, the SFP+ Module will not work in a "normal" way with
the DPAA driver.

Instead, I try to use PHY-less mode by adding the "fixed-link" keyword
to my DTS file. However, I can only configure up to 1 Gbit, but I need
10 Gbit.

There is an "in-band-status" keyword for the DTS file, but I didn't
understand what it does. An NXP supporter told me that this will not
work with XFI.

To summarize, I considered the following options:

- Operating SFP+ "normally", register access over I²C --> Not supported
  by MAC driver
- PHY-less operation with "fixed-link" --> does not support 10G
- PHY-less operation with "in-band-status" --> said to be no option,
  but I don't understand why


What I tried so far
--------------------

- Checked XFI link: I read the MACs registers, and it says the XFI link
  is up. I didn't find an equivalent register on the SFP+ side. The
  Ethernet switch (this is my link partner for the fiber link) says the
  link is up (LED is on).
- Reading SFP+ registers: I can actually read the registers of the SFP+
  module. I tried that on the U-boot commandline, just to test the I²C
  connection.
- Hacking the phylib: I tried to add 10G mode to the "fixed-link" mode
  and had limited success. My MAC can now receive packets but not send.
  I believe that the MAC still thinks the link were down. I'm currently
  working in that area.


My Question
-----------

- Is there a method to operate the SFP+ module in PHY-less mode which
  I'm unaware of?



Kind regards, Tanjeff

