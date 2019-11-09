Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D09CF5D2C
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 04:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfKID0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 22:26:39 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:38381 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfKID0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 22:26:38 -0500
Received: by mail-lj1-f173.google.com with SMTP id v8so8239492ljh.5;
        Fri, 08 Nov 2019 19:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6mWpHOx7d3RC93m4tPpgEfkg8hGRzXNMxcpawVMB0/U=;
        b=gyz/kW81uFp5O10kUeR0WLM/DkBFXyGdlMpBa+/SEnymxBe78dLg74Uf7a42oWb3ZB
         w3k3peXe3cUOtgeUG8i7A/2LU3RvgGjGgxHYzQcroTEyzwbif+71ueA2mNVj1wG0nDcE
         Xh8fpumZCEr/Lvt+vJBRSRAKQRuU378rLdU3CimTa59YSMkeQllamtDzMW79PpSD3ClX
         kNQJCUkg3+FJkSscFrXEMI3ERjLAjVizeO+dHA9mZAlfY8Q3NJqTgZEd7xr33CdxSeG2
         om+hRroMi6G53/tXXCYzBNYywMjgmxc/AM72bEEj8eUbtEG8RBN6R60OUL0nj1qWNVQM
         kB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6mWpHOx7d3RC93m4tPpgEfkg8hGRzXNMxcpawVMB0/U=;
        b=c6u2ekwNA+6XP7tTtCZ7IV230qDlwSVFe+GzIaKktsGOi/uvlpSr5XqFsRp4ZbLSWp
         b+9kK2tztplvaP85Ex19ONGTS9g9gnpz0lyvTLTGdWh5+oT3jQ8Ym0kHt5tKDMGzE0eG
         S9YNw9/12YWbRevmGeVJQQ3K02lE8Pek0n62XV2UVXXDSRnl1x7CtrPCWJQd9X072Hd2
         bhtWz6vo5Pujf0sAFbOKZkbCKXmf/S9KxrS49a4OIPmYTWdEkd7tWGggm08sj3H85FzF
         rFEU7My0xAkdTYXCmpUNGMMT+nOHDA6Gp3uk6xuXB4P9f/FGmt+xSrn6LF5YkD8ZrFzk
         OprQ==
X-Gm-Message-State: APjAAAXBYwAwuVZTcBErHXPozWRqNlSSG6g/Eztd1Z8dn6Z4gi7ZRE97
        TQNUm/30i1L8VCQ1/Sq7hz8q7s3EttdrFV8SSNw=
X-Google-Smtp-Source: APXvYqy8ps35ipYMBZMhRxqth0qghotkaQzYujvBcxNzMmvLQdMgFR4+1VJlVEaxMISJPKUAQO3L2fFFVkJ+VqVhyMU=
X-Received: by 2002:a2e:92c4:: with SMTP id k4mr8854685ljh.10.1573269996294;
 Fri, 08 Nov 2019 19:26:36 -0800 (PST)
MIME-Version: 1.0
References: <20191107005153.31541-1-danieltimlee@gmail.com>
 <20191107005153.31541-3-danieltimlee@gmail.com> <CAEf4BzZpBqPAKy1fKUQYSm3Wxez29EuBYqu_n2SayCfDt_ziUg@mail.gmail.com>
 <CAEKGpzi5qz14TWm4ZSmk8zWcw_z2f9iM+dW10Tu6evJg60aa_g@mail.gmail.com>
In-Reply-To: <CAEKGpzi5qz14TWm4ZSmk8zWcw_z2f9iM+dW10Tu6evJg60aa_g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 8 Nov 2019 19:26:24 -0800
Message-ID: <CAADnVQJp9RyWX9d9DKMgvC-kaYQiPv0ae0DMHJx4KENechoYeA@mail.gmail.com>
Subject: Re: [PATCH,bpf-next v2 2/2] samples: bpf: update map definition to
 new syntax BTF-defined map
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 8:45 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Thu, Nov 7, 2019 at 11:53 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Nov 6, 2019 at 4:52 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > Since, the new syntax of BTF-defined map has been introduced,
> > > the syntax for using maps under samples directory are mixed up.
> > > For example, some are already using the new syntax, and some are using
> > > existing syntax by calling them as 'legacy'.
> > >
> > > As stated at commit abd29c931459 ("libbpf: allow specifying map
> > > definitions using BTF"), the BTF-defined map has more compatablility
> > > with extending supported map definition features.
> > >
> > > The commit doesn't replace all of the map to new BTF-defined map,
> > > because some of the samples still use bpf_load instead of libbpf, which
> > > can't properly create BTF-defined map.
> > >
> > > This will only updates the samples which uses libbpf API for loading bpf
> > > program. (ex. bpf_prog_load_xattr)
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Applied. Thanks
