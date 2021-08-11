Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38ED3E97AC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhHKSb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:31:59 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:56882 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhHKSb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:31:59 -0400
Received: (qmail 75314 invoked by uid 89); 11 Aug 2021 18:31:34 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 11 Aug 2021 18:31:34 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 0/3] ptp: ocp: minor updates
Date:   Wed, 11 Aug 2021 11:31:30 -0700
Message-Id: <20210811183133.186721-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix errors spotted by automated tools.

Add myself to the MAINTAINERS for the ptp_ocp driver.

Jonathan Lemon (3):
  ptp: ocp: Fix uninitialized variable warning spotted by clang.
  ptp: ocp: Fix error path for pci_ocp_device_init()
  MAINTAINERS: Update for ptp_ocp driver.

 MAINTAINERS           |  6 ++++++
 drivers/ptp/ptp_ocp.c | 11 +++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.31.1

