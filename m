Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361884E3496
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiCUXlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiCUXlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:41:49 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74113120C;
        Mon, 21 Mar 2022 16:40:21 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id A4C3F30AE000;
        Tue, 22 Mar 2022 00:32:37 +0100 (CET)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 4E22F30ADC00;
        Tue, 22 Mar 2022 00:32:36 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 22LNWZhk014191;
        Tue, 22 Mar 2022 00:32:35 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 22LNWZqU014190;
        Tue, 22 Mar 2022 00:32:35 +0100
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
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
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Tue, 22 Mar 2022 00:32:27 +0100
Message-Id: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver adds support for the CTU CAN FD open-source IP core.
More documentation and core sources at project page
(https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
The core integration to Xilinx Zynq system as platform driver
is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
Implementation on Intel FPGA based PCI Express board is available
from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctucanfd).
The CTU CAN FD core emulation send for review for QEMU mainline.
Development repository for QEMU emulation - ctu-canfd branch of
  https://gitlab.fel.cvut.cz/canbus/qemu-canbus

More about CAN bus related projects used and developed at CTU FEE
on the guidepost page http://canbus.pages.fel.cvut.cz/ .

Martin Jerabek (1):
  can: ctucanfd: add support for CTU CAN FD open-source IP core - bus
    independent part.

Pavel Pisa (6):
  dt-bindings: vendor-prefix: add prefix for the Czech Technical
    University in Prague.
  dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
  can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
  can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
  docs: ctucanfd: CTU CAN FD open-source IP core documentation.
  MAINTAINERS: Add maintainers for CTU CAN FD IP core driver

The version 8 changes:
  - sent at 2022-03-22
  - Ondrej Ille has extended ipxact to VHDL and header
    files generator to generate header files according
    to the last Pavel Machek's and Marc Kleine-Budde's
    review
  - The code has been gradually updated and throughly
    tested with more 5.x kernels on QEMU and HW even with
    fully preemptive kernels. This series has been quickly
    tested with 5.17 kernel.

The version 7 changes:
  - sent at 2020-10-31
  - In response of Pavel Machek review, renamed files to match
    directly module names. The core specification updated
    to provide better description and match of the fields.
    Driver headers, routines adjusted etc..  To achieve this,
    registers HDL was regenerated and  and its connection updated.
  - CAN_STATE_* translation to text has been made robust to
    Linux kernel define value changes/updates and the function
    which uses table has moved after table for better readability.
  - fsm_txt_buffer_user.svg redrawn from scratch to reduce
    file to 16 kB.
  - documentation updated, unified references to recently renamed
    pcie-ctucanfd
  - I have tried to fullfill request to cross-reference SocketCAN
    document by :doc: or :ref: constructs in Sphinx way,
    but without success. I reference geerated HTML on kernel.org
    site for now.

The version 6 changes:
  - sent at 2020-10-22
  - the driver has been tested with 5.9 bigendian MIPS kernel
    against QEMU CTU CAN FD model and correct behavior on PCIe
    virtual board for big-endian system passed
  - documentation updated to reflect inclusion of SocketCAN FD
    and CTU CAN FD functional model support into QEMU mainline
  - the integration for Cyclone V 5CSEMA4U23C6 based DE0-Nano-SoC
    Terasic board used for SkodaAuto research projects at our
    university has been clean up by its author (Jaroslav Beran)
    and published
    https://gitlab.fel.cvut.cz/canbus/intel-soc-ctucanfd
  - Xilinx Zynq Microzed MZ_APO based target for automatic test
    updated to Debian 10 base.

The version 5 changes:
  - sent at 2020-08-15
  - correct Kconfig formatting according to Randy Dunlap
  - silence warnings reported by make W=1 C=1 flags.
    Changes suggested by Jakub Kicinski
  - big thanks for core patch review by Pavel Machek
    resulting in more readability and formating updates
  - fix power management errors found by Pavel Machek
  - removed comments from d-t bindings as suggested by Rob Herring
  - selected ctu,ctucanfd-2 as alternative name to ctu,ctucanfd
    which allows to bind to actual major HDL core sources version 2.x
    if for some reason driver adaptation would not work on version
    read from the core
  - line length limit relaxed to 100 characters on some cases
    where it helps to readability

The version 4 changes:
  - sent at 2020-08-04
  - changes summary, 169 non-merge commits, 6 driver,
    32 IP core sources enhancements and fixes, 58 tests
    in master and about additional 30 iso-testbench
    preparation branch.
  - convert device-tree binding documentation to YAML
  - QEMU model of CTU CAN FD IP core and generic extension
    of QEMU CAN bus emulation developed by Jan Charvat.
  - driver tested on QEMU emulated Malta big-endian MIPS
    platform and big endian-support fixed.
  - checkpatch from 5.4 kernel used to cleanup driver formatting
  - header files generated from IP core IP-Xact description
    updated to include protocol exception (pex) field.
    Mechanism to set it from the driver is not provided yet.

The version 3 changes:
  - sent at 2019-12-21
  - adapts device tree bindings documentation according to
    Rob Herring suggestions.
  - the driver has been separated to individual modules for core support,
    PCI bus integration and platform, SoC integration.
  - the FPGA design has been cleaned up and CAN protocol FSM redesigned
    by Ondrej Ille (the core redesign has been reason to pause attempts to driver
    submission)
  - the work from February 2019 on core, test framework and driver
    1601 commits in total, 436 commits in the core sources, 144 commits
    in the driver, 151 documentation, 502 in tests.
  - not all continuous integration tests updated for latest design version yet
    https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/pipelines
  - Zynq hardware in the loop test show no issues for after driver PCI and platform
    separation and latest VHDL sources updates.
  - driver code has been periodically tested on 4.18.5-rt3 and 4.19 long term
    stable kernels.
  - test of the patches before submission is run on 5.4 kernel
  - the core has been integrated by Jaroslav Beran <jara.beran@gmail.com>
    into Intel FPGA based SoC used in the tester developed for Skoda auto
    at Department of Measurement, Faculty of Electrical Engineering,
    Czech Technical University https://meas.fel.cvut.cz/ . He has contributed
    feedback and fixes to the project.

The version 2 sent at 2019-02-27

The version 1 sent at 2019-02-22

Ondrej Ille has prepared the CTU CAN IP Core sources for new release.
We are waiting with it for the driver review, our intention
is to release IP when driver is reviewed and mainlined.

DKMS CTU CAN FD driver build by OpenBuildService to ease integration
into Debian systems when driver is not provided by the distribution

https://build.opensuse.org/package/show/home:ppisa/ctu_can_fd

Jan Charvat <charvj10@fel.cvut.cz> finished work to extend already
mainlined QEMU SJA1000 and SocketCAN support to provide even CAN FD
support and CTU CAN FD core support, work is mainlined already.

  https://www.qemu.org/docs/master/system/devices/can.html

Thanks in advance to all who help us to deliver the project into public.

Thanks to all colleagues, reviewers and other providing feedback,
infrastructure and enthusiasm and motivation for open-source work.

 .../bindings/net/can/ctu,ctucanfd.yaml        |   63 +
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 .../can/ctu/ctucanfd-driver.rst               |  638 +++++++
 .../can/ctu/fsm_txt_buffer_user.svg           |  151 ++
 MAINTAINERS                                   |    8 +
 drivers/net/can/Kconfig                       |    1 +
 drivers/net/can/Makefile                      |    1 +
 drivers/net/can/ctucanfd/Kconfig              |   34 +
 drivers/net/can/ctucanfd/Makefile             |   10 +
 drivers/net/can/ctucanfd/ctucanfd.h           |   82 +
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 1490 +++++++++++++++++
 drivers/net/can/ctucanfd/ctucanfd_kframe.h    |   77 +
 drivers/net/can/ctucanfd/ctucanfd_kregs.h     |  325 ++++
 drivers/net/can/ctucanfd/ctucanfd_pci.c       |  304 ++++
 drivers/net/can/ctucanfd/ctucanfd_platform.c  |  132 ++
 15 files changed, 3318 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
 create mode 100644 Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
 create mode 100644 Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg
 create mode 100644 drivers/net/can/ctucanfd/Kconfig
 create mode 100644 drivers/net/can/ctucanfd/Makefile
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_base.c
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_kframe.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_kregs.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_pci.c
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_platform.c

-- 
2.20.1


