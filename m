Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43FE35F050
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhDNJB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232483AbhDNJAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618390723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEp5EMAVm24nx2qah+gDcXQEPkr6Mgmzt2H3gu4gLOI=;
        b=ahz30U81mPKNvt1CFkIMb1RQc0ABAGo8wkqt54iXWL0pPLyn9aghAhUmIbKlkbANaqBOv1
        +79W9vkrO3zbWqGLygIng2hD+cSuXdu/dg4lCh0Dl2IGpjagO5OfaXkQMl6Xli3g15g9gU
        HSx685HVVLQRImsmvqz7+ObDsebppj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-VArnQOmGORuqLgkb8UeZrQ-1; Wed, 14 Apr 2021 04:58:41 -0400
X-MC-Unique: VArnQOmGORuqLgkb8UeZrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CAD6195D56E;
        Wed, 14 Apr 2021 08:58:39 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D7525D71D;
        Wed, 14 Apr 2021 08:58:37 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org,
        tytso@mit.edu, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, broonie@kernel.org, davidgow@google.com,
        skhan@linuxfoundation.org, mptcp@lists.linux.dev
Subject: [PATCH v2 1/6] kunit: ASoC: topology: adhear to KUNIT formatting standard
Date:   Wed, 14 Apr 2021 04:58:04 -0400
Message-Id: <dcf79e592f9a7e14483dde32ac561f6af2632e50.1618388989.git.npache@redhat.com>
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop 'S' from end of SND_SOC_TOPOLOGY_KUNIT_TESTS inorder to adhear to
 the KUNIT *_KUNIT_TEST config name format.

Fixes: d52bbf747cfa (ASoC: topology: KUnit: Add KUnit tests passing various...)
Signed-off-by: Nico Pache <npache@redhat.com>
---
 sound/soc/Kconfig  | 2 +-
 sound/soc/Makefile | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 640494f76cbd..8a13462e1a63 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -37,7 +37,7 @@ config SND_SOC_COMPRESS
 config SND_SOC_TOPOLOGY
 	bool
 
-config SND_SOC_TOPOLOGY_KUNIT_TESTS
+config SND_SOC_TOPOLOGY_KUNIT_TEST
 	tristate "KUnit tests for SoC topology"
 	depends on KUNIT
 	depends on SND_SOC_TOPOLOGY
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index f56ad996eae8..a7b37c06dc43 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -7,9 +7,9 @@ ifneq ($(CONFIG_SND_SOC_TOPOLOGY),)
 snd-soc-core-objs += soc-topology.o
 endif
 
-ifneq ($(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TESTS),)
+ifneq ($(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TEST),)
 # snd-soc-test-objs := soc-topology-test.o
-obj-$(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TESTS) := soc-topology-test.o
+obj-$(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TEST) := soc-topology-test.o
 endif
 
 ifneq ($(CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM),)
-- 
2.30.2

