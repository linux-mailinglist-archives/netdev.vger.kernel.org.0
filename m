Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E669835F03E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350397AbhDNJBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:01:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350249AbhDNJAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618390731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcS3XqDLjWw2JcTnxRCko+qmOPIOGyWNCS5CmAztAiQ=;
        b=De/TbML2BB65r/2xZ7oSxsTQtw7qWG4lP4V3O/O42whM2a/0SaV7kJUJd19Qyi6j0f8P0X
        GyYtRMZhQIcvDv/fRCkdozt1HAUwzwYU24kL/XMirTKUbQc9cYrHwAUxP9ky5DYZFZEhaQ
        SEStXmBLEbi/Wolrl/MpzO7YkESxWJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-Tm09oKAfPRaAHSyqBNW31Q-1; Wed, 14 Apr 2021 04:58:49 -0400
X-MC-Unique: Tm09oKAfPRaAHSyqBNW31Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24EA681426D;
        Wed, 14 Apr 2021 08:58:47 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 642975D71D;
        Wed, 14 Apr 2021 08:58:45 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org,
        tytso@mit.edu, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, broonie@kernel.org, davidgow@google.com,
        skhan@linuxfoundation.org, mptcp@lists.linux.dev
Subject: [PATCH v2 5/6] kunit: mptcp: adhear to KUNIT formatting standard
Date:   Wed, 14 Apr 2021 04:58:08 -0400
Message-Id: <0fa191715b236766ad13c5f786d8daf92a9a0cf2.1618388989.git.npache@redhat.com>
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop 'S' from end of CONFIG_MPTCP_KUNIT_TESTS inorder to adhear to the
KUNIT *_KUNIT_TEST config name format.

Fixes: a00a582203db (mptcp: move crypto test to KUNIT)
Signed-off-by: Nico Pache <npache@redhat.com>
---
 net/mptcp/Kconfig  | 2 +-
 net/mptcp/Makefile | 2 +-
 net/mptcp/crypto.c | 2 +-
 net/mptcp/token.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index a014149aa323..20328920f6ed 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -22,7 +22,7 @@ config MPTCP_IPV6
 	depends on IPV6=y
 	default y
 
-config MPTCP_KUNIT_TESTS
+config MPTCP_KUNIT_TEST
 	tristate "This builds the MPTCP KUnit tests" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index a611968be4d7..dcce3cbd1f19 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
 
 mptcp_crypto_test-objs := crypto_test.o
 mptcp_token_test-objs := token_test.o
-obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o mptcp_token_test.o
+obj-$(CONFIG_MPTCP_KUNIT_TEST) += mptcp_crypto_test.o mptcp_token_test.o
diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index b472dc149856..a8931349933c 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -78,6 +78,6 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 	sha256(input, SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE, hmac);
 }
 
-#if IS_MODULE(CONFIG_MPTCP_KUNIT_TESTS)
+#if IS_MODULE(CONFIG_MPTCP_KUNIT_TEST)
 EXPORT_SYMBOL_GPL(mptcp_crypto_hmac_sha);
 #endif
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index feb4b9ffd462..8f0270a780ce 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -402,7 +402,7 @@ void __init mptcp_token_init(void)
 	}
 }
 
-#if IS_MODULE(CONFIG_MPTCP_KUNIT_TESTS)
+#if IS_MODULE(CONFIG_MPTCP_KUNIT_TEST)
 EXPORT_SYMBOL_GPL(mptcp_token_new_request);
 EXPORT_SYMBOL_GPL(mptcp_token_new_connect);
 EXPORT_SYMBOL_GPL(mptcp_token_accept);
-- 
2.30.2

