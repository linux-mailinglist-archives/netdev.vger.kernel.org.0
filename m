Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA2714D53F
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 03:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgA3Chb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 21:37:31 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35179 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgA3Cha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 21:37:30 -0500
Received: by mail-qk1-f195.google.com with SMTP id q15so1563942qki.2;
        Wed, 29 Jan 2020 18:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N9sTfsZSVlzdAZJS8rZ2XysrVQb70vSA4wGXWk8IlB8=;
        b=fEYgE58MNh2/UCUtVztVzlA9oq6eVY4Rzl5HgK67m/XFgbP/cBvmM/A0SVpJEgqE8d
         5N41gQuXgFw03HsyfS3EvnASKV3lKp7Zkl/3DpHkHqTIRrzSKcvXCKEUnn7v0Xj3R3Sx
         d7/QCIS7NWk25zBHI1W7KjzTGrAVrR2JjeluWRGo6mlcxfVvihh0Liw9mKOeCGFXgZXV
         pbmH3P1Ps+wreMvzgDtIaeTDMo9oz9dg1NWGqC1ZwaDv6EqeMl/cqYIpWumFd3nC2SSI
         6HRsmoge5TYvVSVQjEzGsRuS212ACuJe/ETE/lft1rb2Wkfapm5csxJH8DQ6Ck5f7zR4
         sbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N9sTfsZSVlzdAZJS8rZ2XysrVQb70vSA4wGXWk8IlB8=;
        b=KQ8q98A5t/ppSNAPNIo9NMvhqyPFc65XKOZVPo9YoEdWp0tAOQ4P+FjRJXjkUyD8VE
         hjIf1rX9nMkt91rWrMFkSRWcXfZPa1jqUcJvpCba2dmU/hxbGQDgN4zEUqjnj8+QYEtk
         0ZhRagTNs3GZZFtijvTZXZnlJr/pbJG6fVN0Sdt6s5i9uWrPFYu0tN3Bm4eYhTTcpgXn
         D12cfxRvP5AU3qmV0+xL13gXhL70QdwWYg5fVk/pDEryo7MKRDYINUbUoBYnj1nQ7Ocd
         dH6YchXw91KgATWsXnaxjG4LItdfzBtVqokFW+hQ6PWVKFRyC5XvnV72UESUpb9cEj1b
         nPPg==
X-Gm-Message-State: APjAAAXkjd7JBwYjCcF79ovbHPUncmEVs2eqljTxvKlT4qF1u3KEREHl
        3HLDqUTWM0+23MJqPmCe7UWLtgy0igP818YorJE=
X-Google-Smtp-Source: APXvYqwAl5itey+1cl2Qc5HIwpG2Hb2FtZxUHqof4eFoy3a4ZFv2hhy2GLnJOIZKMv/z1GSaBVNeYUMd3ih7BRDaTxg=
X-Received: by 2002:a37:a685:: with SMTP id p127mr3233760qke.449.1580351848083;
 Wed, 29 Jan 2020 18:37:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1580348836.git.hex@fb.com> <065fa340d5f65648e908bc94b6bd63e57e976f35.1580348836.git.hex@fb.com>
In-Reply-To: <065fa340d5f65648e908bc94b6bd63e57e976f35.1580348836.git.hex@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Jan 2020 18:37:17 -0800
Message-ID: <CAEf4BzapaKj+CArhK+GooqcRsTTSoYkR0Vbh87inX8kMYDHeSw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/1] runqslower: fix Makefile
To:     Yulia Kartseva <hex@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 6:10 PM Yulia Kartseva <hex@fb.com> wrote:
>
> From: Julia Kartseva <hex@fb.com>
>
> Fix undefined reference linker errors when building runqslower with
> gcc 7.4.0 on Ubuntu 18.04.
> The issue is with misplaced -lelf, -lz options in Makefile:
> $(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
>
> -lelf, -lz options should follow the list of target dependencies:
> $(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
> or after substitution
> cc -g -Wall runqslower.o libbpf.a -lelf -lz -o runqslower
>
> The current order of gcc params causes failure in libelf symbols resolution,
> e.g. undefined reference to `elf_memory'
> ---

Thanks for fixing!

Just for the future, there is no need to create a cover letter for a
single patch.

Please also add Fixes tag like so:

Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")

>  tools/bpf/runqslower/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index 0c021352b..87eae5be9 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -41,7 +41,7 @@ clean:
>
>  $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
>         $(call msg,BINARY,$@)
> -       $(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
> +       $(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
>
>  $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h             \
>                         $(OUTPUT)/runqslower.bpf.o
> --
> 2.17.1
>
