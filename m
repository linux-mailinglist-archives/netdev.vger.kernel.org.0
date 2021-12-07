Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D460446B177
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhLGD0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbhLGD0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:26:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F84C061746;
        Mon,  6 Dec 2021 19:23:09 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id f186so37051186ybg.2;
        Mon, 06 Dec 2021 19:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MW07K0MrFAu2xQfDoW0bQgBPKA2ToS58ph8BV+OA0js=;
        b=fqTDqw8WQYbT/xGm7g48YauGBVFiUdsVqnt6pfOV3d2dvIXHKjBOuRpWKewZtWoSWP
         S5iPCkfMjN4CMXSA31GYUSde7rnihTwKcbxEQxVbZFMndOaGy73CAmWkSu1mQkfkXAIl
         c+GRD2r3/5FWP2JLqW7iD0TXkX3dcFiQvexhlC6PIGjr4cRC6bCbhw1WeRAWyO9+a4Ql
         ViPf2f9vR58J5b9zaFRqcX1AXgxphd9Cj/Itf5Jj4ax97O6oKY9bll0RueDE575VbGzl
         aVzA3m4DDVCoOiTpNJxNAZ6log+MthWS3RNnNLnndOIecdQTEmA6PAUkr+hdjWQNy642
         U5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MW07K0MrFAu2xQfDoW0bQgBPKA2ToS58ph8BV+OA0js=;
        b=5J15V5LhoEUOm6tQ9KDbazLmLWhWLzwBYt4X8JLjae8dvSmFVH6HLXqhS+oovB0IHs
         vynUQ1tuXaDJBRiF0uaEMnemEOijkKNYjDl5WbOq4ROxLba3n9b0aVCTuJPBfOl49EbN
         +0YcvRxYGfoul0+9//rGsMQ8pnfdK9mx03uqOuW1cv70TYAtNzBqyXQGyD47IrsK6sFu
         eAh7gidtCThQ2iXS0/HjoZTZ3HfMmkOpE2hD4k0k9Um0WR/N2ScLCfQskgrtmqb2xFSf
         /25F5MRVKZKcQgxHrKnUSvqbT14IyR57d2PHxfsABBWZlXyMEk5nBBi4xGTnhAKjgwIf
         u7Nw==
X-Gm-Message-State: AOAM533adS3pM/DiE13i7HbHnnd0g7jj6O7DhAv1VljLBd0RtOgc40JG
        LKsfDvcWnhZTo2N1uT+LB4ccV80opX06BQNZWi4=
X-Google-Smtp-Source: ABdhPJycHxvJtKMzj7FhQDNdExGHKoDBkSNC85yJuGrUBZACR3dT6+M2BSA9iN+WDbkAIwOrxM1suydz9DwJDfMkqOM=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr47466264ybi.367.1638847389122;
 Mon, 06 Dec 2021 19:23:09 -0800 (PST)
MIME-Version: 1.0
References: <20211206105530.0cd0a147@canb.auug.org.au> <20211206114348.37971224@canb.auug.org.au>
In-Reply-To: <20211206114348.37971224@canb.auug.org.au>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 19:22:58 -0800
Message-ID: <CAEf4BzbiXhNk5xVQnZy11R697jmZEEQePwpSSNu+00x8hZ+Z1g@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 5, 2021 at 4:44 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> On Mon, 6 Dec 2021 10:55:30 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the bpf-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> >
> > kernel/bpf/btf.c:6588:13: warning: 'purge_cand_cache' defined but not used [-Wunused-function]
> >  6588 | static void purge_cand_cache(struct btf *btf)
> >       |             ^~~~~~~~~~~~~~~~
> >
> > Introduced by commit
> >
> >   1e89106da253 ("bpf: Add bpf_core_add_cands() and wire it into bpf_core_apply_relo_insn().")
>
> And this is a build failure for my x86_64 allmodconfig build.  So I
> have used the bpf-next tree from next-20211202 again.

This should be fixed by [0] which I just applied to bpf-next, thanks
for letting us know! The reason you noticed this and we didn't is
because your version of pahole is probably older than what we use
typically and doesn't yet support kernel module BTFs.

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20211207014839.6976-1-alexei.starovoitov@gmail.com/


>
> --
> Cheers,
> Stephen Rothwell
