Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1D7EBCD
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 07:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732547AbfHBFHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 01:07:22 -0400
Received: from mail-yw1-f48.google.com ([209.85.161.48]:44564 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732470AbfHBFHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 01:07:22 -0400
Received: by mail-yw1-f48.google.com with SMTP id l79so26879521ywe.11
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 22:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYe/V4BPVEo1PefN4QYb6jXr9yPHjdiwiquVbvyv190=;
        b=BBwxsTLdUe7g6PGAhxTVYT37IXCpumqf4+f3553NhVbJCrcUgO3uxjYNsoqQs7mJmv
         GIBQXoRH3HCHmL9VPEeACvfos1W59t8uAsjPTvmFbjDIk6WXsT/lsMvhag+4RbJub4ST
         jRX5q4qEv1jtNpilICcpH75pi9ypdOZ1cUzgqyKLcLw9JzbrpD1VLKRuyKyDxULvJUPP
         D1zsTxUAteWTb+yzkHfMa5tXoch2LEb90b5lMLt7/Xdih7FKPbaRiwQVUPjlefTPhVbW
         MLl6wI5XTKlX1r2ak6TXlVPkTpoMPuzq+nvGX4C9A6jzKGGxwCteSfS1QcbxG1KDV9iZ
         CNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYe/V4BPVEo1PefN4QYb6jXr9yPHjdiwiquVbvyv190=;
        b=IMpTM3OaIH1X8Sj9wGN+WkjAMMCkJRGmct0gOzWQhLvJ6oecKxkFtiIsLdWA6xAJTO
         rhm54bLlMbhyrNm3dfBvgPA/+u6TrG3i2+F1sKeeViL5J+XMBlAYjWepp9IKQ4nutSJJ
         bfDIC2tb7oV96fcLlJNB/jv4hKd2YhW+pC7wstQuR6kZQ7S0PQIQGQhj9K+akvJhihsw
         GdE7vFtPKX6/6iJXVPxfa+jLABEFaQqPdcTalb1qMqGgVlWeXGWfoaTp0FqAQNfsKczR
         Wi2v+RPS6kDK4EW/JkkyJKu9URyxSyL73hI7VFdvaD0FdU4fuzeH8j4g8pdhjmdADWDr
         Znrw==
X-Gm-Message-State: APjAAAVTGubdY87HQW8gOJbJ5GDUcrQwfuaUz3VUUGhKVIkFfidfDD3y
        ZFLc+8GdAewLEV/jWrzwJEkWe0uNFx5NVUY0eg==
X-Google-Smtp-Source: APXvYqwKMC/HGrdfYUK1GbUTcDXBxsTXIt8h8Y96VBHD+tafRS5+PCcwNInunKnKZhKbFToNNGEjrNU9KuEVsKuwA0c=
X-Received: by 2002:a0d:e6c6:: with SMTP id p189mr76927424ywe.69.1564722441343;
 Thu, 01 Aug 2019 22:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com> <20190801162129.0a775fde@cakuba.netronome.com>
In-Reply-To: <20190801162129.0a775fde@cakuba.netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 2 Aug 2019 14:07:10 +0900
Message-ID: <CAEKGpzgeXtFEwVXtg7B4Q=dzFUJ5KECZmCdsN=Ka1uYHTOEVpg@mail.gmail.com>
Subject: Re: [v2,0/2] tools: bpftool: add net attach/detach command to attach
 XDP prog
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for letting me know.
I will add to next version of patch.

And, thank you for the detailed review. :)

On Fri, Aug 2, 2019 at 8:21 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu,  1 Aug 2019 17:11:31 +0900, Daniel T. Lee wrote:
> > Currently, bpftool net only supports dumping progs attached on the
> > interface. To attach XDP prog on interface, user must use other tool
> > (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> > can attach/detach XDP prog on interface.
> >
> >     $ ./bpftool prog
> >     ...
> >     208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
> >       loaded_at 2019-07-28T18:03:11+0900  uid 0
> >     ...
> >     $ ./bpftool net attach id 208 xdpdrv enp6s0np1
> >     $ ./bpftool net
> >     xdp:
> >     enp6s0np1(5) driver id 208
> >     ...
> >     $ ./bpftool net detach xdpdrv enp6s0np1
> >     $ ./bpftool net
> >     xdp:
> >     ...
> >
> > While this patch only contains support for XDP, through `net
> > attach/detach`, bpftool can further support other prog attach types.
> >
> > XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.
>
> Please provide documentation for man pages, and bash completions.
