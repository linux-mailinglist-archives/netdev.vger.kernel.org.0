Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4003EDFBC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhHPWOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:14:21 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:22302 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhHPWOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 18:14:17 -0400
Received: (qmail 21345 invoked by uid 89); 16 Aug 2021 22:13:41 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 16 Aug 2021 22:13:41 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/4] ptp: ocp: Have Kconfig select NET_DEVLINK
Date:   Mon, 16 Aug 2021 15:13:36 -0700
Message-Id: <20210816221337.390645-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816221337.390645-1-jonathan.lemon@gmail.com>
References: <20210816221337.390645-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NET doesn't imply NET_DEVLINK.  Select this separately, so that
random config combinations don't complain.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the
timecard.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 823eae1b4b53..8ad88c3e79aa 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
 	imply MTD_SPI_NOR
 	imply I2C_XILINX
 	select SERIAL_8250
+	select NET_DEVLINK
 
 	default n
 	help
-- 
2.31.1

