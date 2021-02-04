Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558F430F30F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhBDMUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbhBDMUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 07:20:08 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F24C061573;
        Thu,  4 Feb 2021 04:19:28 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id e18so3089884lja.12;
        Thu, 04 Feb 2021 04:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=jCgIHZMvz7BabuespFqm7XJATQtqJEhK3Ep4Ww3/xz4=;
        b=ePQcpJWRFb98jGm8CkWhhudSKCHRlub5dAJlSxl5zLGntR/7ASSoZTgYEwZpTMzguM
         uvLzFyjcD7qmWztUeBl9FVIHufL/K46hxxussbWfpw2ZdoHDZ6v0zP2mQLWlhfTxemxc
         Ppn4OmQTTQcdt+KD+Pv72osPrQPEQjbY+5Eu7K+lYuXJPVVegJZcnestmCpRqL6OrbbH
         EXwpj8ZfHI4QnVbnaYEhVpqPcuEk+9iRMkXqweRHireuQikzr6+6mBYe/9EgLVCMMk9a
         4nrLof1fp5n2oEHbqHZkOfJO8D87qpsX1Cf1wDbNc2BkVjnhfHOIVwRc/ZIxrZWzA5VG
         OubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jCgIHZMvz7BabuespFqm7XJATQtqJEhK3Ep4Ww3/xz4=;
        b=De7H3mBVaHNULW/YTfent4gyCmtH8MVFi37J2NBMfxwArKfnehF2R7Hw1FNdYLouxw
         Qdtp3+KFPNTq0Ekm4zd5nUKcxRIZyBvb3Mtpd+P22FE8sidTllJU+lE02x67JfGrQS0L
         +Livw8fKFElPdzuQF3fhsPS0iZfk//5ILOyV9v7Bd0YgkmC42T5d2amNbt/jutm/oe4Y
         UclK7hS5CrmMJLz5UuF8/c36HEljtxAgX9EPQFMA2ioQP7dIa1zr79AI1J/rQzNgH8n4
         GdmB3mM1CzDCJZLVl82eaxlBu9GjIwNC8Zh9QMVg6B5sVX/U3QD/OnswPHQYFWzFgUyh
         B+CA==
X-Gm-Message-State: AOAM531ezAA+o89cu3gGviZ7k9EDurXE4D1usomQn9seWnDYR3Qui9rS
        BsiwsowoN/FogfnryQECd6NjmSiwoQEBmsoe
X-Google-Smtp-Source: ABdhPJxkeYKCXtQ5qswzfNkcIWxobAKASiWtVRtjcUtBU1A9pNF27ijzUZip7WXyOrQbWihADlhVvg==
X-Received: by 2002:a05:651c:512:: with SMTP id o18mr4669750ljp.388.1612441165091;
        Thu, 04 Feb 2021 04:19:25 -0800 (PST)
Received: from wbg (h-98-128-228-165.NA.cust.bahnhof.se. [98.128.228.165])
        by smtp.gmail.com with ESMTPSA id r5sm647699ljc.81.2021.02.04.04.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 04:19:24 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Brian Vazquez <brianvv@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
In-Reply-To: <20210204203834.4cc1a307@canb.auug.org.au>
References: <20210204123331.21e4598b@canb.auug.org.au> <CAMzD94RaWQM3J8LctNE_C1fHKYCW8WkbVMda4UV95YbYskQXZw@mail.gmail.com> <20210204203834.4cc1a307@canb.auug.org.au>
Date:   Thu, 04 Feb 2021 13:19:23 +0100
Message-ID: <87eehwyqic.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

On Thu, Feb 04, 2021 at 20:38, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 3 Feb 2021 19:52:08 -0800 Brian Vazquez <brianvv@google.com> wrote:
>> Hi Stephen, thanks for the report. I'm having trouble trying to
>> compile for ppc, but I believe this should fix the problem, could you
>> test this patch, please? Thanks!
> That fixed it, thanks (though the patch was badly wrapped and
> whitespace damaged :-))

can confirm, that patch fixes building from latest net-next also for me.

Here's an updated version.

Regards
 /Joachim

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index 54c02c84906a..551e515b405b 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -36,6 +36,7 @@
 
 #define INDIRECT_CALLABLE_DECLARE(f)	f
 #define INDIRECT_CALLABLE_SCOPE
+#define INDIRECT_CALLABLE_EXPORT(f)    EXPORT_SYMBOL(f)
 
 #else
 #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
@@ -44,6 +45,7 @@
 #define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALLABLE_DECLARE(f)
 #define INDIRECT_CALLABLE_SCOPE		static
+#define INDIRECT_CALLABLE_EXPORT(f)
 #endif
 
 /*
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9e6537709794..9dd8ff3887b7 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1206,7 +1206,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry *ipv4_dst_check(struct dst_entry *dst,
 		return NULL;
 	return dst;
 }
-EXPORT_SYMBOL(ipv4_dst_check);
+INDIRECT_CALLABLE_EXPORT(ipv4_dst_check);
 
 static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
@@ -1337,7 +1337,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
-EXPORT_SYMBOL(ipv4_mtu);
+INDIRECT_CALLABLE_EXPORT(ipv4_mtu);
 
 static void ip_del_fnhe(struct fib_nh_common *nhc, __be32 daddr)
 {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8d9e053dc071..f0e9b07b92b7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2644,7 +2644,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry *ip6_dst_check(struct dst_entry *dst,
 
 	return dst_ret;
 }
-EXPORT_SYMBOL(ip6_dst_check);
+INDIRECT_CALLABLE_EXPORT(ip6_dst_check);
 
 static struct dst_entry *ip6_negative_advice(struct dst_entry *dst)
 {
@@ -3115,7 +3115,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ip6_mtu(const struct dst_entry *dst)
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
-EXPORT_SYMBOL(ip6_mtu);
+INDIRECT_CALLABLE_EXPORT(ip6_mtu);
 
 /* MTU selection:
  * 1. mtu on route is locked - use it
