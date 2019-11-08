Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A8AF57DF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbfKHTod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:44:33 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35027 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfKHTod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:44:33 -0500
Received: by mail-qk1-f195.google.com with SMTP id i19so6359061qki.2;
        Fri, 08 Nov 2019 11:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Taf5lDIACcsUMUYYZb1cwmHNgWioP2AAf/2pbToCedc=;
        b=InKfIzwzqrDumA6QUOrLunA0djmfzGbVG3ybtFt+PDfVh2UQhfAKbrMm0rpFl1daZh
         svoDte9ATfxpqnZG+IL6D9KU6LX1bRpNEU6MWfWMTiSECHT8usyAFxMqNdAZ79OH4f+9
         mEnJxm9jkaVhAwm26mlayKEWSUCqUYPL7mvyu/8y9EIO41UfHdyDq6yMa7pUxZjNV40P
         izz3gz1sw6EDWJFzecg11Zzj8ky/dy8FY9ONj57aEWTzqefbuL1B8nowqjuf621/fXgt
         XGDdlnjVCyRAwVPNjZf0ko3zNKjIH8AJL5M/oGsflzpeAE8s6ZKEsfholIZ8zqvus9n1
         DxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Taf5lDIACcsUMUYYZb1cwmHNgWioP2AAf/2pbToCedc=;
        b=FQkdoRrikKC5hqgxrtZJmTeBnMOZ2cZUcdWfwCxEg3totCQ7xqSvJvfAUIfYLR80zd
         ohczBw5Mnox2fQ+B3BfVs1gcBo05wGvV0YYga8xdLC3WqSc/ksQKPPHcKcGIz7v2IzS4
         QQYpdUq3z8Qq0sj1PAzEzBMIcBso4eaOXFh2gXLuSnUojtabhIwYSzIvayiN9syUxEpR
         nQfBR/hqB34Zs+Bfi/fisbS/l84sWDIXw8c3F0+kKeksN5gnpih1CEv5H5F4nfuKM5p9
         JXXCAouRmReuUDtRA9Qi3gAVV7YTMwXytkWCzjDFLW0sYlH7bTuMgidmZMvSt99LzBPC
         BRtA==
X-Gm-Message-State: APjAAAWhfB5A2V/J7Eti3pxySCLBeBlYgTY7McWBLdrshkjYA/395/w7
        1loD4JDSTu5dJxQsdUwxpGysC9pToB6ZXHHn568=
X-Google-Smtp-Source: APXvYqwI8UjSHDUGwpMAYtI/uLPR4JxiOAEW6a+DRZcKgOL3KtvXwDecUEU4gPQ9O+MX7jyU0q/F3/teYyf15/dHT14=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr11289454qke.449.1573242271981;
 Fri, 08 Nov 2019 11:44:31 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-6-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-6-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 11:44:20 -0800
Message-ID: <CAEf4BzZaid7Cj=NCMYNyDvTY6T3X7ECNWxcpBpOKxLnHxVeUTA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 05/18] libbpf: Add support to attach to
 fentry/fexit tracing progs
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:41 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Teach libbpf to recognize tracing programs types and attach them to
> fentry/fexit.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/include/uapi/linux/bpf.h |  2 +
>  tools/lib/bpf/libbpf.c         | 99 +++++++++++++++++++++++++---------
>  tools/lib/bpf/libbpf.h         |  4 ++
>  tools/lib/bpf/libbpf.map       |  2 +
>  4 files changed, 82 insertions(+), 25 deletions(-)
>

[...]
