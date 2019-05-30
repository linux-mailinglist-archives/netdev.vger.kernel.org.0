Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5540630184
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfE3SIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:08:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36736 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfE3SIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:08:21 -0400
Received: by mail-qt1-f194.google.com with SMTP id u12so8120120qth.3;
        Thu, 30 May 2019 11:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uBh8frPBklj3PAGNxGo58zhsB+Wp0GYqDmO+TlNLHb4=;
        b=PSCQw9shmXX7hlCnO9U9xGXJV2sYFdQGNyCBdUuUa/l3mnlJFLBbC/R9dO8coJ7KQK
         uSkhT/QZjbHUNLMGnSrhfIS5EB7TBjkd3EKTwIQoL2jx4Y1HRJy+x2P0XyuKfJkLFiWr
         kOOH6Zgm9RaJolfR7n+wpeCNprzuof6A5pDd8vZaRIbHfcb3wplUb077cAEldMm0aKi4
         4y59CAYA05IALYlBFqgBO66SO9I00jxiXM9pJquIHViY1jPKULRBte6nn6Xdc1KGem17
         3b/gLWwXQhUzCOLE05Hs9c1smxrC65+il0n6WzjIYLvKjDacuYo0ZLBVMTh6UAzsnASS
         nzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBh8frPBklj3PAGNxGo58zhsB+Wp0GYqDmO+TlNLHb4=;
        b=trXg6ySMivBEqrxYjBdy8d2Y7UlizJryArPhLpPHjIO71PKEbORvg3S9rGrHGkPq+C
         QqFaDxtX3gP7Awtf6tCiLSDKIvAApoRsx/Z5lDCMzZhb0wxfVW9sZYaiKB941ttYFhnZ
         991gz3f3U32S+sqGmFvKvC8AbNd7B3/YLgEfTTgBa8y4duxmHugPAOJdKvsD58vj9e5s
         VtTPsqIk1BAwEdbgzaK+HB+6KvzQHJyE0h5ySKRRSevF37Ckm49hrByFPE44y5JnJxFT
         4eHloxEsXLWmG5HMb+4SIuscRWkwtfwwDjjKCRtxtS0AvSJaT5UdA8ht+YIsMJmVRxGG
         q20w==
X-Gm-Message-State: APjAAAW/Yl+wmHnNcuwmpAmpDgUzIIfBNu2/GXACPXijSR85k9ekN0eF
        zEqCFMTBCNrk608uI9ZSsn2NJ4amgBNlRGP2Am0=
X-Google-Smtp-Source: APXvYqztZ5XPqFPZILkHDxcksjVQdRXGu0rSKUzB3EbR+JMHWyoaPnoI/6/aw1RV2DhRDXRoLNXbUn6tY50Hei/EO5g=
X-Received: by 2002:ac8:2af4:: with SMTP id c49mr4598934qta.83.1559239700683;
 Thu, 30 May 2019 11:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559171394.git.mchehab+samsung@kernel.org> <f2f40f306acbd3d834746fe9acb607052e82a1ee.1559171394.git.mchehab+samsung@kernel.org>
In-Reply-To: <f2f40f306acbd3d834746fe9acb607052e82a1ee.1559171394.git.mchehab+samsung@kernel.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 11:08:08 -0700
Message-ID: <CAPhsuW7J-KWsWhODKLJu3H8VvZ7nZ+O0Prni4M-tCt_inko9zA@mail.gmail.com>
Subject: Re: [PATCH 08/22] docs: bpf: get rid of two warnings
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 4:25 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Documentation/bpf/btf.rst:154: WARNING: Unexpected indentation.
> Documentation/bpf/btf.rst:163: WARNING: Unexpected indentation.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  Documentation/bpf/btf.rst | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
> index 8820360d00da..4ae022d274ab 100644
> --- a/Documentation/bpf/btf.rst
> +++ b/Documentation/bpf/btf.rst
> @@ -151,6 +151,7 @@ for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
>
>  The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
>  for this int. For example, a bitfield struct member has:
> +
>   * btf member bit offset 100 from the start of the structure,
>   * btf member pointing to an int type,
>   * the int type has ``BTF_INT_OFFSET() = 2`` and ``BTF_INT_BITS() = 4``
> @@ -160,6 +161,7 @@ from bits ``100 + 2 = 102``.
>
>  Alternatively, the bitfield struct member can be the following to access the
>  same bits as the above:
> +
>   * btf member bit offset 102,
>   * btf member pointing to an int type,
>   * the int type has ``BTF_INT_OFFSET() = 0`` and ``BTF_INT_BITS() = 4``
> --
> 2.21.0
>
