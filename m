Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410465B57B9
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 12:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiILKBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 06:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiILKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 06:01:47 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A09224944;
        Mon, 12 Sep 2022 03:01:45 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s206so7804535pgs.3;
        Mon, 12 Sep 2022 03:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CWfgxJfu1axEfBQtY3XxBDCWMEz1AigX+bc5DbK4j0s=;
        b=V7PmRKQ41adCaoYLY4ooNSFJtsz1X8mVxz7vgkmeUeWtt5TIE0p0aYmXGFysRiFyya
         achXGXV+JmHHsw1HJi/ntUX5hGLJIk6cNo4t8pTL3JXaeycvS+c8H7UaN+XQKiRoVtUY
         LE8oSqwZIept6lI0zqMrVrayoyWMRV8RxfMDipIArP5iwd6nOuhM3qoqmlUlkSKh4LYQ
         HRGldjKumxhlCp3CnLNJigW1UcWzmJj3j9iigZHsUwCuP9dHLxKKbKG+GYeG7ms7oN0k
         1kjPHUtbzXTeXYZ6hhG6meRMWH43W7hkNTvOrU8p6iVtQ9VG7EiHCxSEOPZnocYHsKhH
         AnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CWfgxJfu1axEfBQtY3XxBDCWMEz1AigX+bc5DbK4j0s=;
        b=HzzzQqSHakK2x7QToQGzo0NZJsUYGcFZfdDGftt/CYbqtPg/KCKbOkn42qdMDDR84Z
         pZOYAAADJ14TtsbHDzZq3kei4jzQjOj2RcSdgDyMRBxgkn3W34rvN0dKBiuhauLdjxjN
         fK17bstqYncYCNy4k+j6/aNdfK9nQxc7LEVl8fiF1tDiCF5guLss0QTxashTiAuilPs7
         AbJNF4nY+KLs3xZwwYvPn5784uQYseWyh4BFJs37TLyrvWfzRkPh4RAwqqdWIEE6IIYN
         CthDgp2+jc7y1Pt6NnVP1VQ9wqa2gfw2RiPrkfkZgd42eQYOeUC1OjmoqcGaV9jlVRJ9
         uRcQ==
X-Gm-Message-State: ACgBeo3ZZzhhh4Bc87H+/n4IGKfrwE01vyX8NgN09qxHfTaDZFfyvQ2B
        RWAMM3C0nHcmCrWjQsy7BD4kQtyP5vhCmCeSB8A8Nh8FHK42wA==
X-Google-Smtp-Source: AA6agR6ysjHKpwAF2iATJ/BXB1cY5GI62WYWDtJUN56eWdKENwzV0jBNJ/EkUQLu4NqO9r9+dJKjPm0N7IAwYVt4nuo=
X-Received: by 2002:a63:4e0d:0:b0:430:3d93:a6f8 with SMTP id
 c13-20020a634e0d000000b004303d93a6f8mr23437648pgb.212.1662976904801; Mon, 12
 Sep 2022 03:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
 <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
 <CABG=zsCQBVga6Tjcc-Y1x0U=0xAjYHH_j8ncFJPOG2XvxSP2UQ@mail.gmail.com>
 <CAP01T76ry6etJ2Zi02a2+ZtGJxrc=rky5gMqFE7on_fuOe8A8A@mail.gmail.com> <077d56ef-30cb-2d19-6f57-a92fd886b5f2@linux.dev>
In-Reply-To: <077d56ef-30cb-2d19-6f57-a92fd886b5f2@linux.dev>
From:   Aditi Ghag <aditivghag@gmail.com>
Date:   Mon, 12 Sep 2022 11:01:33 +0100
Message-ID: <CABG=zsAE50K1-W8oo9s8rfbG2NF_ktkJ-JgC3xGgeZNOuKE+dw@mail.gmail.com>
Subject: Re: [RFC] Socket termination for policy enforcement and load-balancing
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 3:26 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/4/22 2:24 PM, Kumar Kartikeya Dwivedi wrote:
> > On Sun, 4 Sept 2022 at 20:55, Aditi Ghag <aditivghag@gmail.com> wrote:
> >>
> >> On Wed, Aug 31, 2022 at 4:02 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >>>
> >>> On Wed, Aug 31, 2022 at 09:37:41AM -0700, Aditi Ghag wrote:
>>>> [...]
> >>
> >> On a similar note, are there better ways as alternatives to the
> >> sockets iterator approach.
> >> Since we have BPF programs executed on cgroup BPF hooks (e.g.,
> >> connect), we already know what client
> >> sockets are connected to a backend. Can we somehow store these socket
> >> pointers in a regular BPF map, and
> >> when a backend is deleted, use a regular map iterator to invoke
> >> sock_destroy() for these sockets? Does anyone have
> >> experience using the "typed pointer support in BPF maps" APIs [0]?
> >
> > I am not very familiar with how socket lifetime is managed, it may not
> > be possible in case lifetime is managed by RCU only,
> > or due to other limitations.
> > Martin will probably be able to comment more on that.
> sk is the usual refcnt+rcu_reader pattern.  afaik, the use case here is
> the sk should be removed from the map when there is a tcp_close() or
> udp_lib_close().  There is sock_map and sock_hash to store sk as the
> map-value.  iirc the sk will be automatically removed from the map
> during tcp_close() and udp_lib_close().  The sock_map and sock_hash have
> bpf iterator also.  Meaning a bpf-iter-prog can iterate the sock_map and
> sock_hash and then do abort on each sk, so it looks like most of the
> pieces are in place.
>

Yes, I did consider using a sock_hash type map. But for some reason I
thought it would be
accessible only from bpf_prog_type_sk_skb or sockops. Looks like the
regular map helpers
can be used for update/lookup operations on sock_hash map type. It's
great to know that sock
ref counting in sock map/hash types are automatically accounted for,
so we don't have to add
additional INET sock_release hooks.
