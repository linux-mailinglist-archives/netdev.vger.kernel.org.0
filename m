Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7556C610
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiGICxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGICxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A17AB1A
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 19:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC4CBB82A33
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 02:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE97C341CA;
        Sat,  9 Jul 2022 02:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657335183;
        bh=NMABvgu0d2U870K67bf5LJydEPwMvi0Jb42CyoXVJ+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi9PL+RhCmQxRmG/16WkQL6Vwl/kimvC9n6KxEwjhe9tazebfp2XPvuWxu3Ovbst2
         54hJ7OjdhN4rV0b7kwtrpU3EWGw0tO4yzqqHIve2i9LtAcvHm7bDpbUFQfs7auNiVL
         WhlIHBxMT7n0+F9cyHyDAJQpO7RZqOsoo7FPmz6UgyNFLvi+rHLH/yVI2Ah4bUZIT6
         xOz784SAmVoguLgip0OGXxyT93dV49nX3WyJMWufhMwr6UI0Wls57EROslbMaiwsxj
         ZI3ULGC88tkOQ/VQot9X1V0ZCfg6YEkZpdoHFzThFL+75E8toU0QEg+YR/V+uzAf4p
         6T5QCfKO4PWlw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/4] tls: fix spelling of MIB
Date:   Fri,  8 Jul 2022 19:52:52 -0700
Message-Id: <20220709025255.323864-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220709025255.323864-1-kuba@kernel.org>
References: <20220709025255.323864-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIN -> MIB

Fixes: 88527790c079 ("tls: rx: add sockopt for enabling optimistic decrypt with TLS 1.3")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/snmp.h | 2 +-
 net/tls/tls_proc.c        | 2 +-
 net/tls/tls_sw.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 1c9152add663..fd83fb9e525a 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -344,7 +344,7 @@ enum
 	LINUX_MIB_TLSRXDEVICE,			/* TlsRxDevice */
 	LINUX_MIB_TLSDECRYPTERROR,		/* TlsDecryptError */
 	LINUX_MIB_TLSRXDEVICERESYNC,		/* TlsRxDeviceResync */
-	LINUX_MIN_TLSDECRYPTRETRY,		/* TlsDecryptRetry */
+	LINUX_MIB_TLSDECRYPTRETRY,		/* TlsDecryptRetry */
 	__LINUX_MIB_TLSMAX
 };
 
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 1246e52b48f6..ede9df13c398 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -20,7 +20,7 @@ static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsRxDevice", LINUX_MIB_TLSRXDEVICE),
 	SNMP_MIB_ITEM("TlsDecryptError", LINUX_MIB_TLSDECRYPTERROR),
 	SNMP_MIB_ITEM("TlsRxDeviceResync", LINUX_MIB_TLSRXDEVICERESYNC),
-	SNMP_MIB_ITEM("TlsDecryptRetry", LINUX_MIN_TLSDECRYPTRETRY),
+	SNMP_MIB_ITEM("TlsDecryptRetry", LINUX_MIB_TLSDECRYPTRETRY),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 09370f853031..e12846d1871a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1596,7 +1596,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
 		darg->zc = false;
-		TLS_INC_STATS(sock_net(sk), LINUX_MIN_TLSDECRYPTRETRY);
+		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTRETRY);
 		return decrypt_skb_update(sk, skb, dest, darg);
 	}
 
-- 
2.36.1

