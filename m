Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB76457EFC
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhKTPe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhKTPe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 10:34:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B504860698;
        Sat, 20 Nov 2021 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637422284;
        bh=hoT4T5mFJxLzwh+WTOpr6loHgAXDtX6TSfeJdsoY0MU=;
        h=From:To:Cc:Subject:Date:From;
        b=O/B50LJcDY+cQ2FK3SRfMw2A0n8DqFnX6mjd4Vwwkw2TuvIM5o9M/gj4N54BgW9he
         mwjz0glZQbOvH4uGjaaDSpq3urdeMpIv5OTQZ0zPpZRyHb3Zp8+zohXV3APMYg4ned
         ruCYqgP863VLcdjj+TOY0phzmtDpTkgWM0kATdbPbKPe8aGbHgUprPSAH7qdn5AY4K
         xo8Vc2mxv7qvmFG1+aXys3w4arbkciJcNh50WOXjatEmTQFYsO+WIM41tFvL5Wqz7Z
         KkQhwMZlryONyZXaQgOoUHraPikHmjGQ4Zm1ZO+cbmnxRA/Wc6hIGkTPSCHvXMP9lb
         RklUN4N7Emqvg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dingsenjie@yulong.com, michael@walle.cc,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] octeon: constify netdev->dev_addr
Date:   Sat, 20 Nov 2021 07:31:19 -0800
Message-Id: <20211120153119.132468-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Argument of a helper is missing a const.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 4e39d712e121..4b4ffdd1044d 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -548,7 +548,7 @@ struct octeon_mgmt_cam_state {
 };
 
 static void octeon_mgmt_cam_state_add(struct octeon_mgmt_cam_state *cs,
-				      unsigned char *addr)
+				      const unsigned char *addr)
 {
 	int i;
 
-- 
2.31.1

