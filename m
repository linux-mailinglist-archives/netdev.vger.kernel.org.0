Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A4A2075B7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391214AbgFXOaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389874AbgFXOaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:30:01 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519F5C061573;
        Wed, 24 Jun 2020 07:30:01 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so2789882ljv.5;
        Wed, 24 Jun 2020 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=68guwqF87DhAmMD3DmT2p3DlsWU3rO2GWVrnapunJoE=;
        b=qEiEsHhD1rwKKS8msFCQa3kszJ2dmI4/pPxAJaFX7sox/ROuSdEIXPRvgsNVC8F8YE
         tPgBt/oPR0vsz2HNxeGBNbz6u4WYLi1lTyv6PC93FDjVRGhb+e7ZNjNFWJ5JYUQAoqYa
         d5i4sdzJsclycBVugC7gv7uYF1ieUvlVi2GuwgRu7En91aGQKZqRsbC6YvcrAEh/uXzX
         3SxBbWpgLxoyDaXR9IfguI/v2wl0Ei+yXi14uja0I7JKxyVJfgoJAsJpYMkW6BJgfbZW
         4ius6W1lw22r8TxVNHj6rpb4yTHT4KY7zzPEohG18Cak0jEDk+d2WEJ1vb0HB5c5h+lE
         BGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=68guwqF87DhAmMD3DmT2p3DlsWU3rO2GWVrnapunJoE=;
        b=CW+uQrs11rpolv5pLhOmuVoe+VR9tg0Z1l2kRlmOHzPNBy31K/wY+jzTw+RElmTjgL
         sudL7M3n6aBRfIVbX45Ttwkq9sq1MSrrDi64PMHP/YCE62XkzhGLxAdn67TYpPOAc5HE
         dESQe30pWJNacEyEAkYtgYRIdf+DZIRz/eMTCP+ggacVKIweYsq5XU8PNc0dmYZgl4iv
         XthgxoEhOweGbmIvvNtaSu+hx6DWCdrpksypc9wMWWj8Hcoqt0AFousNI8hFxTJpk9rD
         59vGdx/PsQExhamow/pGI3Wg5zU7YGl1TcNC6BcJMoMa+J43Qroq9yompyWCVyMunlHe
         JONQ==
X-Gm-Message-State: AOAM533/GeHAJ9L+dAIK0tiIt8hmGEMzvY9wMMuAP7S6BT62vtjXD5kj
        ZchrYsPsoARt89wT7rxq3nQ1F3J5YtMfF2ZVmug=
X-Google-Smtp-Source: ABdhPJyrH50KE+i5/GIq6NiqwwmBBO8txSNxiltfOXyko0X9HnuPJDcwJ0rql2dGefQP3lVl45ucLxpM67SwZ4/VJwM=
X-Received: by 2002:a2e:b1d4:: with SMTP id e20mr13461758lja.290.1593008999841;
 Wed, 24 Jun 2020 07:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592947694.git.lorenzo@kernel.org> <372755fa10bdbe9b5db4e207db6b0829e18513fe.1592947694.git.lorenzo@kernel.org>
 <CAEf4BzbiZLtr8Vhwef=Zjd_=OVqKBozyg76Djae7qw3rgd7q8g@mail.gmail.com> <20200624103609.69ccdff9@carbon>
In-Reply-To: <20200624103609.69ccdff9@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Jun 2020 07:29:48 -0700
Message-ID: <CAADnVQ+tiHo1y12ae4EREtBiU=AKUW7upMV4Pfa8Yc7mrAsqEg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 7/9] libbpf: add SEC name for xdp programs
 attached to CPUMAP
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 1:36 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 23 Jun 2020 22:49:02 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Tue, Jun 23, 2020 at 2:40 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > As for DEVMAP, support SEC("xdp_cpumap*") as a short cut for loading
>                                 ^^^^^^^^^^^
>
> Maybe update desc to include the "/" ?

+1

>
> > > the program with type BPF_PROG_TYPE_XDP and expected attach type
> > > BPF_XDP_CPUMAP.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> >
> > Thanks!
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> I like this extra "/".
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> If we agree, I hope we can also adjust this for devmap in bpf-tree ?

Yes. Please.
It's not in an official release. There is time to adjust things.
