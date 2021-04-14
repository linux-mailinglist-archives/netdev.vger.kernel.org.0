Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283DA35F051
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350441AbhDNJBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:01:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350240AbhDNJAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618390726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IL9tcO7W5w4Q5zI/RcosteAuoS46bX3sbgqpkLeCCFg=;
        b=DMIQ261F47eHL1Iu49ezlvzu+MNe1SgLrz/h20Lt+QQRQ4VGHPrP4Y82qDsvepnrJNAwKo
        X6ocMfVIC1mVOlP7yKxmZScTa4gQ5XbPtYHrNLpdVyxU47MQNO34OXnidohrd/3fNSupHb
        kwUzpWhiBp69WopeAwITlJUlV5Un1BY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-rmKrQ_-HMAKpj1cnkwnmsQ-1; Wed, 14 Apr 2021 04:58:44 -0400
X-MC-Unique: rmKrQ_-HMAKpj1cnkwnmsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31C2A107ACCD;
        Wed, 14 Apr 2021 08:58:43 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F83D5D71D;
        Wed, 14 Apr 2021 08:58:41 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org,
        tytso@mit.edu, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, broonie@kernel.org, davidgow@google.com,
        skhan@linuxfoundation.org, mptcp@lists.linux.dev
Subject: [PATCH v2 3/6] kunit: ext4: adhear to KUNIT formatting standard
Date:   Wed, 14 Apr 2021 04:58:06 -0400
Message-Id: <cbc925da29648e3c9fa6d0945331914911ab6d40.1618388989.git.npache@redhat.com>
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop 'S' from end of CONFIG_EXT4_KUNIT_TESTS inorder to adhear to the KUNIT
*_KUNIT_TEST config name format.

Fixes: 1cbeab1b242d (ext4: add kunit test for decoding extended timestamps)
Signed-off-by: Nico Pache <npache@redhat.com>
---
 fs/ext4/.kunitconfig | 2 +-
 fs/ext4/Kconfig      | 2 +-
 fs/ext4/Makefile     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/.kunitconfig b/fs/ext4/.kunitconfig
index bf51da7cd9fc..81d4da667740 100644
--- a/fs/ext4/.kunitconfig
+++ b/fs/ext4/.kunitconfig
@@ -1,3 +1,3 @@
 CONFIG_KUNIT=y
 CONFIG_EXT4_FS=y
-CONFIG_EXT4_KUNIT_TESTS=y
+CONFIG_EXT4_KUNIT_TEST=y
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 86699c8cab28..1569d3872136 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -101,7 +101,7 @@ config EXT4_DEBUG
 	  If you select Y here, then you will be able to turn on debugging
 	  using dynamic debug control for mb_debug() / ext_debug() msgs.
 
-config EXT4_KUNIT_TESTS
+config EXT4_KUNIT_TEST
 	tristate "KUnit tests for ext4" if !KUNIT_ALL_TESTS
 	depends on EXT4_FS && KUNIT
 	default KUNIT_ALL_TESTS
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 49e7af6cc93f..4e28e380d51b 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -15,5 +15,5 @@ ext4-y	:= balloc.o bitmap.o block_validity.o dir.o ext4_jbd2.o extents.o \
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-inode-test-objs			+= inode-test.o
-obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-inode-test.o
+obj-$(CONFIG_EXT4_KUNIT_TEST)		+= ext4-inode-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
-- 
2.30.2

