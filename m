Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9B131A5A1
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBLTtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBLTth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:49:37 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B2EC061574;
        Fri, 12 Feb 2021 11:48:57 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f4so549100ybk.11;
        Fri, 12 Feb 2021 11:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3EqKnqrU/i6v/GDs28Mbmk0UZvSParAnnToFTrhknXs=;
        b=BgH/1x4lwQnf0O41USw4Be60GySMKUa4KoRGPGxqD2EKTlLT91KLSOgAq6nH4/sUKV
         dzGTT4n5ziGmZgESJHBYOgKGLNvL0fcu2Fat1uB821IaQfOTeyNn6aRusHqJ+PnX1C5k
         64EL8tYAsRm3gxMkOxQrvtnUwX2MNi55m9rhxROhm2c0kwM5jR4gprSw+MN01MGDRBPz
         n3qyJGbl+SLrYGuONL6DACMfUcttua4h0QfP4vHQ3+Vi0Dp22UL0liYJaGLAb0p9j5w/
         MU/ynzPDxmebtB2VCeQ8f19Ul25R479EObMSo7UVaEOwuxp6BIvfzADnS1Kl/RUBstt8
         5alw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3EqKnqrU/i6v/GDs28Mbmk0UZvSParAnnToFTrhknXs=;
        b=IXo4WcMAAkhDW6DRd2Ek8PxHE/8B8iRTT0HmQAa+ioS+qBKu6t4ZSR4FIeVtMBs9YJ
         jt4oLVu2VNnoCCwpdjPZdN2mPM37dgMCrg8kCVn7vrUzQ3gEvShhrZSpaZW7yEs2Tfy3
         ymDCheXLZBwgY9nN+GluKjXCfKRgg9hHBKWUqUmtf9YgEl0koI5ruLtGcI8IDZzGho7Y
         T70zc2g7x/VBCB44eOmES8TkRu3G1JsDD2pbZrwu+ICVzJs4ZD/bsEVOeC6+l4KvLYuZ
         vholjHN2lDCCSmCWhFjUz3maJK6e0YI8Xakkqdd69wS3TGkn1In0udPWQ/HGf7hvdN3F
         56vw==
X-Gm-Message-State: AOAM532P2fatyU8HDE4taWmnzSxJzsVLZXP3zKmV461AMGmGoF8Gx53s
        EbKKdbW2sqoNF5YyLBGlFN/ViI2n544P8OV9yy4=
X-Google-Smtp-Source: ABdhPJzkdS1rMTxV+y5XhjxG8xTJ4BNXysyH03peCWmMTT8/gb2Au4KTKSXskIy6FUySWR6pPIeeV5r3pf98PF79f2A=
X-Received: by 2002:a25:9882:: with SMTP id l2mr5836218ybo.425.1613159336975;
 Fri, 12 Feb 2021 11:48:56 -0800 (PST)
MIME-Version: 1.0
References: <20210212010053.668700-1-sdf@google.com>
In-Reply-To: <20210212010053.668700-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Feb 2021 11:48:46 -0800
Message-ID: <CAEf4BzZ60LNPpWL6z566hCCF1JkJC=-nZpqg7JQGaHp0rJYGhg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: add /libbpf to .gitignore
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 5:07 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> There is what I see after compiling the kernel:

typo: This?

>
>  # bpf-next...bpf-next/master
>  ?? tools/bpf/resolve_btfids/libbpf/
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Jiri,

Is this

Fixes: fc6b48f692f8 ("tools/resolve_btfids: Build libbpf and libsubcmd
in separate directories")

?

Do we need similar stuff for libsubcmd (what's that, btw?)

>  tools/bpf/resolve_btfids/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> index 25f308c933cc..16913fffc985 100644
> --- a/tools/bpf/resolve_btfids/.gitignore
> +++ b/tools/bpf/resolve_btfids/.gitignore
> @@ -1,2 +1,3 @@
>  /fixdep
>  /resolve_btfids
> +/libbpf/
> --
> 2.30.0.478.g8a0d178c01-goog
>
