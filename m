Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6809C26F9B4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgIRJ4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:56:17 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41938 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgIRJ4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:56:16 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5429A2015EE;
        Fri, 18 Sep 2020 11:56:15 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4572B2001CA;
        Fri, 18 Sep 2020 11:56:12 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 148694029A;
        Fri, 18 Sep 2020 11:56:08 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [v2, 0/2] ptp_qoriq: support FIPER3
Date:   Fri, 18 Sep 2020 17:47:59 +0800
Message-Id: <20200918094801.37514-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIPER3 (fixed interval period pulse generator) is supported on
DPAA2 and ENETC network controller hardware. This patch-set is to
support it in ptp_qoriq driver and dt-binding.

Changes for v2:
- Some improvement in code.
- Added ACK from Vladimir.

Yangbo Lu (2):
  dt-binding: ptp_qoriq: support fsl,tmr-fiper3 property
  ptp_qoriq: support FIPER3

 Documentation/devicetree/bindings/ptp/ptp-qoriq.txt |  2 ++
 drivers/ptp/ptp_qoriq.c                             | 20 +++++++++++++++++++-
 include/linux/fsl/ptp_qoriq.h                       |  3 +++
 3 files changed, 24 insertions(+), 1 deletion(-)

-- 
2.7.4

