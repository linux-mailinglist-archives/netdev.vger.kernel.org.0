Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4744F5C56
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiDFLef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiDFLcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:32:21 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA656FD22;
        Wed,  6 Apr 2022 01:20:47 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 0D75130ADE7F;
        Wed,  6 Apr 2022 10:20:45 +0200 (CEST)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 1D2BF30ADE4A;
        Wed,  6 Apr 2022 10:20:44 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 2368KhCX018534;
        Wed, 6 Apr 2022 10:20:43 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 2368KhL8018533;
        Wed, 6 Apr 2022 10:20:43 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Wed, 6 Apr 2022 10:20:42 +0200
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
        Drew Fustini <pdp7pdp7@gmail.com>,
        Mataj Vasilevski <vasilmat@fel.cvut.cz>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz> <202203220918.33033.pisa@cmp.felk.cvut.cz> <20220322092212.f5eaxm5k45j5khra@pengutronix.de>
In-Reply-To: <20220322092212.f5eaxm5k45j5khra@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202204061020.42943.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc and others,

On Tuesday 22 of March 2022 10:22:12 Marc Kleine-Budde wrote:
> On 22.03.2022 09:18:32, Pavel Pisa wrote:
> > > The driver looks much better now. Good work. Please have a look at the
> > > TX path of the mcp251xfd driver, especially the tx_stop_queue and
> > > tx_wake_queue in mcp251xfd_start_xmit() and mcp251xfd_handle_tefif(). A
> > > lockless implementation should work in your hardware, too.
> >
> > Is this blocker for now? I would like to start with years tested base.
>
> Makes sense.

I have missed timing for 5.18 but v5.18-rc1 is out so I would be
happy if we do not miss 5.19 merge window at least with minimal version.

If we succeeds in review reasonably early we could fit with inclusion
or at least the first review round of Mataj Vasilevski's 

  https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/tree/hw-timestamping

Please, help us to finish this subsequent goal of our portfolio development.
I think that our work is valuable for the community, code can be tested
even in QEMU CAN bus subsystem which we architected as well

  https://www.qemu.org/docs/master/system/devices/can.html

I hope that it is usable for others. I have the last support call from
Magdeburg University where they use CAN emulation for some Volkswagen
projects. The Xilinx uses code for their CAN FD controllers emulation.
Thei have whole stack including mainline driver for their CAN FD controller
in mainline but on the other hand, their CAN FD is bound to Xilinx devices
emulation. But CTU CAN FD provides generic PCI integration and can be used
even on broad range of FPGAs so its emulation and matching driver provides
valuable tool even if you do not consider use its actual design on hardware.

New version of the latency tester based on CTU CAN FD timestamping
is in preparation as upgrade of original Martin Jerabek's
work done on Oliver Hartkopp's and Volkswagen call

  
https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/wikis/uploads/56b4d27d8f81ae390fc98bdce803398f/F3-BP-2016-Jerabek-Martin-Jerabek-thesis-2016.pdf

Best wishes,

                Pavel
--
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://dce.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

