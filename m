Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8B1094D7
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKYUuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:50:55 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34884 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYUuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:50:55 -0500
Received: by mail-pg1-f196.google.com with SMTP id k32so7786172pgl.2;
        Mon, 25 Nov 2019 12:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SFnG9c+0zslFmKghCOPwHgsw9dWwUFMfJUamxWevy1M=;
        b=JFp1xnuHZCjLNk1Mxd3+mE+m0l1IpMsZCgyWM7ZSRwAP7C5Dw/dGo13azO695xJkye
         ji+1qvYDdN7H85VZ3Xu42Di9wyAn+UtOOWh8mLNIVbnTEoMFOXK2im9t5gkjb+37pQJi
         Mkz01hLL7qFTK7Yj0KIfdjGRUnIXUjJd+HLAx6jblzaxloZq06t3dKw7P6hcYMBJQI5S
         c8sJkMTF6Ce70l++SkWYTY13Dz8k23LmmsbGLBdT/HtaG9aS0aBLPKBAZdueS+nCPjRx
         02GZG09Q5sXih+rdl12mXQJrx91WeY60lRLMBQFMNrqmHLBQ+TyDl+vLAQihyOFCEwv/
         VSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SFnG9c+0zslFmKghCOPwHgsw9dWwUFMfJUamxWevy1M=;
        b=HzQ/0oNDXbcvztDajQuA64LSF/yTTyKul/JF4rO6vbsMUL9H6TEEkRUIcAS6hbQ1F0
         CW6TW27TqAr8RDLo/OawP7GQ/+X/C7MbmPRDBz1HfBPXN6jdF//6EurUINruCWtOepJW
         qPJzJBJPCbWSYYEjXj4YrWsTaY4KvPfDOb0w/MjO/4D24yf1/bivYLomtjEjYz7TDMIM
         9B+i6nllMRyXyghl9ffm3IjRr5mJOwuPxldzIJcY92hXrNcFsva5eNQFg6s0w4aBfMZ1
         o57DreYnf0/C29jYu6tG7VPq/kZaVe6UXXd4rT2bVVfYkpmMk4P+AIpGjcKEzksxbkCr
         ps9A==
X-Gm-Message-State: APjAAAXFoNgJnbguLFignAeNsyEj8ovQ7FC+WjplwS0HHXUyBCGZ7p+m
        4JZvhNad6eEHNSyMgxGI11k=
X-Google-Smtp-Source: APXvYqzf3UUdFC/QFurmNV7QmBdHXoriwKiEo0wDrb1+32qv73cHFfVor1BwXMs7MqbmdBlWQxMtFA==
X-Received: by 2002:a62:fb0e:: with SMTP id x14mr37374342pfm.194.1574715054782;
        Mon, 25 Nov 2019 12:50:54 -0800 (PST)
Received: from localhost (74-95-46-65-Oregon.hfc.comcastbusiness.net. [74.95.46.65])
        by smtp.gmail.com with ESMTPSA id x2sm9336109pgc.67.2019.11.25.12.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 12:50:54 -0800 (PST)
Date:   Mon, 25 Nov 2019 12:50:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Message-ID: <5ddc3eada4ad1_78092ad33cdb65c0b0@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4Bzbii9W=Frc3aPLrLsCWq1fFJXADhhQ4w7_d15ucqBuWHg@mail.gmail.com>
References: <20191123220835.1237773-1-andriin@fb.com>
 <5ddc3b355840f_2b082aba75a825b46@john-XPS-13-9370.notmuch>
 <CAEf4Bzbii9W=Frc3aPLrLsCWq1fFJXADhhQ4w7_d15ucqBuWHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] mm: implement no-MMU variant of
 vmalloc_user_node_flags
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Mon, Nov 25, 2019 at 12:36 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > To fix build with !CONFIG_MMU, implement it for no-MMU configurations as well.
> > >
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  mm/nommu.c | 15 +++++++++++++--
> > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > >

[...]

> > Hi Andrii, my first reaction was that it seemed not ideal to just ignore
> > the node value like this but everything I came up with was uglier. I
> > guess only user is BPF at the moment so it should be fine.
> 
> Yeah, but that's what other node-aware vmalloc() variants do in
> nommu.c, so at least it's consistent with other cases. Thanks for
> review!

Great, at least folks (not me) who are used to working with no-mmu APIs
will expect this then.

> 
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>


