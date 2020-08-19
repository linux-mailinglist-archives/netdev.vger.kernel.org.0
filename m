Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA67024923B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHSBTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:19:49 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDA0C061389;
        Tue, 18 Aug 2020 18:19:48 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s195so12426975ybc.8;
        Tue, 18 Aug 2020 18:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IF1+sN2bHgVw9I8EtdfTD7NA3nCnYXNCHIQP5lfUQEU=;
        b=aCtt6WyhKz3jzfrz/OIq1POcXq9nnDTsXXTMQduFJbV9aMIvhGjsOYDgQ0UyvfXjC3
         4NLg3sw+XPojrboBJ3J5OiZufN+9bW9HUTrlq+llvL0N1zGEfFbhoN1Fot8Q6WOJHSov
         hVJOQ9Rh7ESP2KHezay8+J/WLi0OTJb/a3H4iF7aeOtFDl5PT5SRaB0KXkh/XHuuEAGR
         ZfukwENCSGPBgGN3WuZzpu4y/eI8xGHlpRpXVEpU7dfLWyuFAjTNHegYo+32egt5FrRk
         oD38LDphNy9MwLlC4Uvv1sx8CNtEyIlla6PoCAlgZ1+2yCesfHwj/umKEmrfv6VwygZg
         lfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IF1+sN2bHgVw9I8EtdfTD7NA3nCnYXNCHIQP5lfUQEU=;
        b=fMrejUYHA+FsucIx18UgnCjtlNvZuJ+hPjbp1sHLAcQPByCJMtOLEBVxmPzrd1mfQG
         g6EuF+eOLvcfZx12mkDsAtkRzKNN5aO3NleWOtF6D1QXz+hmNzvugViPskdYzCZH9Df9
         aVknNafXE1X7PkLtVJEIsOXhBoH1j9xKgU88ePmftx+MmVaYwS4MQ/9vH+d2l4Hrkjeq
         PHO+jglif/Vp0P2ndPvuD61du2n/yuQwPvo2kEGk1x8TVejWXKxEWS+PGHu0tlH6+f7i
         jURD6D+KgH2hh4bMZY3Y669cMMt0u+lxNr5ORpvw5W72x57sWaSB4d7qhUxiSwL2u0je
         GweA==
X-Gm-Message-State: AOAM531/ysSRUBlHusdVGhrap7TZipOLoO7hHFIzPcG7/BkHGaH4kB8y
        7pKHbxs7olwY8bcFVOl63wqlRlhbm6sU3oDxDE8j1qMU
X-Google-Smtp-Source: ABdhPJxftW79w2nI5r4jnNG2VkGvI4hSPelrLz2U9p5ZY6CwuN02nhzXzMrGk6UMW/mJ1QTq2iLBxwcQFnjGqrsoD9M=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr31245701ybp.403.1597799987602;
 Tue, 18 Aug 2020 18:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200818215908.2746786-1-andriin@fb.com> <20200818215908.2746786-5-andriin@fb.com>
 <20200819010835.3r7ch5h4wb4yue6k@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200819010835.3r7ch5h4wb4yue6k@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 18:19:36 -0700
Message-ID: <CAEf4BzYF8bor88TzOTY6rbmsWrnCkNBXHZBkvm6EzLJe4C+r_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] tools: remove feature-libelf-mmap feature detection
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 18, 2020 at 02:59:08PM -0700, Andrii Nakryiko wrote:
> > It's trivial to handle missing ELF_C_MMAP_READ support in libelf the way that
> > objtool has solved it in
> > ("774bec3fddcc objtool: Add fallback from ELF_C_READ_MMAP to ELF_C_READ").
> >
> > So instead of having an entire feature detector for that, just do what objtool
> > does for perf and libbpf. And keep their Makefiles a bit simpler.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> overall looks good, but this patch doesn't apply to bpf-next.

yeah, seems like patches you've already landed on bpf-next have
auto-resolvable conflicts. I'll rebase and post v2.
