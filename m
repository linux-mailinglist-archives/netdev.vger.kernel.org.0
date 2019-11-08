Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE03F5770
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfKHTVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:21:45 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43990 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732277AbfKHTVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:21:42 -0500
Received: by mail-qt1-f195.google.com with SMTP id l24so7663635qtp.10;
        Fri, 08 Nov 2019 11:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ra8yemMZeXDVMotWUu1vzgR1BP5lkdIOuqLFfjRb37k=;
        b=cWd6EY308WFAJb4j1HGeeWvbagaFNkVVwEC30xUwVwGXj7g5cvy6NyDotPqKtoX9+C
         0pLjrqCiHUxCARu84EfTwhbBgtCdAIlzcwbhhT84c/D5P6li1kXwcUgI97Ed57uE2kVn
         t7MLG2q82YOQVWfxg98dL6OSojgGYT0L+AhZ0PXI4bzcrLN+RG8y4vLVLQYVW5BW5o61
         tAsNnsjNQWNFKdG+A5/iEz3U9NjbUMKZQ/Y+9L5uiCmt5BfTDTzawfdOZslBRUNwTjSm
         WMfTdMMsJxUYLNM2rgXju4J8NUUHOn+poPmZguyJy0NqyDP8PTCdHZgIAzKj/WnPmDzw
         mq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ra8yemMZeXDVMotWUu1vzgR1BP5lkdIOuqLFfjRb37k=;
        b=lbl1zf2UwZfrGAXxZm9kW7fkAszIRI45R0eed8JFakFmBHXbnN4s1pxkQB5I7IfA1k
         xmcfmTtDmljoDRqKd2BEgb9ZvV4jjoA6PfoHewFsaMmayz2f8NOrQxV0phRMaug16KRP
         EFE5pTAnN4K+ISx8r0A4VEYOh8J+WgqRJ/HSskIYIfyWRR87+FdWCeBp4aWgFYqYgAz6
         07KoNKxyer9U2YPooUBEgq3omcI9JIpFC8egVD0WBlbW+l/Acns2GFvo0zgeL5v61wPN
         srAbAkWQFjwuMzq4In0WRQYd715Ar8mZTk9s0wi4hwNUHixihbDKHQcgLN91o9aU/wx5
         AZ7Q==
X-Gm-Message-State: APjAAAW0hOshUo0RWGhRbviZQECH6CYZ0WGBXpnvwGPQi9Qqm0HMf+HT
        oEmDUJe+QoePGGTnxsciLgELM/zOjwytZ0KfwoU=
X-Google-Smtp-Source: APXvYqz51fG+VzsO8hGFUkCd661Ol4AWF4F4OISgP2ig/MM7szWKEQpWFypTNI6OMUijXBhjmU7JudMq1gYe2X0nihk=
X-Received: by 2002:ac8:7116:: with SMTP id z22mr12339900qto.117.1573240901345;
 Fri, 08 Nov 2019 11:21:41 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-5-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-5-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 11:21:30 -0800
Message-ID: <CAEf4BzY0=KSEdG2vp2X9ZSKE1h7XNyHLFhdJQg2_iF5h=FxDeQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 04/18] libbpf: Introduce btf__find_by_name_kind()
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
> Introduce btf__find_by_name_kind() helper to search BTF by name and kind, since
> name alone can be ambiguous.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Ok, makes sense.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/btf.c      | 22 ++++++++++++++++++++++
>  tools/lib/bpf/btf.h      |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 25 insertions(+)

[...]
