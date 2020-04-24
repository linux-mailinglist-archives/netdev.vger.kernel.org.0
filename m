Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB78F1B7AD0
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgDXPyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgDXPyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:54:16 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBBBC09B049;
        Fri, 24 Apr 2020 08:54:14 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id c23so7728031qtp.11;
        Fri, 24 Apr 2020 08:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wZRbj+K598+LyRdLC0CM7Aq/H7jAh16JCjCZaCv/nK0=;
        b=Pp7Ad6UrEQZbE42PsHxEmjJHfdLLc5zsp3AABdTWFz+C3qzflJWb+OiSt/agfuaipz
         uYRCFbDW6HpVKdicCXs88dcHmFVVmIeG/jQMcexrdmlUrBqCfgYY1eQL/U5tKUMnfciu
         iRj7ojnGC/HpazJD3S4sApDbYwy5OmU20xWrrsvjg7Y+o4Jgh3oL6QltXD9Qk7xqepXx
         +OYA85/Crk4v1JhbfcXIa0E0yjl2yzTJcRYCVXOsWr9bqygSIZonEe+WVLkG+YSWWQh/
         Wae3hqHoBuprhVVWSMdSZkTDn1ldYiWrzpCJuqFBhU5CxwLSTZ/Jd5voMb5kEqrlzMoS
         3oVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wZRbj+K598+LyRdLC0CM7Aq/H7jAh16JCjCZaCv/nK0=;
        b=bJSdzkaz76a++9bMrbaDSnsrF92pJZYi5DpPy8tgWseOdWP8IXakqSDsKcH4+lHmAX
         pDEaXxj/6wOW95fuqaolf2muW4szWtmEw/iCTj4iLseWXgx8x87QVqfkZlv329nJ9Oy1
         0ZCI78qZKkG1wMgvbC0oecPPxwAgvZ2lFORs/V4dO9NQutpXGTj6PLvF6nTPclch3vNB
         W7nTz+uvVRhojv2rFut9/85J1ZkxwsvkSEcdTBqi4qGK1hZVDx1mvyaqpX7y1McUIN5y
         81my/AF97arHZO6w4jzOHoKrpeQ7be1U2YnflXoGB1YK7oML5UVsCBWyf6Bk589zeUMJ
         Xbwg==
X-Gm-Message-State: AGi0Puaj50nfLOPbNhIg5kkWYT9E9M4pyuJnqZEU8KE/YijCFXMw9q0S
        S1q+YNdb3y/sQn9zyNMObhxMW4Wo4Z5SZTCcAC4=
X-Google-Smtp-Source: APiQypKAj+2CKopa9OuWA6WEdqFk2FFR/LHy9j3hjiMGwe2miHb5HyF0Jz8RRp8Ga2O99rODNkaD6sH+8O8Rwq0eRPY=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr10151415qtd.117.1587743653960;
 Fri, 24 Apr 2020 08:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200424053505.4111226-1-andriin@fb.com> <87sggt3ye7.fsf@toke.dk>
In-Reply-To: <87sggt3ye7.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 08:54:02 -0700
Message-ID: <CAEf4BzYFj_DcTkc6+cQ8_uoxw0Aw4f9E-YhFJpY4Ak+B8=Y1Sg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/10] bpf_link observability APIs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 4:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > This patch series adds various observability APIs to bpf_link:
> >   - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by whic=
h
> >     user-space can iterate over all existing bpf_links and create limit=
ed FD
> >     from ID;
> >   - allows to get extra object information with bpf_link general and
> >     type-specific information;
> >   - implements `bpf link show` command which lists all active bpf_links=
 in the
> >     system;
> >   - implements `bpf link pin` allowing to pin bpf_link by ID or from ot=
her
> >     pinned path.
> >
> > rfc->v1:
> >   - dropped read-only bpf_links (Alexei);
>
> Just to make sure I understand this right: With this change, the
> GET_FD_BY_ID operation will always return a r/w bpf_link fd that can
> subsequently be used to detach the link? And you're doing the 'access
> limiting' by just requiring CAP_SYS_ADMIN for the whole thing. Right? :)

Right.

>
> -Toke
>
