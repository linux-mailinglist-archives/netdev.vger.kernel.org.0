Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAAC1A6EFD
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389507AbgDMWSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 18:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbgDMWSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 18:18:46 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FAAC0A3BDC;
        Mon, 13 Apr 2020 15:18:44 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id q17so8295127qtp.4;
        Mon, 13 Apr 2020 15:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJ5NBFnu/tYX2EZF6UDVtLs68g/DvkW9brjUUR+A0ho=;
        b=H0K2zcq4q3ykBXD0EojLSt00V+t4fV6AASFUPNw/eDJhBTt5OL1OJSnqQcbGDN81xg
         G7s/fM5IfB9ANb5Vc2RWwBRGM+zwnfdzIYU49iWlU0sHEZaEpQ7+B39ArJP50pdR3YuM
         lb8hT8gm02zGTeH6E+ouR1ThsfN7So3XqbfBB+VCK6Q4VcyHRxu6H0vBXzW+wXXKL4XN
         nmkerWDAf3tQGkvbJFa700vXvKH8l21pw4muYCrelJ5snOqZf9ogaY/t4SVM4mHLybhO
         sVbdjqozP2IqvoIYuRMDnrOAwmz5rHwp0qHXzIevSOQNGF9QNt/2dmh5nXZWpvDFHjB+
         gnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJ5NBFnu/tYX2EZF6UDVtLs68g/DvkW9brjUUR+A0ho=;
        b=kd2IWrcbURQ5l4x51GsqCPC4m0rmscFE2xq8HdY8ic9sgzzBDn5+Khx5fHkRz0HghF
         Is/92w5uKb5dM13SFHFQLVIZt/sNHw+2VjUswo5tgdnuaPCTEM6+ywozHGqL2i5+d7kJ
         Y/CK9mYOFRq0uSdG+UI1LL/k7HeXDboPtiO6MJP+dudfQcatBIc59n8x5J9ObxUt/l6n
         YTsp/DGz1YNqhfwtEXt03xCBc3EmxhSXwPB1if3AyAHYp44GKITy9BsqiKXPZtvAqM6c
         r6TonBpS1bdensSczbXI1kVbPrfqDZW/un92bvGH8ynABOEj35M4fLZdQWY/tAijrjKq
         L+4g==
X-Gm-Message-State: AGi0PubVB0saZi/gwd9bwlNhbwSYrXqUPiU9WGiMZxovQ+8nzk7hfxjJ
        vxJYPDgHI7xjcCNSfukNBTr/RC3AocJileBCNkU=
X-Google-Smtp-Source: APiQypL0M79NKOE9vX6eogcC2C9CgFI9+yoAB/gSsXNWPIwVc8MI5gSQOP2qNk3lobwICI0lViRLV+NmREPSu3pPU7o=
X-Received: by 2002:ac8:1744:: with SMTP id u4mr6828435qtk.141.1586816323259;
 Mon, 13 Apr 2020 15:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232528.2675856-1-yhs@fb.com>
In-Reply-To: <20200408232528.2675856-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 15:18:32 -0700
Message-ID: <CAEf4BzaBA_t9HUzTpnHFfqyxP0u-4hFJ0V9KW5DE1Tm6KOC9Kg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 07/16] bpf: add bpf_map target
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> This patch added bpf_map target. Traversing all bpf_maps
> through map_idr. A reference is held for the map during
> the show() to ensure safety and correctness for field accesses.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/syscall.c | 104 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b5e4f18cc633..62a872a406ca 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3797,3 +3797,107 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>
>         return err;
>  }
> +
> +struct bpfdump_seq_map_info {
> +       struct bpf_map *map;
> +       u32 id;
> +};
> +
> +static struct bpf_map *bpf_map_seq_get_next(u32 *id)
> +{
> +       struct bpf_map *map;
> +
> +       spin_lock_bh(&map_idr_lock);
> +       map = idr_get_next(&map_idr, id);
> +       if (map)
> +               map = __bpf_map_inc_not_zero(map, false);
> +       spin_unlock_bh(&map_idr_lock);
> +
> +       return map;
> +}
> +
> +static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +       struct bpfdump_seq_map_info *info = seq->private;
> +       struct bpf_map *map;
> +       u32 id = info->id + 1;

shouldn't it always start from id=0? This seems buggy and should break
on seq_file restart.

> +
> +       map = bpf_map_seq_get_next(&id);
> +       if (!map)

bpf_map_seq_get_next will return error code, not NULL, if bpf_map
refcount couldn't be incremented. So this must be IS_ERR(map).

> +               return NULL;
> +
> +       ++*pos;
> +       info->map = map;
> +       info->id = id;
> +       return map;
> +}
> +
> +static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +       struct bpfdump_seq_map_info *info = seq->private;
> +       struct bpf_map *map;
> +       u32 id = info->id + 1;
> +
> +       ++*pos;
> +       map = bpf_map_seq_get_next(&id);
> +       if (!map)

same here, IS_ERR(map)

> +               return NULL;
> +
> +       __bpf_map_put(info->map, true);
> +       info->map = map;
> +       info->id = id;
> +       return map;
> +}
> +

[...]
