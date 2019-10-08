Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5FFCF33A
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 09:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfJHHKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 03:10:18 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38867 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbfJHHKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 03:10:18 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so16331179ljj.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 00:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNNp45PkXC6u86dJZigRwiXGQlgxYDX+Lhu3Y2ObAyI=;
        b=Ysux192Z85VFSzHNyWXectFjwy4Fs7J7dT5BybeP2XyPKWbKidBHQjy8Zgp+6BlnRC
         NBx+IBfya9j+CMaQBJ0epHbJf3BBHH1hIEKeUXqvyj4V2zul1MY7sbUk8AGvi+IHjsC6
         qw8t1ud9eMoxVi1xAkG8stOXIv6iYVCoYikYq5mxyUVb/5m7HcyMEJFqXCG/uHJ1RNsf
         XkJWxqcIp7McxEe7BSCgkdKl5fDZjxEuswCR+B23778W2khwSPGDRGftF/60CyvU+CyY
         zhDXTwYQzbyYZ2ZW9zLp+Mk0a4c4tM4OUGJNAN7ixpep0KYbcv0PIZTH04Ti46sQSeTV
         SnKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNNp45PkXC6u86dJZigRwiXGQlgxYDX+Lhu3Y2ObAyI=;
        b=ITx9e6AyDyF9j7b6PCSHrtwkljYqR/a7KmWINoOHpW60Mah9JebYBVnOUyowM7+RT0
         68RO6eqBAOg56VeoA7CclJkZvfxPSjrkinLKWUCvWOIGAFc1zIT+Ar9SUbHHX4qkJ1o8
         /7oMMzJ/GQzATnuhCg8sVu3uN4aeymHlOR9SjR2qMepNyHIXGuJh6flOpLHGCj+vS22D
         tL45dt1v8A7o3UHgvC04JchCR+yb5WaLiy+e/ZsEBnYyhAMFHQ41PybeWwEQX6LNbWNl
         Ltn+8rSj/p6H68HF/vKs4kOTU13Nyal69K3gz/kZBxCcvPh8lZOZU92W2x8OBB4D8BUn
         VL+Q==
X-Gm-Message-State: APjAAAXlp6X6LrFhoDTxHVx6G1i/Qdfl38facjSJXyjh2dhGt3vydVC6
        QasGOSwYwNTZStYIDqboUxV+FHyhIVses8CozIM=
X-Google-Smtp-Source: APXvYqyEZ5i9IbjjHS9CX3ntOwUzg9Xhga7+lepICc2U4zbPLpLWzYb0kRRQd/pcmgyDwpZ9DPloSK4+azkx6PJZbC0=
X-Received: by 2002:a2e:9615:: with SMTP id v21mr21162871ljh.46.1570518616282;
 Tue, 08 Oct 2019 00:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com>
 <20191008053507.252202-2-zenczykowski@gmail.com> <20191008060414.GB25052@breakpoint.cc>
 <CAHo-OowyjPdV-WbnDVqE4dJrHQUcT2q7JYfayVDZ9hhBoxY4DQ@mail.gmail.com>
In-Reply-To: <CAHo-OowyjPdV-WbnDVqE4dJrHQUcT2q7JYfayVDZ9hhBoxY4DQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 8 Oct 2019 00:10:04 -0700
Message-ID: <CAHo-Ooy=UC9pEQ8xGuJO+8-c0ZaBYind3mo7UHEz1Oo387hyww@mail.gmail.com>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
To:     Florian Westphal <fw@strlen.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's my reasoning:

        old = ct->ext;

        //... stuff that doesn't change old.

        alloc = max(newlen, NF_CT_EXT_PREALLOC);  <-- will be >= 128,
so not zero
        kmemleak_not_leak(old);
        new = __krealloc(old, alloc, gfp);
        if (!new)
                return NULL;  <--- if we return here, ct->ext still
holds old, so no leak.

        if (!old) {
                memset(new->offset, 0, sizeof(new->offset));
                ct->ext = new;  <--- old is NULL so can't leak
        } else if (new != old) {
                kfree_rcu(old, rcu);  <-- we free old, so doesn't leak
                rcu_assign_pointer(ct->ext, new);
        } <--- else new == old && it's still in ct->ext, so it doesn't leak

Basically AFAICT our use of __krealloc() is exactly like krealloc()
except instead of kfree() we do kfree_rcu().

And thus I don't understand the need for kmemleak_not_leak(old).

So... what's my mistake?
