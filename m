Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B9513B72B
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAOBp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:45:28 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44139 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbgAOBp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:45:27 -0500
Received: by mail-qv1-f68.google.com with SMTP id n8so6666623qvg.11;
        Tue, 14 Jan 2020 17:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=26pT0x9nMPAWkcZLswp2shSuQ606h/dQkzwogdMerR8=;
        b=fcvcAPfzeF19IeB3wfsRvhJTVMn0thbdWMpk4lmOzmFmU1SEv+rNDS1jvskDa+aPcV
         VGwR5lrQ8uk6b/r7H+ozZzIyPtSAzpZ8iJ1j09AdHUcyqCPUBOGw8meBGNCNygoXxfk3
         ycGsVwnf9F0Ovd70+UfO2l5VfWK5YR+o1ly9nao6hbDN0SrtPlpEfbnnaldp+nYpk0s6
         5EM4vctam2S9hZJ2GfVTNZvf3IfsnkQr/fc/mWV5PYlRLiGE6SpbkRULF+8ITkmGFmvn
         jzqymxMRb8kTequv03+REu26890zaG8UqO1P4j+7gOWzOsqnuaHBqL2+Uv34FIlPXMet
         NCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=26pT0x9nMPAWkcZLswp2shSuQ606h/dQkzwogdMerR8=;
        b=sDTRS+oQbBt84lDisOp9y1a4orb4cVgGk3Ay45Ur67nRJV0Qr+f41bso7p+HzVWj+h
         NBpgnmRYv6bsgzf8F1AwJ2bnPerp1IKyW6W1JPBl1L8vJRe+Mf4BUppaYA6XWLZZFX2b
         i4w3M3X7VrioC7cuk6gOmjbAKj5hXONIxHcZaXFk32iRggPY7l8Sv6dG/f1acI+zKb0F
         LdIFBCmoobscO/ykhVTfkB6Cd0J3i3YhHvQmpY0zQ9RLqkFfHN9Lf4+AvY6dNrcyKloV
         MxagLh/XQMur8hJaFLhjJksIEPKIgVoko49D6Jle+ABvRZCHo+nq8Fym8v9coODHb2mg
         I/gQ==
X-Gm-Message-State: APjAAAWKcvszyFZ3i3NLYdWIO4nDmRAcouM2LwuxTQp6enp1f5L8clfL
        whmTJCbzHMPC3cIwTEO1tyiAHok3XaZD5DpbC3jaIg==
X-Google-Smtp-Source: APXvYqxouNDd5psikCf3YmiaTn+ShjuxNMKVBSO+YN3IDZtJenV59iGL9cHihNYI2wktrLKBhA8zGDt9riQRJ496YPA=
X-Received: by 2002:a05:6214:38c:: with SMTP id l12mr19807539qvy.224.1579052726736;
 Tue, 14 Jan 2020 17:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224419.3028615-1-kafai@fb.com>
In-Reply-To: <20200114224419.3028615-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 17:45:15 -0800
Message-ID: <CAEf4BzaTxSMoHPYEVZoMJ+vRZ+y4bGnxm7k10dhOOPzev23eRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpftool: Add struct_ops map name
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds BPF_MAP_TYPE_STRUCT_OPS to "struct_ops" name mapping
> so that "bpftool map show" can print the "struct_ops" map type
> properly.
>
> [root@arch-fb-vm1 bpf]# ~/devshare/fb-kernel/linux/tools/bpf/bpftool/bpftool map show id 8
> 8: struct_ops  name dctcp  flags 0x0
>         key 4B  value 256B  max_entries 1  memlock 4096B
>         btf_id 7
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/map.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index 45c1eda6512c..4c5b15d736b6 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -48,6 +48,7 @@ const char * const map_type_name[] = {
>         [BPF_MAP_TYPE_QUEUE]                    = "queue",
>         [BPF_MAP_TYPE_STACK]                    = "stack",
>         [BPF_MAP_TYPE_SK_STORAGE]               = "sk_storage",
> +       [BPF_MAP_TYPE_STRUCT_OPS]               = "struct_ops",
>  };
>
>  const size_t map_type_name_size = ARRAY_SIZE(map_type_name);
> --
> 2.17.1
>
