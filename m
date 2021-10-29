Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB23D43F4FE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhJ2Cgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhJ2Cgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 22:36:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D07C061570;
        Thu, 28 Oct 2021 19:34:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa4so6166986pjb.2;
        Thu, 28 Oct 2021 19:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5jMJxS4oaEGvvxnO1MoSOjq2SAVMs+890AbhZNzdgBI=;
        b=Me0YK5oLZ8tw//8pywCn1SG/remtqqCaZsjASmrM5kw8BFbeX4jR5cEVAq/cj8b9SR
         1Cl/mg7Q8CW7gKboV5DdQ1cteQ+oUjKVqB48Rzo+hIrX0hmlmygvv9U4iDggyaz9mZdK
         2SWbjzrzhKsPU6N4eATIT4WwAlxBSrTvncqp0td1NXM+Bo4z+zi+vGeF+GfrgS5SKxEB
         qkd+CThNXRsS0scn+70ygQiBNCBdCgXJohQcWsvltJUnMAtDoWQKCRj/bsOU8M7xHk9H
         njOvcCIqUGqWJzKRUKa4zhTAw4NRgS05iRfSLvKEHqGJvBx5MxVvAeOUGZcLhFtQsozv
         hySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5jMJxS4oaEGvvxnO1MoSOjq2SAVMs+890AbhZNzdgBI=;
        b=PjgMTbhxAqNugKBKHcfTRR51qygywH1UXb0ckGGnBt4c3af8lRp+C0HK7B70IX0jtn
         Z0WOyR3KZVylcN5dISCmbdeCgqT/eQs/DI0tRdGH2J8IW0K9f8YjG8/1GBLAS0Yfmg3c
         UK3d7RWGPs5qAiN5mqo59aiBwj84/HtTJ6QVs1gXNNorXbvqL46S67p9mQzFZcIk+J8w
         0s1Ly4ReMVCesJpVY9trnGKmgka+reWZjH7/iXkpxnde598bQ1MEOfCM7OOG4Tep4XRy
         xjjGW8HlUpH5T63Se+wI78YPD630OFxyWSHIBma49ArOIDS8S8oRzcrkeRMQMW6IrzoB
         uEKA==
X-Gm-Message-State: AOAM533ISJeuxyRDh+k2ltWbNJQkmDZ3WHwBY22mMpY0oSpqxg4d9ndk
        GSkKu/u0rNsryGt/KOwHmh895OAuGH6aAUhZtUQ=
X-Google-Smtp-Source: ABdhPJwTvSdxOGtx5Ox97DWaIBXUKfPC84ULFnZjYCWNgfye5YJX/TKJXKHF+dct34bSmUGlYKgcE5EnKJlawJfBXHQ=
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id
 c6-20020a170902724600b00138a6ed66ccmr7613690pll.22.1635474848067; Thu, 28 Oct
 2021 19:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io>
In-Reply-To: <20211027203727.208847-1-mauricio@kinvolk.io>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 28 Oct 2021 19:33:56 -0700
Message-ID: <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 1:37 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
> There is also a good example[3] on how to use BTFGen and BTFHub together
> to generate multiple BTF files, to each existing/supported kernel,
> tailored to one application. For example: a complex bpf object might
> support nearly 400 kernels by having BTF files summing only 1.5 MB.

Could you share more details on what kind of fields and types
were used to achieve this compression?
Tracing progs will be peeking into task_struct.
To describe it in the reduced BTF most of the kernel types would be needed,
so I'm a bit skeptical on the practicality of the algorithm.
I think it may work for sk_buff, since it will pull struct sock,
net_device, rb_tree
and not a ton more.
Have you considered generating kernel BTF with fields that are accessed
by bpf prog only and replacing all other fields with padding ?
I think the algo would be quite different from the actual CO-RE logic
you're trying to reuse.
If CO-RE matching style is necessary and it's the best approach then please
add new logic to bpftool. I'm not sure such api would be
useful beyond this particular case to expose as stable libbpf api.
Also note that relo_core.c soon will be dual compiled for kernel and
libbpf needs.
