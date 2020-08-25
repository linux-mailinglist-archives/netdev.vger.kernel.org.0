Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1A251550
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgHYJ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgHYJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:26:43 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61F21C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:26:40 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 07P9PiZd063077;
        Tue, 25 Aug 2020 11:25:44 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 07P9PhbJ023763;
        Tue, 25 Aug 2020 11:25:44 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 07P9Pg7v023760;
        Tue, 25 Aug 2020 11:25:42 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v5 5/6] can: ctucanfd: CTU CAN FD open-source IP core - platform and next steps and mainlining chances
Date:   Tue, 25 Aug 2020 11:25:41 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>
References: <cover.1597518433.git.ppisa@pikron.com> <4ceda3a9d68263b4e0dfe66521a46f40b2e502f7.1597518433.git.ppisa@pikron.com> <73e3dad8-9ab7-2f8f-312c-1957b4572b08@infradead.org>
In-Reply-To: <73e3dad8-9ab7-2f8f-312c-1957b4572b08@infradead.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202008251125.41514.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 07P9PiZd063077
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-2.35, required 6, autolearn=not spam, BAYES_00 -0.50,
        KHOP_HELO_FCRDNS 0.40, NICE_REPLY_A -2.25, SPF_HELO_NONE 0.00,
        SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1598952344.9039@HkfVtbUmYo4kbaG1GUmWow
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Randy and Rob,

thanks much for review, I have corrected FPGA spelling
and binding YAML license.

On Sunday 16 of August 2020 01:28:13 Randy Dunlap wrote:
> On 8/15/20 12:43 PM, Pavel Pisa wrote:
> > diff --git a/drivers/net/can/ctucanfd/Kconfig
> > b/drivers/net/can/ctucanfd/Kconfig index e1636373628a..a8c9cc38f216
> > 100644
> > --- a/drivers/net/can/ctucanfd/Kconfig
> > +++ b/drivers/net/can/ctucanfd/Kconfig
> > @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
> >  	  PCIe board with PiKRON.com designed transceiver riser shield is
> > available at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> >
> > +config CAN_CTUCANFD_PLATFORM
> > +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> > +	depends on OF
>
> Can this be
> 	depends on OF || COMPILE_TEST
> ?

I am not sure for this change. Is it ensured/documented somewhere that
header files provide dummy definition such way, that OF drivers builds
even if OF support is disabled? If I remember well, CTU CAN FD OF
module build fails if attempted in the frame of native x86_64
build where OF has been disabled. Does COMPILE_TEST ensure that
such build succeeds.

As for the next steps, I expect that without any review of Marc Kleine-Budde
or Wolfgang Grandegger from initial attempt for submission from February 2019,
we are at the end of the road now.

If there is confirmed preference, I would shorten license headers in the
C files, but I am not sure if SPDX-License-Identifier is recognized by 
copyright law and because code and CTU CAN FD IP can be used outside
of Linux kernel by others, we would like to keep legally binding preamble.
It is reduced by not listing address to obtain complete GPL-2.0 from anyway.
And change of preamble requires to update main repository, because
header files are generated from IP core IPXACT definition by Python
based tools. 

I am aware of only one other suggestion not followed yet and it
is separation of part of ctucan_tx_interrupt() function into new
one suggested by Pavel Machek. I agree that function length of 108
lines is big. When blank lines are removed we are on 68 lines and 28
lines are switch statement. The function consist of two nested loops.
External one required to ensure no lost interrupt when edge triggered
delivery or implementation is used. For me personally, it is more
readable in the actual format then to separate and propagate local
variables to another function. And particular function code received
only formatting and ctu_can_fd_ -> ctucan_hw_ rename in past year
so it is tested many/many times by manual PCI test and automated
Zynq tests. Each of the following pipelines which contains two jobs
ands by test of FPGA design and driver build and tests on real HW  

   https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/pipelines

You can go through years of the testing and development back.
So I have even tendency to not shuffle code which does not
result in indisputable better readability and breaks more than year
of unmodified code successful (pass) test result line and confidence.

Because I understand that you all are loaded a lot I expect that after
ACK/review-by by Rob, there is no need to send v6 to
  devicetree@vger.kernel.org
I am not sure about cross-post to
  netdev@vger.kernel.org
  linux-kernel@vger.kernel.org
when the progress is stuck on
  linux-can@vger.kernel.org
Problem is that linux-can seems to eat core driver patch, probably because it 
is too long.

Thanks to all for patience and if somebody does want to be loaded by minor
updates, resends and pings to linux-can, send me note to not bother you
again.

Thanks for your time,

Pavel

PS: I would be available on Drew Fustini's LPC 2020
    BoF: upstream drivers for open source FPGA SoC peripherals 
    today. If there is interrest I can provide some information
    and show some overview and results.

