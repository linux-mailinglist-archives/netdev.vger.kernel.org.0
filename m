Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D913226F20
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 21:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgGTTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgGTTh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 15:37:58 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD306C061794;
        Mon, 20 Jul 2020 12:37:57 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id i80so10353198lfi.13;
        Mon, 20 Jul 2020 12:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sgXLRBaaylaS2C4gN9oP1CacUi+Zgix4Q9h2XdlkjFM=;
        b=hwmyKa+wbbaz8q4bfXfO3z7rvx/ZhG7p5eG3b3XDUqtluypwYw/9hoRDYN179aPigz
         zbXMm2BjYvvkeOcxBmxTg2wyVPd9LJSNO98x53xAU4Z0lG48Ajp6+lh4WQKmmJMBNbZG
         y9l3qh9B5Eva4UN5r7vkDHx/bm7dvAMVRu/BsHrzbsgvCKftYhwI4+XeW78YuhG+fRNn
         cWuF0d/ouBREyynZj68gZhQpDB5Ya5f/76uLcDEvQ4tcUiVNZ9JrBqqV1lGSixCOXSne
         OkOLZMiGybwrlS8J0nzWyVofXaJBbMk/W/rz84oGfK+sNOZkFdMQDzB2vclCoaXFQhJk
         RWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sgXLRBaaylaS2C4gN9oP1CacUi+Zgix4Q9h2XdlkjFM=;
        b=DgARxFC+5EDmZUnE5XtqnJYY3shlSe0yjwlYSDSHFDYk7FiJIeAwgO3hps9yJd5zID
         nQOPWJAT1NB4iYvZoIFgyt8IACMNAjDSLZ+9hRtkZWhZqvHmbkS6mer/pM6PhAt8f21+
         FZ17RDW6ihofiqmt13YPUH1WX7u03IM4ow6lCnoTG/wGqJslgenlviXCO6HZD7vCXJUh
         4lSOfEQKsnXBN1n466cG6/ZJWr/FHqeZpLcTF0CIqJ9Uiv23o8ktIYj8GVSOwJhaJY/s
         54zX/Ofpqi8pLjaarOfYxBvPVo3Szz6u5gjTR0AbsxTqZkC/oxfZkYyf7zvQQBTL3ZN9
         tTyw==
X-Gm-Message-State: AOAM532BxZz/5+XX/8kGFB9mVLpca3TkYcA2D5Q4iaafXoCy/0BMpuXu
        h2a60H1s4YXAEaXfXhHDqn/Z/6slx5JHr91rWWc=
X-Google-Smtp-Source: ABdhPJy1Jig5sDfVDdOSRyjt4VvlHQ9WhRxupA+W8Un21a1t7FbzrPXKASt/E5BtvMdxrDNU8FO+v8/2XARywqL/t1M=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr4307309lfs.8.1595273876184;
 Mon, 20 Jul 2020 12:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200720194225.17de9962@canb.auug.org.au> <a97220b2-9864-eb49-6e27-0ec5b7e5b977@infradead.org>
 <20200721044902.24ebe681@canb.auug.org.au>
In-Reply-To: <20200721044902.24ebe681@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Jul 2020 12:37:44 -0700
Message-ID: <CAADnVQJNU+tm3WT+JuPoY8TTHWXxQ8OJ0sGCLQGq2Avf+Ri7Yw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 20 (kernel/bpf/net_namespace)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:49 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> On Mon, 20 Jul 2020 08:51:54 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > on i386 or x86_64:
> >
> > # CONFIG_INET is not set
> > # CONFIG_NET_NS is not set
> >
> > ld: kernel/bpf/net_namespace.o: in function `bpf_netns_link_release':
> > net_namespace.c:(.text+0x32c): undefined reference to `bpf_sk_lookup_enabled'
> > ld: kernel/bpf/net_namespace.o: in function `netns_bpf_link_create':
> > net_namespace.c:(.text+0x8b7): undefined reference to `bpf_sk_lookup_enabled'
> > ld: kernel/bpf/net_namespace.o: in function `netns_bpf_pernet_pre_exit':
> > net_namespace.c:(.ref.text+0xa3): undefined reference to `bpf_sk_lookup_enabled'
>
> Caused by commit
>
>   1559b4aa1db4 ("inet: Run SK_LOOKUP BPF program on socket lookup")
>
> from the bpf-next tree.

Jakub, please take a look.
