Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B2911CA41
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfLLKI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:08:57 -0500
Received: from inva020.nxp.com ([92.121.34.13]:44758 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbfLLKI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:08:57 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 76D491A0CBA;
        Thu, 12 Dec 2019 11:08:55 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4A7261A012A;
        Thu, 12 Dec 2019 11:08:53 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2D38C402B1;
        Thu, 12 Dec 2019 18:08:50 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 0/3] dpaa2-ptp: support external trigger event
Date:   Thu, 12 Dec 2019 18:08:03 +0800
Message-Id: <20191212100806.17447-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to add external trigger event support for
dpaa2-ptp driver since MC firmware has supported external
trigger interrupt with a new v2 dprtc_set_irq_mask() API.
And extts_clean_up() function in ptp_qoriq driver needs to be
exported with minor fixes for dpaa2-ptp reusing.

Yangbo Lu (3):
  ptp_qoriq: check valid status before reading extts fifo
  ptp_qoriq: export extts_clean_up() function
  dpaa2-ptp: add external trigger event support

 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 20 ++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h |  4 +++-
 drivers/net/ethernet/freescale/dpaa2/dprtc.h     |  2 ++
 drivers/ptp/ptp_qoriq.c                          | 15 ++++++++++-----
 include/linux/fsl/ptp_qoriq.h                    |  1 +
 5 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.7.4

