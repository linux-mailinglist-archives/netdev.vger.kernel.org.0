Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB116457082
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhKSOZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234817AbhKSOZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BF6B61AD0;
        Fri, 19 Nov 2021 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331719;
        bh=ERwTppd1E7eLQjLNtptQnliMNraz3XZinGnkgjsZUGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFrUMaBwXsyNZ394TiqcA1/AM0T1bMMS0Snjfe9fbASffwyfQG1ompWkBLIvCD9jg
         CjHq36k0EWr0izpsOpOExnsG3v8NGGKcaRAMz7R+2F4NvCIgrv6pSirCkI5E2P5NCG
         nGwOOtcKwvmOm1rD1j8YVD01XtkT/N/vXC/3MyGfjghDZf8oOJdSCla7f+Wf2yhd+Y
         WGDlbZ2Y51jL2m69Eq/M/b27YZCi1c05XF+yCePwOwAqGLZsUj4/gXzrcuW/rB5X3f
         bPMrK/acad41SNO/KSr1iUoYaj8zosWoHdOO1ZJsdEqP8OD2oLhok+HlXy+ykB/byW
         BGQ3dbYn2aN0Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v2 2/7] bnx2x: constify static inline stub for dev_addr
Date:   Fri, 19 Nov 2021 06:21:50 -0800
Message-Id: <20211119142155.3779933-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnx2x_vfpf_config_mac() was constified by not its stub.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index 8c2cf5519787..2dac704dc346 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -586,7 +586,7 @@ static inline int bnx2x_vfpf_release(struct bnx2x *bp) {return 0; }
 static inline int bnx2x_vfpf_init(struct bnx2x *bp) {return 0; }
 static inline void bnx2x_vfpf_close_vf(struct bnx2x *bp) {}
 static inline int bnx2x_vfpf_setup_q(struct bnx2x *bp, struct bnx2x_fastpath *fp, bool is_leading) {return 0; }
-static inline int bnx2x_vfpf_config_mac(struct bnx2x *bp, u8 *addr,
+static inline int bnx2x_vfpf_config_mac(struct bnx2x *bp, const u8 *addr,
 					u8 vf_qid, bool set) {return 0; }
 static inline int bnx2x_vfpf_config_rss(struct bnx2x *bp,
 					struct bnx2x_config_rss_params *params) {return 0; }
-- 
2.31.1

