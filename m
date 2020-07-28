Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D642231669
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgG1XsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgG1XsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:48:17 -0400
X-Greylist: delayed 2069 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Jul 2020 16:48:16 PDT
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 772A8C061794;
        Tue, 28 Jul 2020 16:48:16 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 06SNCXiI022851;
        Wed, 29 Jul 2020 01:12:33 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 06SNCX2E015946;
        Wed, 29 Jul 2020 01:12:33 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 06SNCWBm015943;
        Wed, 29 Jul 2020 01:12:32 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Rob Herring <robh@kernel.org>, c.emde@osadl.org
Subject: Re: [PATCH v3 2/6] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Wed, 29 Jul 2020 01:12:31 +0200
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
Message-Id: <202007290112.32007.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 06SNCXiI022851
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-1.328, required 6, autolearn=not spam, BAYES_00 -0.50,
        KHOP_HELO_FCRDNS 0.12, NICE_REPLY_A -0.95, SPF_HELO_NONE 0.00,
        SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1596582754.89795@XM9drRIrFDItwaXL8PMKQQ
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On Saturday 04 of January 2020 00:53:59 Rob Herring wrote:
> On Sat, Dec 21, 2019 at 03:07:31PM +0100, pisa@cmp.felk.cvut.cz wrote:
> > From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> >
> > Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > ---
> >  .../devicetree/bindings/net/can/ctu,ctucanfd.txt   | 61
> > ++++++++++++++++++++++ 1 file changed, 61 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt
>
> Bindings are moving DT schema format now. Not something I'd require on a
> respin I've already reviewed, but OTOH it's been 10 months to respin
> from v2. So:
>
> Reviewed-by: Rob Herring <robh@kernel.org>
>
> If you have a v4, then please convert to a schema.

The first, thanks much for Device-tree part review, it is only
one received from relevant person for last six months.
So I have wait update for v4 patches and focused on teaching
forced to be distance one
  https://cw.fel.cvut.cz/wiki/courses/b35apo/lectures/start
another part of the CTU CAN FD project.

QEMU emulation for the CTU CAN FD IP core
is result of Jan Charvat's bachelor thesis led by me.
The patches are waiting for QEMU developers review

  https://lists.nongnu.org/archive/html/qemu-devel/2020-07/msg04653.html

The other people have significant interrest in our project,
Oliver Hartkopp, CAN in Automation representatives etc.

https://can-newsletter.org/hardware/semiconductors/200609_open-source-ip-core-compliant-with-iso-can-fd_ctu/

https://can-newsletter.org/hardware/semiconductors/181121_can-fd-core-as-an-open-project_university

Project is integrated into complex CAN LIN etc.. tester build for Skoda Auto based on Intel SoC as well.

I am trying to resolve that only one review feedback which I have received before v4
patches sending. I have spent half day to update and integrate self build packages
to my stable Debian to can run

   make -k dt_binding_check

but unfortunately, I have not achieved promissing result even when tested on Linux kernel
unpatched sources. I used actual git dt-schema/dt-doc-validate with 5.4 kernel
build but I get only long series of

pi@baree:/usr/src/linux-5.4-rt/_build/arm/px6$ make dt_binding_check -k
GNUmakefile:40: *** mixed implicit and normal rules: deprecated syntax
make -C /usr/src/linux-5.4-rt O=/usr/src/linux-5.4-rt/_build/arm/px6/ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- QTDIR=/usr/share/qt4 dt_binding_check
  CHKDT   Documentation/devicetree/bindings/arm/actions.yaml
/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/arm/actions.yaml:  found incompatible YAML document
  in "<unicode string>", line 2, column 1
make[3]: *** [/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/Makefile:12: Documentation/devicetree/bindings/arm/actions.example.dts] Error 1
  CHKDT   Documentation/devicetree/bindings/arm/al,alpine.yaml
/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/arm/al,alpine.yaml:  found incompatible YAML document
  in "<unicode string>", line 2, column 1
make[3]: *** [/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/Makefile:12: Documentation/devicetree/bindings/arm/al,alpine.example.dts] Error 1
  CHKDT   Documentation/devicetree/bindings/arm/altera.yaml
/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/arm/altera.yaml:  found incompatible YAML document
  in "<unicode string>", line 2, column 1
make[3]: *** [/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/Makefile:12: Documentation/devicetree/bindings/arm/altera.example.dts] Error 1
  CHKDT   Documentation/devicetree/bindings/arm/altera/socfpga-clk-manager.yaml
/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/arm/altera/socfpga-clk-manager.yaml:  found incompatible YAML document
  in "<unicode string>", line 2, column 1
make[3]: *** [/usr/src/linux-5.4-rt/Documentation/devicetree/bindings/Makefile:12: Documentation/devicetree/bindings/arm/altera/socfpga-clk-manager.example.dts] Error 1
  CHKDT   Documentation/devicetree/bindings/arm/amlogic.yaml

The same for ctu,ctucanfd.yam .
Please, if you have working setup, test if the followup content of
Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
is acceptable

Thanks in advance,

Pavel

# SPDX-License-Identifier: GPL-2.0
%YAML 1.2
---
$id: http://devicetree.org/schemas/net/can/ctu,ctucanfd.yaml#
$schema: http://devicetree.org/meta-schemas/core.yaml#

title: CTU CAN FD Open-source IP Core Device Tree Bindings

description: |
  Open-source CAN FD IP core developed at the Czech Technical University in Prague

  The core sources and documentation on project page
    [1] sources : https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core
    [2] datasheet : https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf

  Integration in Xilinx Zynq SoC based system together with
  OpenCores SJA1000 compatible controllers
    [3] project : https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top
  Martin Jerabek dimploma thesis with integration and testing
  framework description
    [4] PDF : https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf

maintainers:
  - Pavel Pisa <pisa@cmp.felk.cvut.cz>
  - Ondrej Ille <ondrej.ille@gmail.com>
  - Martin Jerabek <martin.jerabek01@gmail.com>

properties:
  compatible:
    oneOf:
      - items:
          - const: ctu,ctucanfd
          - const: ctu,canfd-2
      - const: ctu,ctucanfd

  reg:
    description:
      mapping into bus address space, offset and size
    maxItems: 1

  interrupts:
    description: |
      interrupt source. For Zynq SoC system, format is <(is_spi) (number) (type)>
      where is_spi defines if it is SPI (shared peripheral) interrupt,
      the second number is translated to the vector by addition of 32
      on Zynq-7000 systems and type is IRQ_TYPE_LEVEL_HIGH (4) for Zynq.
    maxItems: 1

  clocks:
    description: |
      phandle of reference clock (100 MHz is appropriate
      for FPGA implementation on Zynq-7000 system).
    maxItems: 1

required:
  - compatible
  - reg
  - interrupts
  - clocks

additionalProperties: false

examples:
  - |
    ctu_can_fd_0: can@43c30000 {
      compatible = "ctu,ctucanfd";
      interrupts = <0 30 4>;
      clocks = <&clkc 15>;
      reg = <0x43c30000 0x10000>;
    };
