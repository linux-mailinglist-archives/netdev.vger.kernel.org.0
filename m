Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E885D30EB2E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhBDDxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBDDxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:53:00 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF5C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 19:52:20 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v123so1793193yba.13
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 19:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DTbQuqDgftJHyEjgUZ53qqE2GLvug2RthYORKONmJnA=;
        b=fKFmn6G4Gfcvpduh4jqVWeOKN+SFpsRhlVPOm6PDL8uJ4neFU13Qr37PqAiAKwknxr
         M3/axZFZaSNRvW2AoAkWw/pdu2JAEIy4U7Cxs8WuHXtv+Ket5yS9QE3QuoUUxEEIP0Mu
         ux7PvimGsRNvNxfYt4qnv7p5IiAJ/Kd80haGbuh6BfCH5eTRhj0peYdPSoGw3+HHsot3
         sVzeQN2gMxpwCLZo1Du+HlAQxmJjmyDkxbnJkPccM4bugHS+NKzUhYztHvBvZw4zQqFH
         6BtW4naZohotxE+Vk8xzPj25pwFuGtN38BsgadZn4vM0Pdgu1QXFpDONGGI+Uh4RpZma
         4bjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DTbQuqDgftJHyEjgUZ53qqE2GLvug2RthYORKONmJnA=;
        b=fHu8zB4FlEeZU6H8JN4H0NUchrtwhoPSNzTES9eBxVWfX2/6hwEMq0OQzHrDHQtPmh
         yWu1oJXcdV9Q3gkkIPgKGfqd8ySV8aPFA4v79wV/uIZpDzzC0d1Ea75x+6mIuqmueTJW
         nfbSOx9sfW/CpdVk21jHozMCRS9oqooGssqXQCRMvi5bYBYyrNd3OP/Oe6ltnc/DoWwS
         1lOXUNBjF2Sz7ed6P4DTA+CXN27WdIeq2kfN5fsxVtswOsEd0MfshvKYnoCsRkJjEgtV
         IfRNJZqvsbQ3f3GBF2TRPsVeDPIgnKQO/eWafXmUv8dnGvHZrTfNYkeGfCiWCBY0OnAP
         hjsA==
X-Gm-Message-State: AOAM530b70VuoSz4B1BWK7J1vsnnk3VGxhrDCPd0nLniC6WTm7MhhzuP
        V38DoVFWl6QQ6rFkGOfvGQ6eq4V95l+tU8z7qKSldCu4KdXO/Q==
X-Google-Smtp-Source: ABdhPJyrNWC8Z23u1QzxD8RKdn2OmMWUinNwzXsyuQIyMMWnQAyqlUiGmylA0J6AAajpbdZqAu71xsery3qJ/sAVDA4=
X-Received: by 2002:a25:244:: with SMTP id 65mr9660395ybc.511.1612410739666;
 Wed, 03 Feb 2021 19:52:19 -0800 (PST)
MIME-Version: 1.0
References: <20210204123331.21e4598b@canb.auug.org.au>
In-Reply-To: <20210204123331.21e4598b@canb.auug.org.au>
From:   Brian Vazquez <brianvv@google.com>
Date:   Wed, 3 Feb 2021 19:52:08 -0800
Message-ID: <CAMzD94RaWQM3J8LctNE_C1fHKYCW8WkbVMda4UV95YbYskQXZw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen, thanks for the report. I'm having trouble trying to
compile for ppc, but I believe this should fix the problem, could you
test this patch, please? Thanks!

diff --git a/include/linux/indirect_call_wrapper.h
b/include/linux/indirect_call_wrapper.h
index 54c02c84906a..077f96be65c6 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -36,6 +36,7 @@

 #define INDIRECT_CALLABLE_DECLARE(f)   f
 #define INDIRECT_CALLABLE_SCOPE
+#define INDIRECT_CALLABLE_EXPORT(f)    EXPORT_SYMBOL(f)

 #else
 #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
@@ -44,6 +45,7 @@
 #define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALLABLE_DECLARE(f)
 #define INDIRECT_CALLABLE_SCOPE                static
+#define INDIRECT_CALLABLE_EXPORT(f)
 #endif

 /*
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9e6537709794..9dd8ff3887b7 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1206,7 +1206,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry
*ipv4_dst_check(struct dst_entry *dst,
                return NULL;
        return dst;
 }
-EXPORT_SYMBOL(ipv4_dst_check);
+INDIRECT_CALLABLE_EXPORT(ipv4_dst_check);

 static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
@@ -1337,7 +1337,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int
ipv4_mtu(const struct dst_entry *dst)

        return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
-EXPORT_SYMBOL(ipv4_mtu);
+INDIRECT_CALLABLE_EXPORT(ipv4_mtu);

 static void ip_del_fnhe(struct fib_nh_common *nhc, __be32 daddr)
 {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f447f82e6819..75d6a0db1fa6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2644,7 +2644,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry
*ip6_dst_check(struct dst_entry *dst,

        return dst_ret;
 }
-EXPORT_SYMBOL(ip6_dst_check);
+INDIRECT_CALLABLE_EXPORT(ip6_dst_check);

 static struct dst_entry *ip6_negative_advice(struct dst_entry *dst)
 {
@@ -3115,7 +3115,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int
ip6_mtu(const struct dst_entry *dst)

        return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
-EXPORT_SYMBOL(ip6_mtu);
+INDIRECT_CALLABLE_EXPORT(ip6_mtu);

 /* MTU selection:
  * 1. mtu on route is locked - use it


On Wed, Feb 3, 2021 at 5:33 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> ERROR: modpost: "ip6_dst_check" [vmlinux] is a static EXPORT_SYMBOL
> ERROR: modpost: "ipv4_dst_check" [vmlinux] is a static EXPORT_SYMBOL
> ERROR: modpost: "ipv4_mtu" [vmlinux] is a static EXPORT_SYMBOL
> ERROR: modpost: "ip6_mtu" [vmlinux] is a static EXPORT_SYMBOL
>
> Caused by commits
>
>   f67fbeaebdc0 ("net: use indirect call helpers for dst_mtu")
>   bbd807dfbf20 ("net: indirect call helpers for ipv4/ipv6 dst_check functions")
>
> I have used the net-next tree from next-20210203 fot today.
>
> --
> Cheers,
> Stephen Rothwell
