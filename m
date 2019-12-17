Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7138F122371
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 06:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLQFMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 00:12:22 -0500
Received: from mxout2.idt.com ([157.165.5.26]:54554 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfLQFMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 00:12:22 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 00:12:21 EST
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id xBH53DAV031480;
        Mon, 16 Dec 2019 21:03:14 -0800
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id xBH53DaT026481;
        Mon, 16 Dec 2019 21:03:13 -0800
Received: from vcheng-VirtualBox.localdomain (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id xBH53CV16982;
        Mon, 16 Dec 2019 21:03:12 -0800 (PST)
From:   vincent.cheng.xh@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 0/3] Replace IDT with Renesas and improve version info.
Date:   Tue, 17 Dec 2019 00:03:05 -0500
Message-Id: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

This series replaces IDT references with Renesas to align with the corporate 
structure and change the version info displayed for the clockmatrix chip.

- Patch 1 Add Replace idt with renesas in dt-bindings
- Patch 2 Replaces IDT references with Renesas
- Patch 3 Replace pipeline, bond, rev, csr, irq with HW rev and 
  OTP config select.

Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")

Vincent Cheng (3):
  dt-bindings: ptp: Rename ptp-idtcm.yaml to ptp-cm.yaml
  ptp: clockmatrix: Remove IDT references or replace with Renesas.
  ptp: clockmatrix: Rework clockmatrix version information.

 Documentation/devicetree/bindings/ptp/ptp-cm.yaml  |  69 ++
 .../devicetree/bindings/ptp/ptp-idtcm.yaml         |  69 --
 drivers/ptp/Kconfig                                |   6 +-
 drivers/ptp/Makefile                               |   2 +-
 drivers/ptp/clockmatrix_reg.h                      | 661 ++++++++++++++++++++
 drivers/ptp/idt8a340_reg.h                         | 659 --------------------
 drivers/ptp/ptp_clockmatrix.c                      | 691 ++++++++++-----------
 drivers/ptp/ptp_clockmatrix.h                      |  28 +-
 8 files changed, 1065 insertions(+), 1120 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-cm.yaml
 delete mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
 create mode 100644 drivers/ptp/clockmatrix_reg.h
 delete mode 100644 drivers/ptp/idt8a340_reg.h

-- 
2.7.4

