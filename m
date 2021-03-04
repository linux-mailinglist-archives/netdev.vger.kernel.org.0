Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A17432D080
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhCDKOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:14:55 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13431 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbhCDKOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:14:40 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Drmrf5c0QzjSYR;
        Thu,  4 Mar 2021 18:12:34 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Mar 2021 18:13:48 +0800
From:   'Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Luca Coelho <luciano.coelho@intel.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gregory Greenman" <gregory.greenman@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] iwlwifi: mvm: fix old-style static const declaration
Date:   Thu, 4 Mar 2021 10:22:45 +0000
Message-ID: <20210304102245.274847-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

GCC reports warning as follows:

drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:14:1: warning:
 'static' is not at beginning of declaration [-Wold-style-declaration]
   14 | const static struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
      | ^~~~~

Move static to the beginning of declaration.

Fixes: 21254908cbe9 ("iwlwifi: mvm: add RFI-M support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
index 873919048143..4d5a99cbcc9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -11,7 +11,7 @@
  * DDR needs frequency in units of 16.666MHz, so provide FW with the
  * frequency values in the adjusted format.
  */
-const static struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
+static const struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
 	/* LPDDR4 */
 
 	/* frequency 3733MHz */

