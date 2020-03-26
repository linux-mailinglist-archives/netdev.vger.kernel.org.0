Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A307D1949D7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgCZVKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:10:03 -0400
Received: from sauhun.de ([88.99.104.3]:54366 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgCZVKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 17:10:02 -0400
Received: from localhost (p54B3331F.dip0.t-ipconnect.de [84.179.51.31])
        by pokefinder.org (Postfix) with ESMTPSA id 3E6532C1F8C;
        Thu, 26 Mar 2020 22:10:01 +0100 (CET)
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/2] net: convert to use new I2C API
Date:   Thu, 26 Mar 2020 22:09:58 +0100
Message-Id: <20200326211001.13171-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are deprecating calls which return NULL in favor of new variants which
return an ERR_PTR. Only build tested.


Wolfram Sang (2):
  igb: convert to use i2c_new_client_device()
  sfc: falcon: convert to use i2c_new_client_device()

 drivers/net/ethernet/intel/igb/igb_hwmon.c      | 6 +++---
 drivers/net/ethernet/sfc/falcon/falcon_boards.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.20.1

