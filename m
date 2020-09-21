Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA12272723
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgIUOei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgIUOec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7C4C0613CF;
        Mon, 21 Sep 2020 07:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tfXqHGtFwgmM6UcSRx58+EM7ODTSdMOtwKoRg1u1yAY=; b=h5C0cP745frGI6LFd4dq0v1VC6
        dlre8+k7vu02YmAZ8W+aYC7/KFVYWpjVw4xuvxDaZNd2Z6QBa9oiL0Wj/Hkv5xYC2wYLt9KCBe8bl
        TYAoN6sz7hdDgHMalPgUQTr+fLk7AIcfJFZomtrhfeUIwlk6hulwAl1drU0/fuTNP7wSa0Q5YwXJV
        epTQJexY9j8oJJFTiE4IOj814WqvBV14TzUclzJplEScbfbnyXCkjYiSnhMOe79Hf9o1hSteR7Rvm
        SSHXMAUvLZDteiCW+SEwO+/7lrFRnDtCQ8YijeIlpmrJacTqjMfI2M+KPH2OSNdgKTyq62UNZlM0b
        PcBfcm0Q==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMtY-0007qo-Gk; Mon, 21 Sep 2020 14:34:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 01/11] compat.h: fix a spelling error in <linux/compat.h>
Date:   Mon, 21 Sep 2020 16:34:24 +0200
Message-Id: <20200921143434.707844-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no compat_sys_readv64v2 syscall, only a compat_sys_preadv64v2
one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/compat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index b354ce58966e2d..654c1ec36671a4 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -812,7 +812,7 @@ asmlinkage ssize_t compat_sys_pwritev2(compat_ulong_t fd,
 		const struct compat_iovec __user *vec,
 		compat_ulong_t vlen, u32 pos_low, u32 pos_high, rwf_t flags);
 #ifdef __ARCH_WANT_COMPAT_SYS_PREADV64V2
-asmlinkage long  compat_sys_readv64v2(unsigned long fd,
+asmlinkage long  compat_sys_preadv64v2(unsigned long fd,
 		const struct compat_iovec __user *vec,
 		unsigned long vlen, loff_t pos, rwf_t flags);
 #endif
-- 
2.28.0

