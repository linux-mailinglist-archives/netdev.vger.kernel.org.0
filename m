Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1757D1368B4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgAJICH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:02:07 -0500
Received: from relay.felk.cvut.cz ([147.32.80.7]:56367 "EHLO
        relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgAJICH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:02:07 -0500
X-Greylist: delayed 1845 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2020 03:02:03 EST
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 00A7TWwh036195;
        Fri, 10 Jan 2020 08:29:32 +0100 (CET)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 00A7TWdf028346;
        Fri, 10 Jan 2020 08:29:32 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 00A7TVpw028343;
        Fri, 10 Jan 2020 08:29:31 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/6] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Fri, 10 Jan 2020 08:29:31 +0100
User-Agent: KMail/1.9.10
Cc:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net,
        wg@grandegger.com, davem@davemloft.net, mark.rutland@arm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz> <61533d59378822f8c808abf193b40070810d3d35.1576922226.git.pisa@cmp.felk.cvut.cz> <20200103235359.GA23875@bogus>
In-Reply-To: <20200103235359.GA23875@bogus>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202001100829.31344.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 00A7TWwh036195
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.223, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.28,
        SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1579246176.70847@vVg9umV9GG6Cdpbc0Ybbpg
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

thanks much for review.

On Saturday 04 of January 2020 00:53:59 Rob Herring wrote:
> On Sat, Dec 21, 2019 at 03:07:31PM +0100, pisa@cmp.felk.cvut.cz wrote:
> > From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> >  .../devicetree/bindings/net/can/ctu,ctucanfd.txt   | 61
>
> Bindings are moving DT schema format now. Not something I'd require on a
> respin I've already reviewed, but OTOH it's been 10 months to respin
> from v2. So:

Please, can you send me pointer to some CAN or other bindings
doc which is well formed according to future direction?
I have not dig deeper but I have not found relevant discussion
about introduction of DT schema format.

> If you have a v4, then please convert to a schema.

I expect that we need at least one more iteration.
When recheck, I have found that I have forgot to update
paths in RST documentation when moved from standalone
automatic CI build into kernel tree

[PATCH v3 6/6] docs: ctucanfd: CTU CAN FD open-source IP core documentation.
https://lkml.org/lkml/2019/12/21/96

And the most important is review of the driver core to allow
the project (http://canbus.pages.fel.cvut.cz/) to move forward.

[PATCH v3 3/6] can: ctucanfd: add support for CTU CAN FD open-source IP core - 
bus independent part.
https://lkml.org/lkml/2019/12/21/95

The code has no errors and a few questionable warnings reported by
4.19 patchcheck (we have run many iterations of it to cleanup code)
but 5.4 kernel patchcheck is more strict as I noticed
after submission and reports a few more warnings and some of them
could be easily resolved.

What makes me to feel good is that CTU CAN FD IP core development
stabilized, there are only changes to better cover the core by test
framework and more than one month there is no commit disturbing CI build
process of IP core integration for Xilinx Zynq. CI builds complete
driver and FPGA design and then deploys and runs tests between multiple
CTU CAN FD cores and against OpenCores SJA1000 cores with FD tolerance

https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/pipelines

https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/-/jobs/51334

The second link points to one of many logs of test running on MZ_APO
(Xilinx Zynq) education kits designed for Department of Control Engineering 
https://dce.fel.cvut.cz/en at PiKRON.com. MZ_APO kist are used in Computer 
Architectures and Real-time Systems Programming courses.

Thanks for help,

Pavel
