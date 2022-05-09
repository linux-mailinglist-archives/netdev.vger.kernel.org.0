Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED3E520133
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiEIPf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiEIPf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:35:26 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D185FE21B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:31:32 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 6FC023200F2;
        Mon,  9 May 2022 16:31:31 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1no5MB-0001Pj-7C; Mon, 09 May 2022 16:31:31 +0100
Subject: [PATCH net-next v4 02/11] sfc: Copy shared files needed for Siena
 (part 1)
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 09 May 2022 16:31:31 +0100
Message-ID: <165211029089.5289.1091556750756406391.stgit@palantir17.mph.net>
In-Reply-To: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
References: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are the files starting with b through i.
No changes are done, those will be done with subsequent commits.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/bitfield.h       |    0 
 drivers/net/ethernet/sfc/siena/efx.c            |    0 
 drivers/net/ethernet/sfc/siena/efx.h            |    0 
 drivers/net/ethernet/sfc/siena/efx_channels.c   |    0 
 drivers/net/ethernet/sfc/siena/efx_channels.h   |    0 
 drivers/net/ethernet/sfc/siena/efx_common.c     |    0 
 drivers/net/ethernet/sfc/siena/efx_common.h     |    0 
 drivers/net/ethernet/sfc/siena/enum.h           |    0 
 drivers/net/ethernet/sfc/siena/ethtool.c        |    0 
 drivers/net/ethernet/sfc/siena/ethtool_common.c |    0 
 drivers/net/ethernet/sfc/siena/ethtool_common.h |    0 
 drivers/net/ethernet/sfc/siena/farch_regs.h     |    0 
 drivers/net/ethernet/sfc/siena/filter.h         |    0 
 drivers/net/ethernet/sfc/siena/io.h             |    0 
 14 files changed, 0 insertions(+), 0 deletions(-)
 copy drivers/net/ethernet/sfc/{bitfield.h => siena/bitfield.h} (100%)
 copy drivers/net/ethernet/sfc/{efx.c => siena/efx.c} (100%)
 copy drivers/net/ethernet/sfc/{efx.h => siena/efx.h} (100%)
 copy drivers/net/ethernet/sfc/{efx_channels.c => siena/efx_channels.c} (100%)
 copy drivers/net/ethernet/sfc/{efx_channels.h => siena/efx_channels.h} (100%)
 copy drivers/net/ethernet/sfc/{efx_common.c => siena/efx_common.c} (100%)
 copy drivers/net/ethernet/sfc/{efx_common.h => siena/efx_common.h} (100%)
 copy drivers/net/ethernet/sfc/{enum.h => siena/enum.h} (100%)
 copy drivers/net/ethernet/sfc/{ethtool.c => siena/ethtool.c} (100%)
 copy drivers/net/ethernet/sfc/{ethtool_common.c => siena/ethtool_common.c} (100%)
 copy drivers/net/ethernet/sfc/{ethtool_common.h => siena/ethtool_common.h} (100%)
 copy drivers/net/ethernet/sfc/{farch_regs.h => siena/farch_regs.h} (100%)
 copy drivers/net/ethernet/sfc/{filter.h => siena/filter.h} (100%)
 copy drivers/net/ethernet/sfc/{io.h => siena/io.h} (100%)

diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/siena/bitfield.h
similarity index 100%
copy from drivers/net/ethernet/sfc/bitfield.h
copy to drivers/net/ethernet/sfc/siena/bitfield.h
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
similarity index 100%
copy from drivers/net/ethernet/sfc/efx.c
copy to drivers/net/ethernet/sfc/siena/efx.c
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
similarity index 100%
copy from drivers/net/ethernet/sfc/efx.h
copy to drivers/net/ethernet/sfc/siena/efx.h
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
similarity index 100%
copy from drivers/net/ethernet/sfc/efx_channels.c
copy to drivers/net/ethernet/sfc/siena/efx_channels.c
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/siena/efx_channels.h
similarity index 100%
copy from drivers/net/ethernet/sfc/efx_channels.h
copy to drivers/net/ethernet/sfc/siena/efx_channels.h
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
similarity index 100%
copy from drivers/net/ethernet/sfc/efx_common.c
copy to drivers/net/ethernet/sfc/siena/efx_common.c
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/siena/efx_common.h
similarity index 100%
copy from drivers/net/ethernet/sfc/efx_common.h
copy to drivers/net/ethernet/sfc/siena/efx_common.h
diff --git a/drivers/net/ethernet/sfc/enum.h b/drivers/net/ethernet/sfc/siena/enum.h
similarity index 100%
copy from drivers/net/ethernet/sfc/enum.h
copy to drivers/net/ethernet/sfc/siena/enum.h
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
similarity index 100%
copy from drivers/net/ethernet/sfc/ethtool.c
copy to drivers/net/ethernet/sfc/siena/ethtool.c
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
similarity index 100%
copy from drivers/net/ethernet/sfc/ethtool_common.c
copy to drivers/net/ethernet/sfc/siena/ethtool_common.c
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/siena/ethtool_common.h
similarity index 100%
copy from drivers/net/ethernet/sfc/ethtool_common.h
copy to drivers/net/ethernet/sfc/siena/ethtool_common.h
diff --git a/drivers/net/ethernet/sfc/farch_regs.h b/drivers/net/ethernet/sfc/siena/farch_regs.h
similarity index 100%
copy from drivers/net/ethernet/sfc/farch_regs.h
copy to drivers/net/ethernet/sfc/siena/farch_regs.h
diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/siena/filter.h
similarity index 100%
copy from drivers/net/ethernet/sfc/filter.h
copy to drivers/net/ethernet/sfc/siena/filter.h
diff --git a/drivers/net/ethernet/sfc/io.h b/drivers/net/ethernet/sfc/siena/io.h
similarity index 100%
copy from drivers/net/ethernet/sfc/io.h
copy to drivers/net/ethernet/sfc/siena/io.h

