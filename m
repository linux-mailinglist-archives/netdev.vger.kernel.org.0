Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE4D326C97
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 11:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhB0J7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 04:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhB0J7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 04:59:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 173BB64EC4;
        Sat, 27 Feb 2021 09:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614419946;
        bh=z0l6Z80ab/fnbuWyyLHfc8ddd7Gy7qqdVmxMdvN1IGg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZW2WyK8Lb0414PJGrmgaEJk4DFV5+qSCpJJKqesMlzLYoQO2KSiS1/VwSMyYAp8Ao
         QdMZzTYNqv5pTlPojMlSUzdkblhZenOdhOvjhA+nB719T7R0nKon/PGHjgzibNQUNI
         LbLf86AQ6pJGxnT2KvQPY6z5v1YDpxO//0DWGIWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH] e1000e: use proper #include guard name in hw.h
Date:   Sat, 27 Feb 2021 10:58:58 +0100
Message-Id: <20210227095858.604463-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The include guard for the e1000e and e1000 hw.h files are the same, so
add the proper "E" term to the hw.h file for the e1000e driver.

This resolves some static analyzer warnings, like the one found by the
"lgtm.com" tool.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 69a2329ea463..f7954cadd979 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 1999 - 2018 Intel Corporation. */
 
-#ifndef _E1000_HW_H_
-#define _E1000_HW_H_
+#ifndef _E1000E_HW_H_
+#define _E1000E_HW_H_
 
 #include "regs.h"
 #include "defines.h"
-- 
2.30.1

