Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8F723AC71
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgHCSg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:36:26 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1422CC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:36:24 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 073IZRSs033255;
        Mon, 3 Aug 2020 20:35:27 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 073IZR6t003880;
        Mon, 3 Aug 2020 20:35:27 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 073IZQDX003878;
        Mon, 3 Aug 2020 20:35:26 +0200
From:   pisa@cmp.felk.cvut.cz
To:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, c.emde@osadl.org, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v4 0/6] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Mon,  3 Aug 2020 20:34:48 +0200
Message-Id: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 073IZRSs033255
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.098, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1597084535.10885@eQA+8JpdQO/U9XDaVFVRCg
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This driver adds support for the CTU CAN FD open-source IP core.
More documentation and core sources at project page
(https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
The core integration to Xilinx Zynq system as platform driver
is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
Implementation on Intel FPGA based PCI Express board is available
from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
The CTU CAN FD core emulation send for review for QEMU mainline.
Development repository for QEMU emulation - ctu-canfd branch of
  https://gitlab.fel.cvut.cz/canbus/qemu-canbus

More about CAN related projects used and developed at the Faculty
of the Electrical Engineering (http://www.fel.cvut.cz/en/)
of Czech Technical University (https://www.cvut.cz/en)
in Prague at http://canbus.pages.fel.cvut.cz/ .

Martin Jerabek (1):
  can: ctucanfd: add support for CTU CAN FD open-source IP core - bus
    independent part.

Pavel Pisa (5):
  dt-bindings: vendor-prefix: add prefix for the Czech Technical
    University in Prague.
  dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
  can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
  can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
  docs: ctucanfd: CTU CAN FD open-source IP core documentation.

The version 4 changes:
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
support and CTU CAN FD core support.

  https://gitlab.fel.cvut.cz/canbus/qemu-canbus/-/tree/ctu-canfd

The patches has been sent for review to QEMU mainlining list.

Thanks in advance to all who help us to deliver the project into public.

Thanks to all colleagues, reviewers and other providing feedback,
infrastructure and enthusiasm and motivation for open-source work.

Build infrastructure and hardware is provided by
  Department of Control Engineering,
  Faculty of Electrical Engineering,
  Czech Technical University in Prague
  https://dce.fel.cvut.cz/en

 .../devicetree/bindings/net/can/ctu,ctucanfd.yaml  |   70 ++
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 .../device_drivers/ctu/FSM_TXT_Buffer_user.png     |  Bin 0 -> 174807 bytes
 .../device_drivers/ctu/ctucanfd-driver.rst         |  635 +++++++++++
 drivers/net/can/Kconfig                            |    1 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/ctucanfd/Kconfig                   |   38 +
 drivers/net/can/ctucanfd/Makefile                  |   13 +
 drivers/net/can/ctucanfd/ctu_can_fd.c              | 1114 ++++++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd.h              |   88 ++
 drivers/net/can/ctucanfd/ctu_can_fd_frame.h        |  190 ++++
 drivers/net/can/ctucanfd/ctu_can_fd_hw.c           |  781 ++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd_hw.h           |  917 ++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd_pci.c          |  316 ++++++
 drivers/net/can/ctucanfd/ctu_can_fd_platform.c     |  145 +++
 drivers/net/can/ctucanfd/ctu_can_fd_regs.h         |  972 +++++++++++++++++
 16 files changed, 5283 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
 create mode 100644 Documentation/networking/device_drivers/ctu/FSM_TXT_Buffer_user.png
 create mode 100644 Documentation/networking/device_drivers/ctu/ctucanfd-driver.rst
 create mode 100644 drivers/net/can/ctucanfd/Kconfig
 create mode 100644 drivers/net/can/ctucanfd/Makefile
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_frame.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_hw.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_hw.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_pci.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_platform.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_regs.h

-- 
2.11.0

