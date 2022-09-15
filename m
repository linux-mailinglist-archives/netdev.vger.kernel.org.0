Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D765B92E3
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiIODGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIODGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:06:31 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2591098;
        Wed, 14 Sep 2022 20:06:24 -0700 (PDT)
X-QQ-mid: bizesmtp80t1663211166t1um9zzu
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 15 Sep 2022 11:06:04 +0800 (CST)
X-QQ-SSF: 01000000000000E0G000000A0000000
X-QQ-FEAT: fs34Pe/+C2TcMqfXXOSTnNAvo19lO/k2Xo8WqqoKdOqElCVcukdidS2k7m4hz
        OlcCrI8et+Yt9FxcpKFSUWhZmYTRn4bVycRA6awMVeiN7ixNRuZ337AWxhvAFmT8tlZO115
        teDt3gxb4Gj7xvVg+qc8MhkY58vk8yUbVjxkDkg0mBzmavPBd+xLp/oxoeiFlZZVIA/csEP
        6EKh0s+vndhTt/JTWLA1XMdNp9Zy7gD8nny/7vcpINxKztoNpi1rZ+dphGXXtdKUfGkcxsX
        RVKjQFC4DbL1/miYeRA3P6HJIqZdVuTmbiBZhSvbAAx11kkNuriU8Pk77/eVKkWo3c5qSas
        RKpyaQ4xVl10ou8tmgFc1768KPhicm7CAbpxpCTEpuNh9lTXESMenwjQ5tmUQ==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ath9k: fix repeated words in comments
Date:   Thu, 15 Sep 2022 11:05:59 +0800
Message-Id: <20220915030559.42371-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'to'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/ath9k/hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 096a206f49ed..450ab19b1d4e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -710,7 +710,7 @@ struct ath_spec_scan {
 /**
  * struct ath_hw_ops - callbacks used by hardware code and driver code
  *
- * This structure contains callbacks designed to to be used internally by
+ * This structure contains callbacks designed to be used internally by
  * hardware code and also by the lower level driver.
  *
  * @config_pci_powersave:
-- 
2.36.1

