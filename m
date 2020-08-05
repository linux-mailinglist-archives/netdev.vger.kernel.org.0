Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4270823C5C8
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgHEG3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEG3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:29:32 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DE2C06174A;
        Tue,  4 Aug 2020 23:29:32 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 2so23232537ybr.13;
        Tue, 04 Aug 2020 23:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pB1w9jsyKSMHHjSggebavSz1p5lbo1PnfNYJVq/WXkU=;
        b=ruu39fOkanV+J4spBpAq6pPKZOBPBa0J6Ujw9QGrKhBd3DvUOGEniFoqRN0ti8m4Al
         fwyvomIdIL6Dsx6PoHYvdpmErPdA+LzIbEtQR7EEceuZc4ByZ3aY2C3iteid5uqI9C92
         p3a1wJ7Q8KPS6pU7rG4JIJAvQNF44EtH6s+T+R6dAvxM2w4jVusMOfuHvKWG7I9Rxr+s
         VDNmPr94iGNNHtmTZZESdWvKuoVb2ykb26rEWF255rTnIEtPmz2aacFob7gWaXbhFieY
         Y9XzpRozhPrSxCrcT9WOi0xfqTE6TdRjm3kOMl08qHwaHmv79ruz7ilHS8Qm3Bywx90/
         cOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pB1w9jsyKSMHHjSggebavSz1p5lbo1PnfNYJVq/WXkU=;
        b=HZVsUoy1+yFZkx3X39x4ftsmkxlmoCpdGisVcZfq6vh7pPMCJN1fN6Efu+k1jg59zc
         o3M0Eoj/w4jQCPdGkINnjUKvLHP6cl7Tiu/fZ31yZMnI2QCiwCWLJzqYmORb4kweBRxK
         1Il9XzvakRVeOFT9u/uMpM/OdqPLNh9RgNOkanp3E85Qi8JeBb1h11b2dRW+CJbyfUBC
         tYWcLqwQ0g5w/t2EGrPHiHAS23R/7t23yYsKVpHIkas87UIVTKI+gPZQ/XbWSc8a4Mtn
         lcnpg4CY51XGaTojYjH8/UyYMoWHUyxOvituTEVm5pySAN/+OR4uOSy1mw+NPTUmaGCd
         w8Tg==
X-Gm-Message-State: AOAM533O2lHHYBSq9v8gBbbVelHfkoMdiHV7vpKDroPyH+Pjz6HD055x
        lfFFZw2hyAQwL2N3wgJ77HQ/1ZIg+u/GMbTWRgU=
X-Google-Smtp-Source: ABdhPJzAYhO7SC4VCUTHnXYmE2qR7WLqT+06iNv/UGLY6QUE7wCmGmxS/8rQMuuPGAfGvCRGv831UzZ/YagJOpapDjI=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr2372506ybe.510.1596608971752;
 Tue, 04 Aug 2020 23:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-10-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:29:20 -0700
Message-ID: <CAEf4BzbwWzSqVPxOJdA4WbTu6EUUvm=TPDTMyE8ZPF5LP96HTQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 09/14] bpf: Add BTF_SET_START/END macros
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to define sorted set of BTF ID values.
>
> Following defines sorted set of BTF ID values:
>
>   BTF_SET_START(btf_allowlist_d_path)
>   BTF_ID(func, vfs_truncate)
>   BTF_ID(func, vfs_fallocate)
>   BTF_ID(func, dentry_open)
>   BTF_ID(func, vfs_getattr)
>   BTF_ID(func, filp_close)
>   BTF_SET_END(btf_allowlist_d_path)
>
> It defines following 'struct btf_id_set' variable to access
> values and count:
>
>   struct btf_id_set btf_allowlist_d_path;
>
> Adding 'allowed' callback to struct bpf_func_proto, to allow
> verifier the check on allowed callers.
>
> Adding btf_id_set_contains function, which will be used by
> allowed callbacks to verify the caller's BTF ID value is
> within allowed set.
>
> Also removing extra '\' in __BTF_ID_LIST macro.
>
> Added BTF_SET_START_GLOBAL macro for global sets.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h           |  4 +++
>  include/linux/btf_ids.h       | 51 ++++++++++++++++++++++++++++++++++-
>  kernel/bpf/btf.c              | 14 ++++++++++
>  kernel/bpf/verifier.c         |  5 ++++
>  tools/include/linux/btf_ids.h | 51 ++++++++++++++++++++++++++++++++++-
>  5 files changed, 123 insertions(+), 2 deletions(-)
>

[...]
