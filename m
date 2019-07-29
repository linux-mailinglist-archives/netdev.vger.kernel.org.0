Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D47779AA7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbfG2VJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:09:35 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37711 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbfG2VJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:09:34 -0400
Received: by mail-qt1-f194.google.com with SMTP id y26so60927007qto.4;
        Mon, 29 Jul 2019 14:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fy8QafTdBN9yNRGwWop6G5BWIqzv2sp7TiPQrKOlJLM=;
        b=rQpf5+vTx6Q22MLtyP41ei0tP6e+fmzZhXVrsR+1VJAGxN+zv4s5IoaM4pNxj7mVCU
         KbS3NvPU8cfpzPWP8xCcgl2MtYp0ShomwwH81FvixqALTAFubzNGHjjDu9DTO4WgjwAH
         fyGmT0lfodUf3YFv5HNxwc6Vu5EAEdFlZMNydJoGHsLzpEUbjhMVcb6ds8UB5mCB2WId
         WosyYHQXXl1Zwd8+l+vaew/2DrIBpScxm3cA7FexwPojOVQMAp7ouNWjnAoPxOiFxm7F
         wdRKTkmLmzWaPdcbccVhhPvmpuh7XYao2T03XXyHd8H8E3Ul4OfemQerRPIK1OHP0GMB
         EtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fy8QafTdBN9yNRGwWop6G5BWIqzv2sp7TiPQrKOlJLM=;
        b=Lm6w0sAoMFRvTWCxjvEgtYWZkos0BYECzpzOv7A+38n32KSx0pZXR+JvWRamOeOTEe
         QEEeqvIzKccY2hKFiKrH53QOVonnZSn2dasCIJ9FQNbUjcCGrvVYfxshRkhU2GGip/Vd
         tzoZ9SN5DgDj7DkA3fI6MO+aUG1QiTtC1eFVsBA469BIY+bIhoHb7AU2VcjP0HSwpRlv
         4ucqKdkSv8b8QTwLxilYPIxv97ZBqA992sZtXycR+Usg5s3Yuq4Lr3VEGNDpiy2fbETi
         y2gUjJoBixFTFtyr1zKSUhtnh+KMvufPpxBduHjU4MYDnaOw9A+v5uyq7YJHhDNow1HH
         nO3g==
X-Gm-Message-State: APjAAAULZiBUwhfdB+lGiQuaEiFpMYv1ij9wwwBcN8Gc98oiAdG41yvz
        Dgi6uR9KweR/pLTiXjtnlSzZXe3TH+BDfXOwvL0=
X-Google-Smtp-Source: APXvYqy+VP/lcHwZfI9ZQBtWjEIAsAqS744vn9szzu/yyFaDAlycPDpxNJt3Fr8Od144nGDW8BNH3IB2rLVQYHHcyVE=
X-Received: by 2002:ad4:4423:: with SMTP id e3mr67560813qvt.145.1564434573915;
 Mon, 29 Jul 2019 14:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-8-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-8-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 14:09:23 -0700
Message-ID: <CAPhsuW45mKiQnivZ8qeOQKRirSSzvwWBYTU2upVEicqjTVZ2MQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] selftests/bpf: add CO-RE relocs
 enum/ptr/func_proto tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:31 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Test CO-RE relocation handling of ints, enums, pointers, func protos, etc.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
