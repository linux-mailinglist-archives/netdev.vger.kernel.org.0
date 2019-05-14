Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC751CFD3
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfENTZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 15:25:31 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38131 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfENTZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 15:25:30 -0400
Received: by mail-qk1-f195.google.com with SMTP id a64so5298787qkg.5
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 12:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KGcQ9upC29gYa4IvVNB87+RZG37gSQZLhYRKnsdq/QU=;
        b=bYM7ZfDp2uyEwMRdAYGgW1UMkTQBI1XJSNiLk0bjPhoCi78+HQrKbdoeWOJcuqGomf
         6dZ3Hmp4hYZYf2j1gzRJOFLW+uKLzutlwe/Fxuv0SIqZWsK2ILOwjR/lN11/ulXuJKgE
         hLrq9z7xfO1WB9cK1ZCLt8jh4Q6jExUIiLEjPyMSrSfg8YrBpBwUiTT+iKKxjT8D054V
         TZiKEoZkrlQjv3yDxjPWXNG2izGQUrRRFF7HUh9mInJk7/ijFtr9Pi6cEttPcM1u/A/m
         ltUIUJ26tsQNXAxVMgFrmgvJ1iobNUwK3KZsZkNXtG2EP8EpMb7MsIvRNPGgvMTeE5GR
         fH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KGcQ9upC29gYa4IvVNB87+RZG37gSQZLhYRKnsdq/QU=;
        b=g9sThO1Z+rHg9o1/mTCBwrpKhgCIdqGFB0+siJWWM88/vnUk5yIZvVlmiLIhU9F4Jj
         Md8T8iOY0DYtf0VG/26Uz+HEToC4D/OLQT44snzFg4YYLnJvXSfXnYQZvyTAqfVkTI/m
         y2PHohOCM2FRivNPgJ/1xDvX1CKkNIVwKrZQc/xubBrg2dD0jf7AWUKacMxsDrBMwCAs
         poWvesOawzEz0MrIsbjMJA8/v5C8h2XQELY5CfnNPvyuvNjha52lzAN58izz8j0/Naa/
         ZKIhDhzxIwlUMEUXZT/Ywz7dJBk/daHfHYrEaD4/IcoYwSIMyI3ZQXV4+99oMjsq/FIT
         mO9A==
X-Gm-Message-State: APjAAAXnFHqMx/cpuTjXCM4QmwarLN8zOV1cgXp1e6k1hBucSR2v0Tbg
        k9J4K+He+7T/E64vJH4CFZrveg==
X-Google-Smtp-Source: APXvYqzERwp4vgEjaoTLtN65oy2xv6PWcLZSxjMr1K1/3w/5NNxyQxqNR336BTtj0/TQaFIv5HjabQ==
X-Received: by 2002:ae9:e30e:: with SMTP id v14mr30149993qkf.91.1557861929556;
        Tue, 14 May 2019 12:25:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm3061100qtj.70.2019.05.14.12.25.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 12:25:29 -0700 (PDT)
Date:   Tue, 14 May 2019 12:25:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     NeilBrown <neilb@suse.com>
Cc:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 2/5] rhashtable: reorder some inline functions and
 macros.
Message-ID: <20190514122509.46ab191a@cakuba.netronome.com>
In-Reply-To: <155503392797.17793.15780367123758287135.stgit@noble.brown>
References: <155503371949.17793.8266195008003399968.stgit@noble.brown>
        <155503392797.17793.15780367123758287135.stgit@noble.brown>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Apr 2019 11:52:08 +1000, NeilBrown wrote:
> This patch only moves some code around, it doesn't
> change the code at all.
> A subsequent patch will benefit from this as it needs
> to add calls to functions which are now defined before the
> call-site, but weren't before.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

Hi Neil, I think this patch introduces as slew of sparse warnigns:

include/linux/rhashtable.h:724:23: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:724:23:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:724:23:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt
include/linux/rhashtable.h:728:33: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:728:33:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:728:33:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt
include/linux/rhashtable.h:760:41: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:760:41:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:760:41:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt
include/linux/rhashtable.h:801:25: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:801:25:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:801:25:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt
include/linux/rhashtable.h:1003:23: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:1003:23:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:1003:23:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt
include/linux/rhashtable.h:1047:41: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:1047:41:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:1047:41:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt
include/linux/rhashtable.h:1054:25: warning: incorrect type in argument 2 (different address spaces)
include/linux/rhashtable.h:1054:25:    expected struct rhash_lock_head **bkt
include/linux/rhashtable.h:1054:25:    got struct rhash_lock_head [noderef] <asn:4>**[assigned] bkt

Is there any chance to get those fixed?  Presumably a __force would be
appropriate?  Maybe like this?

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index f7714d3b46bd..997017a85032 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -325,27 +325,28 @@ static inline struct rhash_lock_head __rcu **rht_bucket_insert(
  */
 
 static inline void rht_lock(struct bucket_table *tbl,
-                           struct rhash_lock_head **bkt)
+                           struct rhash_lock_head __rcu **bkt)
 {
+
        local_bh_disable();
-       bit_spin_lock(0, (unsigned long *)bkt);
+       bit_spin_lock(0, (unsigned long __force *)bkt);
        lock_map_acquire(&tbl->dep_map);
 }
 
 static inline void rht_lock_nested(struct bucket_table *tbl,
-                                  struct rhash_lock_head **bucket,
+                                  struct rhash_lock_head __rcu **bkt,
                                   unsigned int subclass)
 {
        local_bh_disable();
-       bit_spin_lock(0, (unsigned long *)bucket);
+       bit_spin_lock(0, (unsigned long __force *)bkt);
        lock_acquire_exclusive(&tbl->dep_map, subclass, 0, NULL, _THIS_IP_);
 }
 
 static inline void rht_unlock(struct bucket_table *tbl,
-                             struct rhash_lock_head **bkt)
+                             struct rhash_lock_head __rcu **bkt)
 {
        lock_map_release(&tbl->dep_map);
-       bit_spin_unlock(0, (unsigned long *)bkt);
+       bit_spin_unlock(0, (unsigned long __force *)bkt);
        local_bh_enable();
 }
 
