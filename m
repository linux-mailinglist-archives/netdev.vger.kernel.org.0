Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3AD25E376
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgIDVvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgIDVvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:51:32 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE1FC061244;
        Fri,  4 Sep 2020 14:51:32 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h126so5384486ybg.4;
        Fri, 04 Sep 2020 14:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AqLospb6tOr6N5FnzZO5s3jnQw/VU/zkiPb67ZFZhio=;
        b=i58/7bAKvnrHtiR2bHp0IJjg9lve7mlD3PtaVQGa9KrnmmWSbNEFJoGlWh5tBfag4s
         ODZW78v5flkCmpIi8MP1FjRV3GfL56IzR5G5qgDe8Rx3tj+UUA8GtyGNsBpLHQdRUTZl
         nBvHJJJZ9PT2pwOf7sTy44VDjBYR26Xyq1y8VNNUUGxy++S4kuzRhZY9LEjxEnjf++RG
         gTDdouIqofWXFzBVy8ITtchqIFJzoQXbmH0eIW2hi057sRFwV/HQnHTDqJH0KKsodTuK
         n/x1VJZe5jcxDlaVilE1anD/hw8K4cvZAIiy12PiAOeBA77Wr6tBPO2sUaDiTbSkKxeG
         A7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AqLospb6tOr6N5FnzZO5s3jnQw/VU/zkiPb67ZFZhio=;
        b=hbvrBIWuIm/rTzJXsW6R78Kd2Ju33Ji8Li1I4ma7UnXjPH6HR0YJBOplXC1io5R0ko
         zrUnXpkyEnQ0btIrv3mWut2AAqT0gNoDUBnEe83Gx0JJdu5FwfsvguAbcm+fpYPmpWM9
         rG/R5cN7wenEQhcRibJ+SGhapUsN0S4H9XhKrYDhBBA2rDM3u8ei2qDcJgUpzZB1mgXC
         TRZYYfDstcKiy/TBnOsL4OKU1Aw5kUFGw4chwLhyO85Pj59ei+E5dS9YSDP304k5izi1
         be01saeJLmMj5BvNrs3GbZzjZTln1WBTTaOSqnESLoQ9KVPCX0CNDnMjHfrvlFHN4Y03
         yMhw==
X-Gm-Message-State: AOAM533Sa8oHz+EAo/ldR7wqZ4HoLpcmMnVDXAAVgVBG5OwZr1Fit2CE
        1XVlyspsnggQA9zQVJ+ThAACQTdk8RfP+4DrxtY=
X-Google-Smtp-Source: ABdhPJw6fSbL5Xr3cESXKiIAPfXR0E9OJ/Ds/C2/wS5GcZwfV+UpdvwSAK+rMuJhgd6tF/1PqUpeAjs7kGUgtF+/5G4=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr11107362ybm.230.1599256291067;
 Fri, 04 Sep 2020 14:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200904205657.27922-1-quentin@isovalent.com> <20200904205657.27922-4-quentin@isovalent.com>
In-Reply-To: <20200904205657.27922-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 14:51:20 -0700
Message-ID: <CAEf4BzYFDi2w5mbu1Dgb6aTR2HsAXDs0=QbfUc-hwCHngKsaCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] tools: bpftool: automate generation for "SEE
 ALSO" sections in man pages
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 1:58 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The "SEE ALSO" sections of bpftool's manual pages refer to bpf(2),
> bpf-helpers(7), then all existing bpftool man pages (save the current
> one).
>
> This leads to nearly-identical lists being duplicated in all manual
> pages. Ideally, when a new page is created, all lists should be updated
> accordingly, but this has led to omissions and inconsistencies multiple
> times in the past.
>
> Let's take it out of the RST files and generate the "SEE ALSO" sections
> automatically in the Makefile when generating the man pages. The lists
> are not really useful in the RST anyway because all other pages are
> available in the same directory.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

but see note about printf and format string below

>  tools/bpf/bpftool/Documentation/Makefile        | 12 +++++++++++-
>  tools/bpf/bpftool/Documentation/bpftool-btf.rst | 17 -----------------
>  .../bpftool/Documentation/bpftool-cgroup.rst    | 16 ----------------
>  .../bpftool/Documentation/bpftool-feature.rst   | 16 ----------------
>  tools/bpf/bpftool/Documentation/bpftool-gen.rst | 16 ----------------
>  .../bpf/bpftool/Documentation/bpftool-iter.rst  | 16 ----------------
>  .../bpf/bpftool/Documentation/bpftool-link.rst  | 17 -----------------
>  tools/bpf/bpftool/Documentation/bpftool-map.rst | 16 ----------------
>  tools/bpf/bpftool/Documentation/bpftool-net.rst | 17 -----------------
>  .../bpf/bpftool/Documentation/bpftool-perf.rst  | 17 -----------------
>  .../bpf/bpftool/Documentation/bpftool-prog.rst  | 16 ----------------
>  .../Documentation/bpftool-struct_ops.rst        | 17 -----------------
>  tools/bpf/bpftool/Documentation/bpftool.rst     | 16 ----------------
>  13 files changed, 11 insertions(+), 198 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
> index becbb8c52257..86233619215c 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -29,11 +29,21 @@ man8: $(DOC_MAN8)
>
>  RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
>
> +list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
> +see_also = $(subst " ",, \
> +       "\n" \
> +       "SEE ALSO\n" \
> +       "========\n" \
> +       "\t**bpf**\ (2),\n" \
> +       "\t**bpf-helpers**\\ (7)" \
> +       $(foreach page,$(call list_pages,$(1)),",\n\t**$(page)**\\ (8)") \
> +       "\n")
> +
>  $(OUTPUT)%.8: %.rst
>  ifndef RST2MAN_DEP
>         $(error "rst2man not found, but required to generate man pages")
>  endif
> -       $(QUIET_GEN)rst2man $< > $@
> +       $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man > $@

a bit dangerous to pass string directly as a format string due to %
interpretation. Did you try echo -e "...\n..." ?

>
>  clean: helpers-clean
>         $(call QUIET_CLEAN, Documentation)
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> index 0020bb55cf7e..b3e909ef6791 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> @@ -214,20 +214,3 @@ All the standard ways to specify map or program are supported:
>  **# bpftool btf dump prog tag b88e0a09b1d9759d**
>
>  **# bpftool btf dump prog pinned /sys/fs/bpf/prog_name**

[...]
