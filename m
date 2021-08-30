Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B93B3FBF93
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239131AbhH3Xxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:33 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:43646 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbhH3Xxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:32 -0400
Received: (qmail 8799 invoked by uid 89); 30 Aug 2021 23:52:37 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 30 Aug 2021 23:52:37 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 00/11] ocp timecard updates
Date:   Mon, 30 Aug 2021 16:52:25 -0700
Message-Id: <20210830235236.309993-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This update mainly deals with features for the TimeCard v10 firmware.
The signals provided from the external SMA connectors can be steered
to different locations, and the generated SMA signals can be chosen.

The update also adds support for IRIG-B and DCF formats.

Jonathan Lemon (11):
  ptp: ocp: parameterize the i2c driver used
  ptp: ocp: Parameterize the TOD information display.
  ptp: ocp: Skip I2C flash read when there is no controller.
  ptp: ocp: Skip resources with out of range irqs
  ptp: ocp: Add third timestamper
  ptp: ocp: Add SMA selector and controls
  ptp: ocp: Add IRIG-B and DCF blocks
  ptp: ocp: Add sysfs attribute utc_tai_offset
  ptp: ocp: Add debugfs entry for timecard
  ptp: ocp: Add IRIG-B output mode control
  docs: ABI: Add sysfs documentation for timecard

 Documentation/ABI/testing/sysfs-timecard | 141 ++++
 drivers/ptp/ptp_ocp.c                    | 855 +++++++++++++++++++++--
 2 files changed, 929 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-timecard

-- 
2.31.1

