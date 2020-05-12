Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C181CE9EC
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgELBCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:02:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:34361 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgELBCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 21:02:00 -0400
IronPort-SDR: OKnaPjYuXCFakzoVecKqeAq5TsqFzrICaVGwHwmCBE5aNUAj/D2QQSJ+pZeLa3Po747uPjsGyX
 VHNkJUgfi0YQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 18:02:00 -0700
IronPort-SDR: MR+tCCkDiX9WnjbfaYtwqNuwcduoQRcl7tpVYxskThmGZKvrN/aADJhsTJDwNOv0WM4A8s3+j/
 m6rS98aaz4hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="436891927"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 11 May 2020 18:01:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jYJJ0-000FFa-0m; Tue, 12 May 2020 09:01:58 +0800
Date:   Tue, 12 May 2020 09:01:35 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [RFC PATCH] sfc: siena_check_caps() can be static
Message-ID: <20200512010135.GA70023@613088f56a4b>
References: <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kbuild test robot <lkp@intel.com>
---
 siena.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index ed1cb6caa69d9..4b4afe81be2a3 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -948,8 +948,8 @@ static int siena_mtd_probe(struct efx_nic *efx)
 
 #endif /* CONFIG_SFC_MTD */
 
-unsigned int siena_check_caps(const struct efx_nic *efx,
-			      u8 flag, u32 offset)
+static unsigned int siena_check_caps(const struct efx_nic *efx,
+				     u8 flag, u32 offset)
 {
 	/* Siena did not support MC_CMD_GET_CAPABILITIES */
 	return 0;
