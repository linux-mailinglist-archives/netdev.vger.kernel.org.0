Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C1525DF2
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378349AbiEMIja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378346AbiEMIj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:39:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B242631E5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:39:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npQpW-0007di-A4
        for netdev@vger.kernel.org; Fri, 13 May 2022 10:39:22 +0200
Received: from [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400] (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AC05F7D752
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:39:21 +0000 (UTC)
Received: from bjornoya.blackshift.org
        by bjornoya with LMTP
        id I8qPBQsbfWJ2HwYAs6a69A
        (envelope-from <david@protonic.nl>)
        for <mkl-all@blackshift.org>; Thu, 12 May 2022 14:34:51 +0000
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 02D967CAD4
        for <mkl-all@blackshift.org>; Thu, 12 May 2022 14:34:51 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E954F7CAD3
        for <ptx@kleine-budde.de>; Thu, 12 May 2022 14:34:50 +0000 (UTC)
Received: from smtp15.bhosted.nl ([2a02:9e0:8000::26])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <david@protonic.nl>)
        id 1np9tw-0006WR-Ul
        for mkl@pengutronix.de; Thu, 12 May 2022 16:34:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=protonic.nl; s=202111;
        h=content-transfer-encoding:content-type:mime-version:message-id:subject:cc:to:
         from:date:from;
        bh=9ekpzF3jYn/kEujr+rEe+H+oidDP0NgfPGgN82Dz238=;
        b=J6GgBiuJJc/IzGC4H6D11R7b2DYPyyWVzaEPZSPnBj+LjCLUfQm4gH+2aPag79sirG0lpxGNONSRc
         ol1YEe9DyPn8Env8gqi2Bq5lglzgR5dOUWJBXOfrbNCdeOdxi+ySePN/EZNOB+YsnDPJFxtkzfidyR
         P2E25IFAQ6cbQqlckCO+JIfW72YtSEjwuCZ6O0QkOT79WYGi+d4StwI2TIJ6eZaJcpKizCyMbO4r3H
         apGs4RuA0JxKOA8qWCTNOVpI2RnQ/CBF0ZwvEcUgo7bz9lUnAPaxqEjhksS9/qvAC26frT50ssRwNk
         +xVAYRmVfDRRKWgTbumpZGKfOmAbOsA==
X-MSG-ID: ab9cffcd-d200-11ec-b450-0050569d3a82
Date:   Thu, 12 May 2022 16:34:45 +0200
From:   David Jander <david@protonic.nl>
To:     linux-spi@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <ore@pengutronix.de>
Message-ID: <20220512163445.6dcca126@erd992>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
Subject: [RFC] A new SPI API for fast, low-latency regmap peripheral access
X-PTX-Original-Recipient: mkl@pengutronix.de
X-PTX-Original-Recipient: ptx@kleine-budde.de
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Mark, all,

Sorry for sending an RFC without actual patches. What I am about to propose
would require a lot of work, and I am sure I will not get it right without
first asking for comments. I also assume that I might not be the only one
asking/proposing this, and may ignore the existence of discussions that may
have happened in the past. If I am committing a crime, please accept my
apologies and let me know.

TL;DR: drivers/spi/spi.c API has too much overhead for some use cases.

1. How did I get here?
----------------------

Software involved: Linux v5.18-rc1:
 drivers/spi/spi.c
 drivers/spi/spi-imx.c (note in text for extra patches)
 drivers/net/can/spi/mcp251xfd/*

Hardware involved:
 i.MX8MP SoC with external SPI CAN controller MCP2518FD.

Using an i.MX8MP SoC with an external CAN interface via SPI, the mcp2518fd
controller, I noticed suspiciously high latency when running a simple tool that
would just echo CAN messages back. After applying Marc Kleine-Budde's patches
here [1], things got a lot better, but I was already looking too close.
Analyzing the SPI/CAN timing on a scope, I noticed at first a big delay from
CS to the start of the actual SPI transfer and started digging to find out
what caused this delay.

2. What did I do?
-----------------

Looking at spi.c, I noticed a lot of code that is being executed even for the
SYNC code-path, that should avoid the workqueue, doing statistics mainly,
involving quite a few spinlocks. I wanted to know what the impact of all of
that code was, so I hacked together a new API postfixed with *_fast that did
roughly the same as the spi_sync_* API, but without all of this accounting
code. Specifically, I created substitutes for the following functions, which
are all SPI API calls used by the MCP2518FD driver:

 spi_sync()
 spi_sync_transfer()
 spi_write()
 spi_write_then_read()
 spi_async() (replaced with a sync equivalent)

3. Measurement results
----------------------

I distinguish between 3 different kernels in the following measurement results:

 kernel A: Vanilla Linux 5.18-rc1
 kernel B: Linux 5.18-rc1 with Marc's polling patches from linux-next applied
 to spi-imx.c [1]
 kernel C: Linux 5.18-rc1 with polling patches and hacked *_fast SPI API.

The measurements were conducted by running "canecho.c" [2] on the target
board, while executing the following command on another machine connected via
CAN (baud-rate 250kBaud):

$ cangen can0 -g 10 -n 1000 -p 2 -I 0x077 -L 8 -D r

For CPU load measurements, the following command was used instead:

$ cangen can0 -g 0 -n 50000 -p 2 -I 0x077 -L 8 -D r

The machine running cangen is able to load the CAN bus to 100% capacity
consistently this way.

3.1. SPI signal timing measurements

Scope images are available on request.

3.1.1. Gap between RX CAN frame EOF and TX echo response SOF:

Kernel A: 380us
Kernel B: 310us
Kernel C: 152us

3.1.2. Total time the SPI controller IRQ line is low:

Kernel A: 160us
Kernel B: 144us
Kernel C: 55us

3.1.3. Time from SPI CS active to actual start of transfer:

Kernel A: ca. 10us
Kernel B: 9.8us
Kernel C: 2.6us

3.1.4. Time of CS high between 1st and 2nd SPI sync access from IRQ thread:

kernel A: ca 25us
kernel B: ca 30us
kernel C: 5us

3.2. CPU usage measurements with 100% bus load running canecho at 250kBaud:

kernel A: 13.3% [irq/210-spi2.0], 78.5% idle
kernel B: 10.2% [irq/210-spi2.0], 81.6% idle
kernel C: 4.4%  [irq/210-spi2.0], 92.9% idle

Overall performance improvements from kernel B to kernel C:

CAN message round trip time: 50% faster
CPU load: 61% less

4. Rationale
------------

There are many use-cases for SPI in the Linux kernel, and they all have
special requirements and trade-offs: On one side one wants to transfer large
amount of data to the peripheral efficiently (FLASH memory) and without
blocking. On the opposite side there is the need to modify registers in a
SPI-mapped peripheral, ideally using regmap.
There are two APIs already: sync and async, that should cover these use-cases.
Unfortunately both share a large portion of the code path, which causes the
sync use-case for small, fast register manipulation to be bogged down by all
the accounting and statistics code. There's also sometimes memcpy()'s involved
to put buffers into DMA space (driver dependent), even though DMA isn't used.

So a "peripheral" driver (the P from SPI coincidentally), that accesses a
SPI-based regmap doing register manipulation, leading to several very short
and small, fast transfers end's up with an unreasonable CPU load and access
latency, even when using the *sync* API.

Assuming the *sync* API cannot be changed, this leads to the need to introduce
a new API optimized specifically for this use-case. IMHO it is also reasonable
to say that when accessing registers on a peripheral device, the whole
statistics and accounting machinery in spi.c isn't really so valuable, and
definitely not worth its overhead in a production system.

5. Details of the SPI transfers involved
----------------------------------------

The MCP2518FD CAN driver does a series of small SPI transfers when running a
single CAN message from cangen to canecho and back:

 1. CAN message RX, IRQ line asserted
 2. Hard IRQ empty, starts IRQ thread
 3. IRQ thread interrogates MCP2518FD via register access:
 3.1. SPI transfer 1: CS low, 72bit xfer, CS high
 3.2. SPI transfer 2: CS low, 200bit xfer, CS high
 3.3. SPI transfer 3: CS low, 72bit xfer, CS high
 3.4. SPI transfer 4: CS low, 104bit xfer, CS high
 4. IRQ thread ended, RX message gets delivered to user-space
 5. canecho.c recv()
 6. canecho.c send()
 7. TX message gets delivered to CAN driver
 8. CAN driver does spi_async to queue 2 xfers (replace by spi_sync equivalent
 in kernel C):
 8.1. SPI message 1: CS low, 168bit xfer, CS high, CS low, 48bit xfer, CS high
 9. CAN message SOF starts appearing on the bus just before last CS high.

6. Some regions of code that were inspected
-------------------------------------------

The code in spi.c that gets executed contains a lot of ifs and foresees a lot
of different situations, so it might not be trivial to look at a single place
and find a smoking gun. It is more the sum of everything that just takes a
long time to execute, even on this relatively fast ARM Cortex-A53 running at
1.2GHz.
Some places I tried to single out:

6.1. Accounting spinlocks:

Spinlocks are supposed to be fast, especially for the case that they are not
contested, but in such critical paths their impact shouldn't be neglected.

SPI_STATISTICS_ADD_TO_FIELD: This macro defined in spi.h has a spinlock, and
it is used 4 times directly in __spi_sync(). It is also used in
spi_transfer_one_message() which is called from there. Removing the spinlocks
(thus introducing races) makes the code measurably faster (several us).

spi_statistics_add_transfer_stats(): Called twice from
spi_transfer_one_message(), and also contains a spinlock. Removing these again
has a measurable impact of several us.

6.2. Misc other places:

ptp_read_system_prets(): Called once, since the hardware lacks a usable TS
counter. Removing this did not have a significant impact, although it was
still detectable, but barely so.

spi_set_cs(): Removing all delay code and leaving the bare minimum for GPIO
based CS activation again has a measurable impact. Most (all?) simple SPI
peripheral chips don't have any special CS->clock->CS timing requirements, so
it might be a good idea to have a simpler version of this function.

7. Requirements and compromises for the new API
-----------------------------------------------

Since this hypothetical new API would be used only for very short, very fast
transfers where latency and overhead should be minimized, the best way to do
it is obviate all scheduling work and do it strictly synchronous and based on
polling. The context switch of even a hard-IRQ can quickly cost a lot more CPU
cycles than busy waiting for 48 bits to be shifted through the transmitter at
20+MHz clock. This requires that SPI drivers offer low-level functions that do
such simple transfers on polling basis. The patches [1] from Marc Kleine-Budde
already do this, but it is the SPI driver that choses whether to use polling or
IRQ based transfers based on heuristics calculating the theoretical transfer
time given the clock frequency and its size. While it improves the performance
in a lot of cases already, peripheral drivers have no choice but to still go
through all the heavy code in spi.c.
Since these are low-latency applications, chances are very high that the
hardware is also designed for low-latency access, which implies that CS
control via GPIO most probably uses local GPIO controllers instead of I2C GPIO
expanders for example, so CS access can be assumed to be fast and direct and
not involve any context switches. It could be argued that it might even be
beneficial to have an API that can be called from hard IRQ context, but
experiments in this case showed that the gain of doing the CAN message read
out directly in hard-IRQ and removing the IRQ thread is minimal. But better
use-cases could be conceived, so this possibility might need consideration
also.
Obviously all statistics accounting should be skipped for this API, since it
simply impacts performance far too much.
Care should be taken to solve locking in such a way, that it doesn't impact
performance for the fast API, while still allowing safe concurrency with
spi_sync and spi_async. I did not go as far as to solve this issue. I just
used a simple spinlock and carefully avoided using any call to the old API for
doing these proof-of-concept measurements.

8. Conclusion
-------------

Performance of spi.c API for the specified use-cases is not ideal.
Unfortunately there is no single smoking gun to be pointed at, but instead
many different bits which are not needed for the given use-case that add to
the bloat and ultimately have a big combined performance impact.
The stated usage scenario is fairly common in the Linux kernel. A simple
investigation counted 60+ IIO drivers and 9 input drivers alone that use
spi_sync*() for example, up to a total of 171 .c files. In contrast only 11 .c
files use the spi_async*() calls. This does not account for all users of
regmap_spi.
Due to this, IMHO one can ask for a better, simpler, more efficient API for
these use-cases, am I want to propose to create it.

Thanks a lot if you read this far. Please let me know if such a thing is even
thinkable in mainline Linux.


[1] https://lore.kernel.org/all/20220502175457.1977983-9-mkl@pengutronix.de/
[2] https://github.com/linux-can/can-tests/blob/master/raw/canecho.c

Best regards,

-- 
David Jander
Protonic Holland.

