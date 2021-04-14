Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5513035F04B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350419AbhDNJBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:01:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350124AbhDNJAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618390725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zBzvd/Ow2mhy2uRNHAspe0Hcs9m7pozn4DLZaIWN8HE=;
        b=Klza2MYW4qfn4eXkvlwnpn83wSLhuMxk9zBJmogIVhci56ltw2gvJ9zoHLanDQq9k7ifVF
        k1zTYoLQWu4WjD14aUxm7BQJx85eY912dG4rDC9Qj9v4dH7TTs8t4v2xDsxzaqf42RRmBQ
        IlhsUtiXxK1VtBrcY/qnXvczKeUT/zE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-gmp_Md04MiGYrsZUH90EhQ-1; Wed, 14 Apr 2021 04:58:43 -0400
X-MC-Unique: gmp_Md04MiGYrsZUH90EhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41C59107ACC7;
        Wed, 14 Apr 2021 08:58:41 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66E205D76F;
        Wed, 14 Apr 2021 08:58:39 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org,
        tytso@mit.edu, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, broonie@kernel.org, davidgow@google.com,
        skhan@linuxfoundation.org, mptcp@lists.linux.dev
Subject: [PATCH v2 2/6] kunit: software node: adhear to KUNIT formatting standard
Date:   Wed, 14 Apr 2021 04:58:05 -0400
Message-Id: <ef06f65f4a622cf83cce5ba2ba5a060d2aa2e1b9.1618388989.git.npache@redhat.com>
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change CONFIG_KUNIT_DRIVER_PE_TEST to CONFIG_DRIVER_PE_KUNIT_TEST inorder
to adhear to the KUNIT *_KUNIT_TEST config name format.

Fixes: aa811e3cecec (software node: introduce CONFIG_KUNIT_DRIVER_PE_TEST)
Signed-off-by: Nico Pache <npache@redhat.com>
---
 drivers/base/test/Kconfig  | 2 +-
 drivers/base/test/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/test/Kconfig b/drivers/base/test/Kconfig
index ba225eb1b761..2f3fa31a948e 100644
--- a/drivers/base/test/Kconfig
+++ b/drivers/base/test/Kconfig
@@ -8,7 +8,7 @@ config TEST_ASYNC_DRIVER_PROBE
 	  The module name will be test_async_driver_probe.ko
 
 	  If unsure say N.
-config KUNIT_DRIVER_PE_TEST
+config DRIVER_PE_KUNIT_TEST
 	bool "KUnit Tests for property entry API" if !KUNIT_ALL_TESTS
 	depends on KUNIT=y
 	default KUNIT_ALL_TESTS
diff --git a/drivers/base/test/Makefile b/drivers/base/test/Makefile
index 2f15fae8625f..64b2f3d744d5 100644
--- a/drivers/base/test/Makefile
+++ b/drivers/base/test/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_TEST_ASYNC_DRIVER_PROBE)	+= test_async_driver_probe.o
 
-obj-$(CONFIG_KUNIT_DRIVER_PE_TEST) += property-entry-test.o
+obj-$(CONFIG_DRIVER_PE_KUNIT_TEST) += property-entry-test.o
 CFLAGS_REMOVE_property-entry-test.o += -fplugin-arg-structleak_plugin-byref -fplugin-arg-structleak_plugin-byref-all
-- 
2.30.2

