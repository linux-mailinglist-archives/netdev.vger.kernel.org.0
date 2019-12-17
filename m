Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3EE123896
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfLQVVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:21:45 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52052 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfLQVVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:21:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id d73so4378877wmd.1;
        Tue, 17 Dec 2019 13:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hgMHC/0V3btfO+qH7JqlsOIYRMjWu+rklj4/8QVHltU=;
        b=T3UTqYK32/g2yjuAY0Vs7zcaAYGyvNn1N94YMvd+e2rdEfD+Vi8TYYy/kZZ+IFu7xH
         B9u1xEm2thINxT2dBSsuLKzY7PgaQJav+WLqUbE91Tndw5u4iULhUPAo42eAdqXpFNx7
         4JtcowWDMWsGFQQeGMANeTktmeRSOM48nC9a2YiRBT+TdwGU9FWn6Ese42cnMYBH7fzM
         DO1dt5fdh5DimcAV6F297wjlYXZLGOPD1maaR8ZsB300fuxVmzGUaoSFuuKBiHyaogko
         E9PEKQt6fr/iqHUwqJhc704fYD3AwIQL9OVh8wq9xnahISkyo0DHg1zLdX9IKzCMegoA
         inYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hgMHC/0V3btfO+qH7JqlsOIYRMjWu+rklj4/8QVHltU=;
        b=UEmjtg1YgqyijnT4R8DW/mmqaM3UjT9gBomKzVAw56IyG1lndBedL7bmWCSj+Pb6jB
         JD6Fka76ZTLRYZKwAfu/Pq3B8/4b20liPO3bs31+v115/tBZrdf2bptNiQKR2668ZPmk
         sjdJ6duhsFG6kGXA3MCwIoPxURssSWnvYswXsc++4coUjJy37XMiWp6aGSyYaIetdZil
         eA52bN4uO0R7N/b9aTicok/vnKXVWrvjNaVQhxKyEMjZ6iX5gBZRne/6cRAAi7MHgMEv
         KNEdZcgISZ5dspSavzQqtK0OJuXInd3ingUOX1vzFWOGCmqW3BFQA60nEQG++Jbz3Z/w
         Qtrw==
X-Gm-Message-State: APjAAAXxg9EeMIa0Mxsaiyahw3h6tuTNG68YP1A+qQLwR65GbQwbSsj6
        FHdN/BEhX/JX3yVQaimTcPNfvkcE57xtSkVGXy4=
X-Google-Smtp-Source: APXvYqzHJEOvzCi5iHCDt/XgQC/7D97th0ovINqRNJRi6Er8pQXxEZNf/3tSoTW4TxEydYumfklAECyhyJAYl9F9iHg=
X-Received: by 2002:a1c:7508:: with SMTP id o8mr7597010wmc.74.1576617702146;
 Tue, 17 Dec 2019 13:21:42 -0800 (PST)
MIME-Version: 1.0
References: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
In-Reply-To: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
From:   Andrey Zhizhikin <andrey.z@gmail.com>
Date:   Tue, 17 Dec 2019 22:21:30 +0100
Message-ID: <CAHtQpK7Rs9_8aUmGXv8Cud=U0muMwV6s14O8do7UhdGHZ9ukOg@mail.gmail.com>
Subject: Re: [PATCH] tools lib api fs: fix gcc9 compilation error
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sergey.senozhatsky@gmail.com, pmladek@suse.com,
        wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I'd like to have a gentle ping on this patch, if someone could review
and apply it - I'd really appreciate it.

On Wed, Dec 11, 2019 at 9:01 AM Andrey Zhizhikin <andrey.z@gmail.com> wrote:
>
> GCC9 introduced string hardening mechanisms, which exhibits the error
> during fs api compilation:
>
> error: '__builtin_strncpy' specified bound 4096 equals destination size
> [-Werror=stringop-truncation]
>
> This comes when the length of copy passed to strncpy is is equal to
> destination size, which could potentially lead to buffer overflow.
>
> There is a need to mitigate this potential issue by limiting the size of
> destination by 1 and explicitly terminate the destination with NULL.
>
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/api/fs/fs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
> index 11b3885e833e..027b18f7ed8c 100644
> --- a/tools/lib/api/fs/fs.c
> +++ b/tools/lib/api/fs/fs.c
> @@ -210,6 +210,7 @@ static bool fs__env_override(struct fs *fs)
>         size_t name_len = strlen(fs->name);
>         /* name + "_PATH" + '\0' */
>         char upper_name[name_len + 5 + 1];
> +
>         memcpy(upper_name, fs->name, name_len);
>         mem_toupper(upper_name, name_len);
>         strcpy(&upper_name[name_len], "_PATH");
> @@ -219,7 +220,8 @@ static bool fs__env_override(struct fs *fs)
>                 return false;
>
>         fs->found = true;
> -       strncpy(fs->path, override_path, sizeof(fs->path));
> +       strncpy(fs->path, override_path, sizeof(fs->path) - 1);
> +       fs->path[sizeof(fs->path) - 1] = '\0';
>         return true;
>  }
>
> --
> 2.17.1
>


-- 
Regards,
Andrey.
