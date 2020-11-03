Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CFD2A4111
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgKCKBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCKBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:01:40 -0500
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86627C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 02:01:39 -0800 (PST)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 0A3A0bo6012959;
        Tue, 3 Nov 2020 11:00:37 +0100 (CET)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 0A3A0b9t028643;
        Tue, 3 Nov 2020 11:00:37 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 0A3A0a7u028642;
        Tue, 3 Nov 2020 11:00:36 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v7 0/6] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Tue, 3 Nov 2020 11:00:35 +0100
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1604095004.git.pisa@cmp.felk.cvut.cz> <2ccec201-1a84-1837-15a8-d2ad05f5753c@pengutronix.de>
In-Reply-To: <2ccec201-1a84-1837-15a8-d2ad05f5753c@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202011031100.35922.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 0A3A0bo6012959
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.098, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00,
        URIBL_BLOCKED 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1605002439.6287@ZlrwsaNtddJUcINn+dc1vg
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

thanks for response

On Saturday 31 of October 2020 12:35:11 Marc Kleine-Budde wrote:
> On 10/30/20 11:19 PM, Pavel Pisa wrote:
> > This driver adds support for the CTU CAN FD open-source IP core.
>
> Please fix the following checkpatch warnings/errors:

Yes I recheck with actual checkpatch, I have used 5.4 one
and may it be overlooked something during last upadates.

> -----------------------------------------
> drivers/net/can/ctucanfd/ctucanfd_frame.h
> -----------------------------------------
> CHECK: Please don't use multiple blank lines
> #46: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:46:

OK, we find a reason for this blank line in header generator.

> CHECK: Prefer kernel type 'u32' over 'uint32_t'
> #49: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:49:
> +	uint32_t u32;

In this case, please confirm that even your personal opinion
is against uint32_t in headers, you request the change.

uint32_t is used in many kernel headers and in this case
allows our tooling to use headers for mutual test of HDL
design match with HW access in the C.

If the reasons to remove uint32_t prevails, we need to
separate Linux generator from the one used for other
purposes. When we add Linux mode then we can revamp
headers even more and in such case we can even invest
time to switch from structure bitfields to plain bitmask
defines. It is quite lot of work and takes some time,
but if there is consensus I do it during next weeks,
I would like to see what is preferred way to define
registers bitfields. I personally like RTEMS approach
for which we have prepared generator from parsed PDFs
when we added BSP for TMS570 

  https://git.rtems.org/rtems/tree/bsps/arm/tms570/include/bsp/ti_herc/reg_dcan.h#n152

Other solution I like (biased, because I have even designed it)
is

  #define __val2mfld(mask,val) (((mask)&~((mask)<<1))*(val)&(mask))
  #define __mfld2val(mask,val) (((val)&(mask))/((mask)&~((mask)<<1)))
  https://gitlab.com/pikron/sw-base/sysless/-/blob/master/arch/arm/generic/defines/cpu_def.h#L314

Which allows to use simple masks, i.e.
  #define SSP_CR0_DSS_m  0x000f  /* Data Size Select (num bits - 1) */
  #define SSP_CR0_FRF_m  0x0030  /* Frame Format: 0 SPI, 1 TI, 2 Microwire */
  #define SSP_CR0_CPOL_m 0x0040  /* SPI Clock Polarity. 0 low between frames, 1 high */ #

  https://gitlab.com/pikron/sw-base/sysless/-/blob/master/libs4c/spi/spi_lpcssp.c#L46

in the sources

  lpcssp_drv->ssp_regs->CR0 =
                    __val2mfld(SSP_CR0_DSS_m, lpcssp_drv->data16_fl? 16 - 1 : 8 - 1) |
                    __val2mfld(SSP_CR0_FRF_m, 0) |
                    (msg->size_mode & SPI_MODE_CPOL? SSP_CR0_CPOL_m: 0) |
                    (msg->size_mode & SPI_MODE_CPHA? SSP_CR0_CPHA_m: 0) |
                    __val2mfld(SSP_CR0_SCR_m, rate);

  https://gitlab.com/pikron/sw-base/sysless/-/blob/master/libs4c/spi/spi_lpcssp.c#L217

If you have some preferred Linux style then please send us pointers.
In the fact, Ondrej Ille has based his structure bitfileds style
on the other driver included in the Linux kernel and it seems
to be a problem now. So when I invest my time, I want to use style
which pleases me and others.

Thanks for the support and best wishes,

Pavel Pisa
