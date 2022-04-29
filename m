Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E60D5156F1
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiD2Vf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiD2VfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:35:25 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A93CD31A;
        Fri, 29 Apr 2022 14:32:04 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id C194830B2973;
        Fri, 29 Apr 2022 23:31:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=8E2Pp
        TS7n9xW37sbOCeIa2pfel4R8e9bbsE/XDKa1ac=; b=ATYNItrSv5swcys+qHwYw
        uBBkhjSC8WJzE8jBRqNPntvy1YAaqnfaN6nWEYyfhwiNyHRJbVvz9GI06RwiOEC7
        evg5CzzWCXfNrizYv2CrMIcnJRgB7igDADqFqnXjhcaSUnBR2How+bGYOdyZKhyg
        HpWp/etxJ/um6qXP6NfZ2y0ECBFy/RydBRHY89SQvCbs2MxOjMNr4f3aw4ThSgPD
        J6fgW4hPM40Qkbh3QDNDLT58BCprpMzl4ViZjRYiqY1uGTRot1sW6FH9QrBHDblq
        k4y0VboDk0DmrU1AeApHQEhMz3sGvIkLcaxSANRdbhHNa3V/6ylXkjPegGqFrkr7
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 01C7030B2942;
        Fri, 29 Apr 2022 23:31:31 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23TLVUGH005586;
        Fri, 29 Apr 2022 23:31:30 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23TLVTna005582;
        Fri, 29 Apr 2022 23:31:29 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual rules and documentation linking
Date:   Fri, 29 Apr 2022 23:31:28 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Andrew Dennison <andrew.dennison@motec.com.au>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz> <20220428072239.kfgtu2bfcud6tetc@pengutronix.de>
In-Reply-To: <20220428072239.kfgtu2bfcud6tetc@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202204292331.28980.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Thursday 28 of April 2022 09:22:39 Marc Kleine-Budde wrote:
> > Jiapeng Chong (2):
> >   can: ctucanfd: Remove unnecessary print function dev_err()
> >   can: ctucanfd: Remove unused including <linux/version.h>
>
> I had these already applied.
>
> > Pavel Pisa (2):
> >   can: ctucanfd: remove PCI module debug parameters and core debug
> >     statements.
> >   docs: networking: device drivers: can: add ctucanfd and its author
> >     e-mail update
>
> Split into separate patches and applied.

Excuse me for late reply and thanks much for split to preferred
form. Matej Vasilevski has tested updated linux-can-next testing
on Xilinx Zynq 7000 based MZ_APO board and used it with his
patches to do proceed next round of testing of Jan Charvat's NuttX
TWAI (CAN) driver on ESP32C3. We plan that CTU CAN FD timestamping
will be send for RFC/discussion soon.

I would like to thank to Andrew Dennison who implemented, tested
and shares integration with LiteX and RISC-V

  https://github.com/litex-hub/linux-on-litex-vexriscv

He uses development version of the CTU CAN FD IP core with configurable
number of Tx buffers (2 to 8) for which will be required
automatic setup logic in the driver.

I need to discuss with Ondrej Ille actual state and his plans.
But basically ntxbufs in the ctucan_probe_common() has to be assigned
from TXTB_INFO TXT_BUFFER_COUNT field. For older core version
the TXT_BUFFER_COUNT field bits should be equal to zero so when
value is zero, the original version with fixed 4 buffers will
be recognized. When value is configurable then for (uncommon) number
of buffers which is not power of two, there will be likely
a problem with way how buffers queue is implemented

  txtb_id = priv->txb_head % priv->ntxbufs;
  ...
  priv->txb_head++;
  ...
  priv->txb_tail++;

When I have provided example for this type of queue many years
ago I have probably shown example with power of 2 masking,
but modulo by arbitrary number does not work with sequence
overflow. Which means to add there two "if"s unfortunately

  if (++priv->txb_tail == 2 * priv->ntxbufs)
      priv->txb_tail = 0;

We need 2 * priv->ntxbufs range to distinguish empty and full queue...
But modulo is not nice either so I probably come with some other
solution in a longer term. In the long term, I want to implement
virtual queues to allow multiqueue to use dynamic Tx priority
of up to 8 the buffers...

Best wishes,

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

