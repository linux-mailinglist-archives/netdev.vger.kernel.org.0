Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C140643E2BE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJ1N6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhJ1N6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:58:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210F7C061570;
        Thu, 28 Oct 2021 06:56:12 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t7so6430296pgl.9;
        Thu, 28 Oct 2021 06:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0CoaWvjFm99cAI5DZScnzMyymg+2oS2Edb8RJJOrKrg=;
        b=FfbiC19K9I21fUzT8qV52oceVoKCpgsIw1JZRNxMLbVN8SXvIG2/mVXL29PpBOIShE
         4CJVJsdrlGJNC0RquDfU9/6UwB0z8vPjHB4AqX3YP1439RGykUe5Lcj9zUFiiQCXVmMP
         SE90JNF1zzKTHqeyHnQ6RsHlxQvIVGSqNPpTLApZKmKYu6CM3NIU3EUVTKGgz09jwb6l
         yRWQmC32O68CJnqwcDCWiibeahfTg1VYnzcKLbstevsRa8mwV1JIDu0DV7hSu+twdDD9
         rtBBLuWPWNuMpelOkBufaQSswvXHSHe7gQRne328zOwqak3Sc7AwFCdwgV+3Yyl9BwoR
         ZAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0CoaWvjFm99cAI5DZScnzMyymg+2oS2Edb8RJJOrKrg=;
        b=a19MlNFenJm2ACA6n0qw9LhFcavXqjTOb95KW5oGskiAbnwDwoVfl4i+/BgAT6dV6U
         GxVFswxWWP548I0koPXT/eS19Ifi2SNAszqR6Z5JdxAcWI4AMncIqhWoOi/TOlWFIS0y
         bJ0Pu7/+x7icLyEO2eK3h04hwXic96b5L2+NbnvXJ0Yn0f4hXcj+JjkqKL0mfEUEPUQV
         X5aN1Pff7YO490yJbJRiD2sJ2QEshS5RW0YOcPJwK4i5O3rUjVxNCi19BOwxF4zMciZl
         MHTuxJqdxN2cSgd/dVChuSc9rKMJDacg3iGGRoBHNJn/vari4k1+Zw+WVCnb0lBPhy7K
         8UQw==
X-Gm-Message-State: AOAM531I0JuDHwPrRWBS3XZV4i9SyNaG1E//r7D4ipizPXTnmSKD3o9o
        UDsjTfoLUvJuY9Q8oa95/9sdghtpV0dsyeolEa8=
X-Google-Smtp-Source: ABdhPJyfioFjLfVpRZppOC5/a3bwhIwPlQO8tRDLcDAxIg15YJunUs+U4xZ65qA0l+qhiQvcDcAD9FS0PMtAhNwR7QE=
X-Received: by 2002:a05:6a00:2390:b0:44d:bccd:7bc with SMTP id
 f16-20020a056a00239000b0044dbccd07bcmr4561800pfc.4.1635429371651; Thu, 28 Oct
 2021 06:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211028134003.27160-1-magnus.karlsson@gmail.com> <87tuh18dqk.fsf@toke.dk>
In-Reply-To: <87tuh18dqk.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 28 Oct 2021 15:56:00 +0200
Message-ID: <CAJ8uoz2KXvsRzfm9eih4bEwY5w-91fiBZvtdQ2ONYkDiU=xWFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: deprecate AF_XDP support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 3:45 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
>
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Deprecate AF_XDP support in libbpf ([0]). This has been moved to
> > libxdp as it is a better fit for that library. The AF_XDP support only
> > uses the public libbpf functions and can therefore just use libbpf as
> > a library from libxdp. The libxdp APIs are exactly the same so it
> > should just be linking with libxdp instead of libbpf for the AF_XDP
> > functionality. If not, please submit a bug report. Linking with both
> > libraries is supported but make sure you link in the correct order so
> > that the new functions in libxdp are used instead of the deprecated
> > ones in libbpf.
> >
> > Libxdp can be found at https://github.com/xdp-project/xdp-tools.
> >
> > [0] https://github.com/libbpf/libbpf/issues/270
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Seems you typoed 'libxdp' as 'libdxp' in the deprecation messages :)

Ouch! I will spin a v2 for that, but I will wait for others to comment
first in case there are more things to fix. Thanks for spotting it!

> Other than that, though:
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
