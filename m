Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B183EDFBE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhHPWOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:14:24 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:22238 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhHPWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 18:14:18 -0400
Received: (qmail 21264 invoked by uid 89); 16 Aug 2021 22:13:38 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 16 Aug 2021 22:13:38 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/4] ptp: ocp: minor updates and fixes.
Date:   Mon, 16 Aug 2021 15:13:33 -0700
Message-Id: <20210816221337.390645-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix errors spotted by automated tools.

Add myself to the MAINTAINERS for the ptp_ocp driver.
--
v2: Add Fixes tags, fix NET_DEVLINK

Jonathan Lemon (4):
  ptp: ocp: Fix uninitialized variable warning spotted by clang.
  ptp: ocp: Fix error path for pci_ocp_device_init()
  ptp: ocp: Have Kconfig select NET_DEVLINK
  MAINTAINERS: Update for ptp_ocp driver.

 MAINTAINERS           | 6 ++++++
 drivers/ptp/Kconfig   | 1 +
 drivers/ptp/ptp_ocp.c | 9 +++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.31.1

