Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43E6B4C74
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjCJQOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjCJQMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A33611ABAF
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678464498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VF7DOSFSoxperMCR1c0beoAVNr9jhMKzR2GYQ6m9DTA=;
        b=U9UsDKvfKK8N2ZGaAnBBx6XfqO21mihzI/QhWrERLr3ekDVQioNxdX6rHc6XEYT0B6xMZv
        ZsFlbTYKLufGWX0A8RasQf7H0/V5HlGBzPgBaLt9q57t6RkHupQZSKQULZ+iagM3OhQQQC
        1BIWXz2nJoqR63M20xj9UTkP8/DUvN4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-0nmZr2faN_Ob6cqxJso-SQ-1; Fri, 10 Mar 2023 11:08:14 -0500
X-MC-Unique: 0nmZr2faN_Ob6cqxJso-SQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 612A3185A794;
        Fri, 10 Mar 2023 16:08:13 +0000 (UTC)
Received: from thuth.com (unknown [10.45.224.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C0A2492C3E;
        Fri, 10 Mar 2023 16:08:11 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 5/5] scripts: Update the CONFIG_* ignore list in headers_install.sh
Date:   Fri, 10 Mar 2023 17:07:57 +0100
Message-Id: <20230310160757.199253-6-thuth@redhat.com>
In-Reply-To: <20230310160757.199253-1-thuth@redhat.com>
References: <20230310160757.199253-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The file in include/uapi/linux/ have been cleaned in the previous patches,
so we can now remove these entries from the CONFIG_* ignore-list.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/headers_install.sh | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index 4041881746ad..36b56b746fce 100755
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -83,10 +83,6 @@ arch/nios2/include/uapi/asm/swab.h:CONFIG_NIOS2_CI_SWAB_SUPPORT
 arch/x86/include/uapi/asm/auxvec.h:CONFIG_IA32_EMULATION
 arch/x86/include/uapi/asm/auxvec.h:CONFIG_X86_64
 arch/x86/include/uapi/asm/mman.h:CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
-include/uapi/linux/atmdev.h:CONFIG_COMPAT
-include/uapi/linux/eventpoll.h:CONFIG_PM_SLEEP
-include/uapi/linux/hw_breakpoint.h:CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-include/uapi/linux/pktcdvd.h:CONFIG_CDROM_PKTCDVD_WCACHE
 "
 
 for c in $configs
-- 
2.31.1

