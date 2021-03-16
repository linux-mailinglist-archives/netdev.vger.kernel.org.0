Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4957933DE50
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 20:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbhCPT7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 15:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbhCPT6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 15:58:44 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A098C06174A;
        Tue, 16 Mar 2021 12:58:43 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y67so9573769pfb.2;
        Tue, 16 Mar 2021 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pRYa/vlAevyrafFB4AxFLiRWcXKroPVvIjoXn3f+82M=;
        b=W+pkyW0b32/CcitR8cVjBr0NmV+UWZsNZOha1J1yuBfxXdiBO0TQnGYcStDadrJ/w7
         X0p5Zmt0FylmW7YConIXXfvD6aNYn64l7KQjGI9fZzb629AkkTXMn5l3HK/v1kmOM8O2
         Br+E9rgJG5j6pFnPGB6DpZ368Ck0atL1ErG5/l7iRCN3sDzTugRSbFmockIPDEf1afjf
         IXv5NxjOSwsJuEvpW4UBLeU5c+6Kzo1u2hrLArSpd0+Bz5u9e6hOEHthRL8zzAx7WyxU
         BcjEmAInmVX2KVdi815PuTMLuUp52kE9p9Yn+8t9Jm9pJn+Gs2/61fJ4HA+Kn33tmQAi
         gnkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pRYa/vlAevyrafFB4AxFLiRWcXKroPVvIjoXn3f+82M=;
        b=nGi3VAr8Hh+swGGxd3yI0JUiTXTZohq6FPGHNEYtmdPQzQLmZek1f33fFFNbiZSsNB
         CyZaiZKICr0xRKQdtS8r3IQgsL1oB3y0RoL1Z+FD1RfJDBPyZa19ddFlhc7zz3W6BeCz
         mSt7Gu44C3j7Prn18TT5Mke/wRHwWZ3Sef2uziCfzajFB8ZRhdJDIJbRbsAL8odOlY38
         eThUBPTR0l1cOJGxhloxWvHBT44GgzuYWFTm1l0fdPZbqhjGLbKw1Cv3SZi1w/hA8HGs
         hKSDOp6p2E3PyXvTCFNKHlRt6nPXtHbhv8fqmQsp7V/Zhq8lyfUyeG2Vdqu+ETgF7ajq
         9YCA==
X-Gm-Message-State: AOAM533rCrPe56ubypwWNCp4pDzE9yXgSNNtJvZx0E2jVAX6QYeVLRwP
        MErItvDW7rWDKhGbl5SeqJhjWmyrM1n4LA==
X-Google-Smtp-Source: ABdhPJzRK0lr9LonUICPQ2u81RswDHldandHc5DhL0/CzZREIOTVSPbGafJb+yKyn0ns1KBogIiCFQ==
X-Received: by 2002:aa7:854c:0:b029:20a:68ac:7923 with SMTP id y12-20020aa7854c0000b029020a68ac7923mr1106186pfn.19.1615924722960;
        Tue, 16 Mar 2021 12:58:42 -0700 (PDT)
Received: from ubuntu.localdomain ([182.156.244.6])
        by smtp.gmail.com with ESMTPSA id 197sm16974824pgg.53.2021.03.16.12.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 12:58:42 -0700 (PDT)
From:   namratajanawade <namrata.janawade@gmail.com>
Cc:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        kuba@kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        namratajanawade <namrata.janawade@gmail.com>
Subject: [PATCH] net: sunrpc: fixed function and extra line coding styles
Date:   Tue, 16 Mar 2021 12:58:33 -0700
Message-Id: <20210316195833.5063-1-namrata.janawade@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Block comments written in format suggested by checkpatch.pl.
Removed trailing semicolon in macros definition as macros should not use a trailing semicolon.
Open braces shifted to new line (as suggested by checkpatch.pl).

Signed-off-by: namratajanawade <namrata.janawade@gmail.com>
---
 net/sunrpc/auth.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index a9f0d17fdb0d..6ef9481a0d2d 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -45,8 +45,7 @@ static struct cred machine_cred = {
 #endif
 };
 
-/*
- * Return the machine_cred pointer to be used whenever
+/* Return the machine_cred pointer to be used whenever
  * the a generic machine credential is needed.
  */
 const struct cred *rpc_machine_cred(void)
@@ -84,7 +83,7 @@ static int param_get_hashtbl_sz(char *buffer, const struct kernel_param *kp)
 	return sprintf(buffer, "%u\n", 1U << nbits);
 }
 
-#define param_check_hashtbl_sz(name, p) __param_check(name, p, unsigned int);
+#define param_check_hashtbl_sz(name, p) __param_check(name, p, unsigned int)
 
 static const struct kernel_param_ops param_ops_hashtbl_sz = {
 	.set = param_set_hashtbl_sz,
@@ -99,7 +98,8 @@ module_param(auth_max_cred_cachesize, ulong, 0644);
 MODULE_PARM_DESC(auth_max_cred_cachesize, "RPC credential maximum total cache size");
 
 static u32
-pseudoflavor_to_flavor(u32 flavor) {
+pseudoflavor_to_flavor(u32 flavor) 
+{
 	if (flavor > RPC_AUTH_MAXFLAVOR)
 		return RPC_AUTH_GSS;
 	return flavor;
@@ -256,8 +256,7 @@ rpcauth_release(struct rpc_auth *auth)
 
 static DEFINE_SPINLOCK(rpc_credcache_lock);
 
-/*
- * On success, the caller is responsible for freeing the reference
+/* On success, the caller is responsible for freeing the reference
  * held by the hashtable
  */
 static bool
@@ -284,8 +283,7 @@ rpcauth_unhash_cred(struct rpc_cred *cred)
 	return ret;
 }
 
-/*
- * Initialize RPC credential cache
+/* Initialize RPC credential cache
  */
 int
 rpcauth_init_credcache(struct rpc_auth *auth)
@@ -320,8 +318,7 @@ rpcauth_stringify_acceptor(struct rpc_cred *cred)
 }
 EXPORT_SYMBOL_GPL(rpcauth_stringify_acceptor);
 
-/*
- * Destroy a list of credentials
+/* Destroy a list of credentials
  */
 static inline
 void rpcauth_destroy_credlist(struct list_head *head)
@@ -373,8 +370,7 @@ rpcauth_lru_remove(struct rpc_cred *cred)
 	spin_unlock(&rpc_credcache_lock);
 }
 
-/*
- * Clear the RPC credential cache, and delete those credentials
+/* Clear the RPC credential cache, and delete those credentials
  * that are not referenced.
  */
 void
@@ -403,8 +399,7 @@ rpcauth_clear_credcache(struct rpc_cred_cache *cache)
 	rpcauth_destroy_credlist(&free);
 }
 
-/*
- * Destroy the RPC credential cache
+/* Destroy the RPC credential cache
  */
 void
 rpcauth_destroy_credcache(struct rpc_auth *auth)
@@ -423,8 +418,7 @@ EXPORT_SYMBOL_GPL(rpcauth_destroy_credcache);
 
 #define RPC_AUTH_EXPIRY_MORATORIUM (60 * HZ)
 
-/*
- * Remove stale credentials. Avoid sleeping inside the loop.
+/* Remove stale credentials. Avoid sleeping inside the loop.
  */
 static long
 rpcauth_prune_expired(struct list_head *free, int nr_to_scan)
@@ -441,8 +435,7 @@ rpcauth_prune_expired(struct list_head *free, int nr_to_scan)
 			rpcauth_lru_remove_locked(cred);
 			continue;
 		}
-		/*
-		 * Enforce a 60 second garbage collection moratorium
+		/* Enforce a 60 second garbage collection moratorium
 		 * Note that the cred_unused list must be time-ordered.
 		 */
 		if (!time_in_range(cred->cr_expire, expired, jiffies))
@@ -471,8 +464,7 @@ rpcauth_cache_do_shrink(int nr_to_scan)
 	return freed;
 }
 
-/*
- * Run memory cache shrinker.
+/* Run memory cache shrinker.
  */
 static unsigned long
 rpcauth_cache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
@@ -510,8 +502,7 @@ rpcauth_cache_enforce_limit(void)
 	rpcauth_cache_do_shrink(nr_to_scan);
 }
 
-/*
- * Look up a process' credentials in the authentication cache
+/* Look up a process' credentials in the authentication cache
  */
 struct rpc_cred *
 rpcauth_lookup_credcache(struct rpc_auth *auth, struct auth_cred * acred,
@@ -566,6 +557,7 @@ rpcauth_lookup_credcache(struct rpc_auth *auth, struct auth_cred * acred,
 	    cred->cr_ops->cr_init != NULL &&
 	    !(flags & RPCAUTH_LOOKUP_NEW)) {
 		int res = cred->cr_ops->cr_init(auth, cred);
+
 		if (res < 0) {
 			put_rpccred(cred);
 			cred = ERR_PTR(res);
-- 
2.25.1

