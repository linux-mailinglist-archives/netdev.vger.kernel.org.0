Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA06145E7F7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358930AbhKZGof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358954AbhKZGmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 01:42:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D09C36113E;
        Fri, 26 Nov 2021 06:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637908762;
        bh=3loIOsbjaVBjUIw0XjrFpdVXb/TakqQHsVPt7HrW8YA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qFy9w5PDWuQQWDXcJFnSnFPQbDw/LurZdC+vq3iJoCahs4Ql0wQ7mSglFj3UKQKC3
         QVrBteW76ll4j/Dp45Ioh2nzTBeMZzjkQ3LTqxGAgyJWyAJwSf9PKsvN0QWlnaiYHq
         O1mdRrIk+lFvLANkqhkEGYHJah8kP89RKxIi6nW0IoAfKzs1MuyvqYsbfnj+4D+xE/
         XrXDmWBSKVzuNSzjcULwl8Rk9Pjz9YzPsHakflcEDf6dMKJbGPeqM5Wt3WQr47Kn5l
         Rr1ltTj/9HTa/Dy8gWSbUlKNcTPRdJkLzAyvQ6rpMCWgNzfEP565GvG9IJFtbBt8o4
         hUX/3jU/e8FJg==
Received: by mail-yb1-f170.google.com with SMTP id e136so17563196ybc.4;
        Thu, 25 Nov 2021 22:39:22 -0800 (PST)
X-Gm-Message-State: AOAM530SlL9FepySK4CpMhkwvUz15LGEg/p0L7olOicVLsbM9oNBML2R
        ux4KwB6lwolgMQxUXCZ2Jevhw6PkmHI0FEXVRA8=
X-Google-Smtp-Source: ABdhPJwLMI+8JEW9OLSm+cclY2jOEC3aCuhIHZVnimU7p8AXdqgH+7ahfHWK8BiEEiBsdZYtk7NAF/GDIP4iG+3ykNM=
X-Received: by 2002:a25:bfca:: with SMTP id q10mr13225711ybm.68.1637908762059;
 Thu, 25 Nov 2021 22:39:22 -0800 (PST)
MIME-Version: 1.0
References: <20211119163215.971383-1-hch@lst.de> <20211119163215.971383-2-hch@lst.de>
In-Reply-To: <20211119163215.971383-2-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 25 Nov 2021 22:39:11 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5i9iniGoLKK4D4dArs7jkgscNBxOPLeSZNpZ3v1dWj6A@mail.gmail.com>
Message-ID: <CAPhsuW5i9iniGoLKK4D4dArs7jkgscNBxOPLeSZNpZ3v1dWj6A@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86, bpf: cleanup the top of file header in bpf_jit_comp.c
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 8:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Don't bother mentioning the file name as it is implied, and remove the
> reference to internal BPF.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <songliubraving@fb.com>
