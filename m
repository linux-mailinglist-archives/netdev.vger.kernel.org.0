Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357E621F84D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgGNRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:34:33 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:60974 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgGNRed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 13:34:33 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2020 13:34:32 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 06EHDIkX023308;
        Tue, 14 Jul 2020 13:15:50 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 3277kcs6pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 13:15:50 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 14 Jul 2020 13:15:49 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 14 Jul 2020 13:15:48 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>, <corbet@lwn.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 1/1] docs: ptp.rst: add support for Renesas (IDT) ClockMatrix
Date:   Tue, 14 Jul 2020 13:15:20 -0400
Message-ID: <1594746920-28760-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_06:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2007140126
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Add below to “Ancillary clock features” section
  - Low Pass Filter (LPF) access from user space

Add below to list of “Supported hardware” section
  + Renesas (IDT) ClockMatrix™

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 Documentation/driver-api/ptp.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index a15192e..664838a 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -23,6 +23,7 @@ PTP hardware clock infrastructure for Linux
   + Ancillary clock features
     - Time stamp external events
     - Period output signals configurable from user space
+    - Low Pass Filter (LPF) access from user space
     - Synchronization of the Linux system time via the PPS subsystem
 
 PTP hardware clock kernel API
@@ -94,3 +95,14 @@ Supported hardware
 
      - Auxiliary Slave/Master Mode Snapshot (optional interrupt)
      - Target Time (optional interrupt)
+
+   * Renesas (IDT) ClockMatrix™
+
+     - Up to 4 independent PHC channels
+     - Integrated low pass filter (LPF), access via .adjPhase (compliant to ITU-T G.8273.2)
+     - Programmable output periodic signals
+     - Programmable inputs can time stamp external triggers
+     - Driver and/or hardware configuration through firmware (idtcm.bin)
+          - LPF settings (bandwidth, phase limiting, automatic holdover, physical layer assist (per ITU-T G.8273.2))
+          - Programmable output PTP clocks, any frequency up to 1GHz (to other PHY/MAC time stampers, refclk to ASSPs/SoCs/FPGAs)
+          - Lock to GNSS input, automatic switching between GNSS and user-space PHC control (optional)
-- 
2.7.4

