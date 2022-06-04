Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE053D5A8
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 07:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiFDFdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 01:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiFDFdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 01:33:10 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8532AC62
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 22:33:07 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id xMPGnG3rUNUm1xMPGn3G12; Sat, 04 Jun 2022 07:33:05 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 04 Jun 2022 07:33:05 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: [PATCH] nfp: Remove kernel.h when not needed
Date:   Sat,  4 Jun 2022 07:33:00 +0200
Message-Id: <e9bafd799489215710f7880214b58d6487407248.1654320767.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Remove kernel.h when it is not needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h b/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h
index afab6f0fc564..6ad43c7cefe6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h
@@ -4,7 +4,6 @@
 #ifndef NFP_CRC32_H
 #define NFP_CRC32_H
 
-#include <linux/kernel.h>
 #include <linux/crc32.h>
 
 /**
-- 
2.34.1

