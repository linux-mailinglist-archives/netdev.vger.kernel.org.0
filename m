Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE123E64E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 05:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHGDbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 23:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgHGDbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 23:31:51 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B913C061574;
        Thu,  6 Aug 2020 20:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=5oaHILrKKiQXWxtufhV2TM/f3fdYYD5OF4lGKqrdVeE=; b=dlCyQsfIx2BwAw6u3rSP80ISP0
        E2cjisSVeJ2BogFCPmAbrfNG598MTACmDwmS3EWfwwX4U0L4NRBCETK0WM3fAyps+roo2hGIhlZM1
        Tgh/+MvM8gXkig6mpMQ2R7gjUnyYK6E1u7lOFqXQF/wXXNciDHof+o6Cu05I453d3hidEJt70h/Zu
        6JZz59yKqpzlAzzg24+YK3k3CzuQbYlSrLYgUZND+m6Y7EZ3jPtmatEh6Il/A8HaknmyMZnfv6heB
        9qFfurxf0DxJJRRYzx3TRhYjjnXsKc2qR/meTOO+fJHXJ6aV8EizE0t4NBbObnIa2oZkFRMoZUwnj
        5Oe0vPww==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k3t6h-0006lQ-LG; Fri, 07 Aug 2020 03:31:48 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] kernel: bpf: delete repeated words in comments
Date:   Thu,  6 Aug 2020 20:31:41 -0700
Message-Id: <20200807033141.10437-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in kernel/bpf/.
{has, the}

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
---
 kernel/bpf/core.c     |    2 +-
 kernel/bpf/verifier.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200806.orig/kernel/bpf/core.c
+++ linux-next-20200806/kernel/bpf/core.c
@@ -1966,7 +1966,7 @@ void bpf_prog_array_delete_safe(struct b
  * @index: the index of the program to replace
  *
  * Skips over dummy programs, by not counting them, when calculating
- * the the position of the program to replace.
+ * the position of the program to replace.
  *
  * Return:
  * * 0		- Success
--- linux-next-20200806.orig/kernel/bpf/verifier.c
+++ linux-next-20200806/kernel/bpf/verifier.c
@@ -8294,7 +8294,7 @@ static bool stacksafe(struct bpf_func_st
 		if (old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
 		    cur->stack[spi].slot_type[i % BPF_REG_SIZE])
 			/* Ex: old explored (safe) state has STACK_SPILL in
-			 * this stack slot, but current has has STACK_MISC ->
+			 * this stack slot, but current has STACK_MISC ->
 			 * this verifier states are not equivalent,
 			 * return false to continue verification of this path
 			 */
