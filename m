Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3906121776B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgGGTAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgGGTAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:00:52 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22421C061755;
        Tue,  7 Jul 2020 12:00:52 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b4so39135916qkn.11;
        Tue, 07 Jul 2020 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7yu+o4nu3mk3bz7GzIH2VG8WTXHkxwv9jvval3NBP68=;
        b=BqxsGry1JyTCCIO/ub9wX6X8OTkAWmZz2skN09YHaUij3p7WmS+NiRo7N0vGbNZDbK
         8WO2lPYfLn/nPSuHEwYby3v32SEB8szpXXkclvc8zz34/3/euSteNzgHSxNFGIF+E0wv
         DgC4TPd3u9tnz6zQNbiG8wVYUOGvTs6FGXpBONf6qR6rT19VkCZoP0m/3ienx6u3s9vc
         0x4/+/j/9ssciuxT+dI0536VLGot70o9ZPPyCvjcLHcaIE9xYkAglX1R2sIFqlnqOQNd
         CkqZk8dqsqV3qVOWYEpAEvFTEdnzVA3UXwJu7axufwHbBppIeBfykgfL714yurhJfaRn
         Ad8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7yu+o4nu3mk3bz7GzIH2VG8WTXHkxwv9jvval3NBP68=;
        b=uLjgnBRZuLkmhw14uKS153OqiV11h68NyNnVBdWiQl1IMZbS/66Z2ZD1lO57UQMonL
         Z0lnQsI786lYcJTEddFXtI5+P6gNYJDXkV75dn0ns9NjXaT8HRLSN53JQXsgdhDET76T
         Dba97+iofZM1qVkOx0VdwWLRt856ioMcwwZgJV1Dq0la5VlGNUDA0UVce4ADDKp4YUYU
         tZ7JWO+/Y1qZc7qiXSdayztlohfNVoh/s5AUyI11CNapNxBjSnUnWGJpBdKrkY3AUsAK
         5anhOcL6lWzn70yuyodGdLtYI8xLoEJa1zpjahmTgqyWOhthwGyWCl/tLhWM8RUBd2jG
         FS+w==
X-Gm-Message-State: AOAM531YuUx6rtUx0ZFlD8AjG279pXZWfqJihuVkBfzre0lYkeREZbu2
        XzaKd1/zekEQJNWEFWNyg58nGBTaWAiGZ9jp4YonZmSMmDA=
X-Google-Smtp-Source: ABdhPJz/mxc0/EX4WUMplgFe03e6k8BgsSWxFucnW5UfeMpIyW5oi982I0TAZvH+LlNeX660cpSbvhUefMo4O6tO+bI=
X-Received: by 2002:a37:270e:: with SMTP id n14mr51469744qkn.92.1594148451375;
 Tue, 07 Jul 2020 12:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200707184855.30968-1-danieltimlee@gmail.com> <20200707184855.30968-5-danieltimlee@gmail.com>
In-Reply-To: <20200707184855.30968-5-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 12:00:40 -0700
Message-ID: <CAEf4Bzb5QKJcbTd+etoERgfzrNW47VxxC3Z=p_+OJrJMmYz4XQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] selftests: bpf: remove unused
 bpf_map_def_legacy struct
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 11:49 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> samples/bpf no longer use bpf_map_def_legacy and instead use the
> libbpf's bpf_map_def or new BTF-defined MAP format. This commit removes
> unused bpf_map_def_legacy struct from selftests/bpf/bpf_legacy.h.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Next time please don't forget to keep Ack's you've received on
previous revision.

>  tools/testing/selftests/bpf/bpf_legacy.h | 14 --------------
>  1 file changed, 14 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_legacy.h b/tools/testing/selftests/bpf/bpf_legacy.h
> index 6f8988738bc1..719ab56cdb5d 100644
> --- a/tools/testing/selftests/bpf/bpf_legacy.h
> +++ b/tools/testing/selftests/bpf/bpf_legacy.h
> @@ -2,20 +2,6 @@
>  #ifndef __BPF_LEGACY__
>  #define __BPF_LEGACY__
>
> -/*
> - * legacy bpf_map_def with extra fields supported only by bpf_load(), do not
> - * use outside of samples/bpf
> - */
> -struct bpf_map_def_legacy {
> -       unsigned int type;
> -       unsigned int key_size;
> -       unsigned int value_size;
> -       unsigned int max_entries;
> -       unsigned int map_flags;
> -       unsigned int inner_map_idx;
> -       unsigned int numa_node;
> -};
> -
>  #define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)         \
>         struct ____btf_map_##name {                             \
>                 type_key key;                                   \
> --
> 2.25.1
>
