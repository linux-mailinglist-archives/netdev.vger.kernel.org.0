Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707A4132940
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgAGOsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:48:17 -0500
Received: from mxout2.idt.com ([157.165.5.26]:45220 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgAGOsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 09:48:17 -0500
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id 007EmEkf025873;
        Tue, 7 Jan 2020 06:48:14 -0800
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id 007EmDwk009798;
        Tue, 7 Jan 2020 06:48:13 -0800
Received: from vcheng-VirtualBox.na.ads.idt.com (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id 007EmDV02485;
        Tue, 7 Jan 2020 06:48:13 -0800 (PST)
From:   vincent.cheng.xh@renesas.com
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v4 net-next 0/1] Replace IDT with Renesas and improve version info.
Date:   Tue,  7 Jan 2020 09:47:56 -0500
Message-Id: <1578408477-4650-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Replacing IDT with Renesas patches has been withdrawn.
This series reworks the version info displayed for the clockmatrix chip.

Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")

Changes since v3:
- Reported-by: kbuild test robot <lkp@intel.com>
  Fix drivers//ptp/ptp_clockmatrix.c:644:43: error: 'OTP_SCSR_CONFIG_SELECT' undeclared

Changes since v2:
- Add details to commit message for Patch 1 to provide
  background information.

Changes since v1:
- Remove Patch 1/3 Add Replace idt with renesas in dt-bindings
- Remove Patch 2/3 Replaces IDT references with Renesas
- Patch 3/3 becomes patch 1/1

Vincent Cheng (1):
  ptp: clockmatrix: Rework clockmatrix version information.

 drivers/ptp/idt8a340_reg.h    |  2 ++
 drivers/ptp/ptp_clockmatrix.c | 77 ++++++++-----------------------------------
 2 files changed, 15 insertions(+), 64 deletions(-)

-- 
2.7.4

