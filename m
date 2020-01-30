Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBA14E271
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 19:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgA3SwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 13:52:14 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33375 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgA3SwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 13:52:12 -0500
Received: by mail-qk1-f195.google.com with SMTP id h23so4037700qkh.0;
        Thu, 30 Jan 2020 10:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMl8JElt0mvgTgvW+EEMMXYvFexdnBQSWb7RkJvCjqA=;
        b=ESwOkmcyHoMoeUwUDadDvmHHjHDYkxsnJDKmJDXyf7F74pcbvZbnysaJGoLY0igKek
         ClGvhIjqslHFVlwoxiDVXSyD800fHGurfXiTJHkUKuEZekoHhi+TMwS55VOC2VRyuFEc
         nolRoPbSbnxksppjMw+0YjDOc04rxh/C/J9P+ZT8vgKNBlEtUDWl2CuUF6DOglLMZ+VW
         q7BhkyrSsW+85zZTNroYcJobQiwAqm0LQtppGajCYhBZpedZ7pSXzqbFCxpOu5mv8yjz
         nu/dC8Qo8ubf9XeBAN1fpn31N8n8ECEr5suT6V6eoNb7ET1jRLvn7wHWVFHhDqlI/fjB
         9u4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMl8JElt0mvgTgvW+EEMMXYvFexdnBQSWb7RkJvCjqA=;
        b=Dd5zxitDypbvMufn10k4YYUkKov6GnKEyWN+wJtUV2cgkQZufMtKuk9ocmjqv9VGd5
         mpKWGXRjqmrJ6gLNzyGY+VP3qxFDyNRBzRTQzEhCridVjsO10if9Mbj2mka/iAG3I/uP
         FfSx9cFj5fzqirFi3rMLd6OPsAiEyMgU2NY6DRG8G413Kv3wBUS5G5J5DGbEaJaKqSrd
         V5juubsUr9Cts3BZHZ3B/sqj/PGG4AdPxju7LZhKg4W7TJvLnNny4sonajHLpAGd1gK2
         GMu4UmDV+6dG8cFi8WAlQswVMvtHcd1R+WrgIfPv3Hgmbhk2jMaCvgYsxVe6vHsIAq0B
         XPYg==
X-Gm-Message-State: APjAAAVZVLPF/nrWyqpHOu687xZ/iJt4T51VrXWD9oFhczU/xU2hKsRH
        S/ESkIf8JgfN/8YmvQh76Xv8ck8d68SKGGWhDBo=
X-Google-Smtp-Source: APXvYqw7Nn9YpFh+P9d/GAaw+6uz6DZrDlKzkLBFlhl6WWaT5W8fBebgHo01bmHJT8lu3H6BC6Yrd2eGgl4Z59I7GAQ=
X-Received: by 2002:ae9:eb48:: with SMTP id b69mr4100302qkg.39.1580410331255;
 Thu, 30 Jan 2020 10:52:11 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzbjXRFYkr2LCh50mLV+cQ9WrgRB+U4CbxekVVf=nfRUZw@mail.gmail.com>
 <20200129035457.90892-1-eric@sage.org>
In-Reply-To: <20200129035457.90892-1-eric@sage.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jan 2020 10:52:00 -0800
Message-ID: <CAEf4BzZOWRyuhDUdbCt0fqroaX1sGaTpwPohKwntFm+KivkWnQ@mail.gmail.com>
Subject: Re: [PATCH v3] samples/bpf: Add xdp_stat sample program
To:     Eric Sage <eric@sage.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 7:55 PM Eric Sage <eric@sage.org> wrote:
>
> At Facebook we use tail calls to jump between our firewall filters and
> our L4LB. This is a program I wrote to estimate per program performance
> by swapping out the entries in the program array with interceptors that
> take measurements and then jump to the original entries.
>
> I found the sample programs to be invaluable in understanding how to use
> the libbpf API (as well as the test env from the xdp-tutorial repo for
> testing), and want to return the favor. I am currently working on
> my next iteration that uses fentry/fexit to be less invasive,
> but I thought it was an interesting PoC of what you can do with program
> arrays.
>
> Signed-off-by: Eric Sage <eric@sage.org>
> ---

Looks good, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Changes in v3:
> - Fixed typos in xdp_stat_kern.c
> - Switch to using key_size, value_size for prog arrays.
>

Just for the future: you should keep entire changelog, starting from
v1->v2 changes. Also, netdev patches usually preserve them as part of
commit message (for individual patch) or cover letter (for patch set).
But in this case I think changes are not substantial enough to record
them permanently, so it's fine.


[...]
