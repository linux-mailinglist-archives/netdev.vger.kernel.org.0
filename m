Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4BF985A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKLSRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:17:32 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41146 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfKLSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:17:32 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so12366849pgv.8
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 10:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6u8AuSwwEE+YzGjQ7qfJp6neppsuNi6MySBbeF4/IPk=;
        b=Kgu/GllJJW+hHZrChI1erjsLqLhM4zsC5sx0iwwMF+a9Jzy9LOjqpJcgsPpm7LV7E+
         5lhtCGSYnmaXdzaOdhr2dPsDec+bP2GsFoL76MoBDQ1cdGhDTHFhQz8Zj4JKg5L6lRUS
         cn441jUZWJCGSOMKxb3lajAPyNZX2lTGt8gIJyQWahOTPWJmEWHffqJlotB6PnW7XoAW
         58jz2Yio7zzqtuPFzbmS1qRf6eXYdzAno4LyzZ7dmYhEBnieUj0N5V+jXau3h9mIedp+
         OVjwUNh0OPhCMfcbBqg/mUB+mR/FuloVxjzzBJ1XmvWkqBPQTVyKZv8Gc32hh+Pvujip
         qEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6u8AuSwwEE+YzGjQ7qfJp6neppsuNi6MySBbeF4/IPk=;
        b=Y2u9FJJH8WwfGh2vhxLB50aw/3+KO+IW6gbU6TdrrQoHn4Qm92IQp+s3EK0m14G56B
         Tk/YkYsk/rPpwqtlRdJ0dlVLpClAGwU3uLy4gS4jjeqvzwCg8a68QEkdtep9PHisTFwT
         OZr9M5LZl7wNleqi8sIGqx/lmgEatOyhWdBNGz57/A9j24WZAC3qBsncvBB/XSJCYhz3
         wTpZv0MgN+Of7oQnbL29jhF36n3/kekkncjRVQHRMV/g3aDoizbnbefg9btt+bHnOGzJ
         M05fCXlwpO+vOdAIxKrK81sV44Utxojz+K8u+u7InkeCT7TG0nsgFZ74av/V+UPwsWYV
         DpVA==
X-Gm-Message-State: APjAAAVi9R/o9rEo+cl2RZ8XTaULENcGodKi/rzP6c5hfZJqWVJ7kiAj
        ExbwZ/Shi+g0ZsElHDkt9bNiD/Kw
X-Google-Smtp-Source: APXvYqwwSH0qDU9uj6WdYBx522qw+uctwzudp+uGOiDq9r/xUGj7tA3eafhCY2h5xpmPHLqI9MGhLA==
X-Received: by 2002:a62:aa0d:: with SMTP id e13mr38879031pff.214.1573582651106;
        Tue, 12 Nov 2019 10:17:31 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 206sm10280425pfu.45.2019.11.12.10.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 10:17:30 -0800 (PST)
Subject: Re: net-next branch fails to build on my P8 CI system
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1573538337.1382.3.camel@abdul>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <951e74ff-07ef-faac-2a55-6dce8bd3d2d5@gmail.com>
Date:   Tue, 12 Nov 2019 10:17:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1573538337.1382.3.camel@abdul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/19 9:58 PM, Abdul Haleem wrote:
> Greeting's
> 
> I see a build failure for net-next branch on my Power 8 system
> 
> 13:25:10 ERROR| [stderr] ./include/linux/u64_stats_sync.h: In function 64_stats_read�:
> 13:25:10 ERROR| [stderr] ./include/linux/u64_stats_sync.h:80:2: warning: passing argument 1 of 鈥榣ocal_read鈥� discards 鈥榗onst鈥� qualifier from pointer target type [enabled by default]
> 13:25:10 ERROR| [stderr]   return local64_read(&p->v);
> 13:25:10 ERROR| [stderr]   ^
> 13:25:10 ERROR| [stderr] In file included from ./include/asm-generic/local64.h:22:0,
> 13:25:10 ERROR| [stderr]                  from ./arch/powerpc/include/generated/asm/local64.h:1,
> 13:25:10 ERROR| [stderr]                  from ./include/linux/u64_stats_sync.h:72,
> 13:25:10 ERROR| [stderr]                  from ./include/linux/cgroup-defs.h:20,
> 13:25:10 ERROR| [stderr]                  from ./include/linux/cgroup.h:28,
> 13:25:10 ERROR| [stderr]                  from ./include/linux/memcontrol.h:13,
> 13:25:10 ERROR| [stderr]                  from ./include/linux/swap.h:9,
> 13:25:10 ERROR| [stderr]                  from ./include/linux/suspend.h:5,
> 13:25:10 ERROR| [stderr]                  from init/do_mounts.c:7:
> 13:25:10 ERROR| [stderr] ./arch/powerpc/include/asm/local.h:20:24: note: expected 鈥榮truct local_t *鈥� but argument is of type 鈥榗onst struct local_t *鈥�
> 13:25:10 ERROR| [stderr]  static __inline__ long local_read(local_t *l)
> 13:25:10 ERROR| [stderr]                         ^
> 13:25:11 ERROR| [stderr] In file included from ./include/linux/cgroup-defs.h:20:0,
> 13:25:11 ERROR| [stderr]                  from ./include/linux/cgroup.h:28,
> 13:25:11 ERROR| [stderr]                  from ./include/linux/hugetlb.h:9,
> 13:25:11 ERROR| [stderr]                  from arch/powerpc/kvm/book3s_64_vio_hv.c:16:
> 13:25:11 ERROR| [stderr] ./include/linux/u64_stats_sync.h: In function 鈥榰64_stats_read鈥�:
> 13:25:11 ERROR| [stderr] ./include/linux/u64_stats_sync.h:80:2: error: passing argument 1 of 鈥榣ocal_read鈥� discards 鈥榗onst鈥� qualifier from pointer target type [-Werror]
> 13:25:11 ERROR| [stderr]   return local64_read(&p->v);
> 13:25:11 ERROR| [stderr]   ^
> 
> I see some recent code changes here
> 
> 9dfd871481c8e9c512938e9ce632beed645363e0 Merge branch 'u64_stats_t'
> fd2f4737870eb866537fbbffa2b59414b9b0c0a2 net: use u64_stats_t in struct
> pcpu_lstats
> 5260dd3ed1ff7eba39251b28977e4d8950e2f099 tun: switch to u64_stats_t
> 316580b69d0a7aeeee5063af47438b626bc47cbd u64_stats: provide u64_stats_t
> type
> 
> 

Fix has been sent few days ago.

For some reason the linuxppc-dev@lists.ozlabs.org  list has not received the patch.

From 47c47befdcf31fb8498c9e630bb8e0dc3ef88079 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 8 Nov 2019 06:04:35 -0800
Subject: [PATCH] powerpc: add const qual to local_read() parameter

A patch in net-next triggered a compile error on powerpc.

This seems reasonable to relax powerpc local_read() requirements.

Fixes: 316580b69d0a ("u64_stats: provide u64_stats_t type")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:	Paul Mackerras <paulus@samba.org>
Cc:	Michael Ellerman <mpe@ellerman.id.au>
Cc:	linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/local.h b/arch/powerpc/include/asm/local.h
index fdd00939270bf08113b537a090d6a6e34a048361..bc4bd19b7fc235b80ec1132f44409b6fe1057975 100644
--- a/arch/powerpc/include/asm/local.h
+++ b/arch/powerpc/include/asm/local.h
@@ -17,7 +17,7 @@ typedef struct
 
 #define LOCAL_INIT(i)	{ (i) }
 
-static __inline__ long local_read(local_t *l)
+static __inline__ long local_read(const local_t *l)
 {
 	return READ_ONCE(l->v);
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

