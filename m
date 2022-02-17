Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11F54BAC55
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbiBQWHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:07:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241942AbiBQWHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:07:43 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258C2255B2
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:07:28 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id b20so1507444ljf.7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijnPhyMKFjLacRwsq6wJqVI+dsfR6jRM/9JEYsJoH4U=;
        b=HHgzLiQGKn/DqoDzxVs9zcmNl1DSsvWVBmjhge3+iadm1WyGf9qne11jusE+yfGiGi
         QlM8Ik1Nj/O2kD4hPLX1vFY/n1+ElHAxfUVxZMnSyg7y7TyGU5r3BqyilfL2H+FH9N8d
         WmVnGY1f1CH8viTjzyb06FsirPFqhSo4zr/NU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijnPhyMKFjLacRwsq6wJqVI+dsfR6jRM/9JEYsJoH4U=;
        b=5fi5A1fClNQFWJz66Eek8zwAi3Tm/+oA9YuqZrSO4vTGFueShkTM9Bv9wKvBYGLYTg
         ax/SxKIEpYHOTlrtMqXvNoPioViEaZEgC/3kKn+Tf5a7QyEwgbvGrJGyou082JrZRpmO
         5lpUnCIc0xO0509oB7L5f0r9Ggi7SZEcBczgBBn59rywa8F2QReeNKFWD7LEK4X/UnsY
         WOFRYe9Lyly2t3m0doMAEUImJeRxd2bbtoa0TrvxMacJVTYrt3UH2aLw1AS1rmCm9c3T
         JDDMh8Kr5fa7VelNWOSfbT588hWuQaLfjKqEf7Yg3ayMQ2H3vBclQS5j+5T3mDgQUi0K
         YOMQ==
X-Gm-Message-State: AOAM532oZzn8dhaZiePv5eaJgULpud2jhuh1iAAaM2MR8/Di66SuH8b6
        e5wG6zumuwjm5l2ZYhF0mJpat8R7CAUS9x75TKZNAw==
X-Google-Smtp-Source: ABdhPJxsK1j9GUlpN8iWkm5XFhiJAMaL9qcssZs/whXHPzJRNSqpDFwKzdfD9DbaTR2LJo10VO/5YSp1smmIJxpzw4U=
X-Received: by 2002:a2e:99d6:0:b0:23a:925:6aa0 with SMTP id
 l22-20020a2e99d6000000b0023a09256aa0mr3793620ljj.110.1645135646378; Thu, 17
 Feb 2022 14:07:26 -0800 (PST)
MIME-Version: 1.0
References: <20220215225856.671072-1-mauricio@kinvolk.io> <CAEf4BzbxcoP8hoHM_1+QX4Nx=F0NPkc-CXDq=H_JkQfc9PAzLQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbxcoP8hoHM_1+QX4Nx=F0NPkc-CXDq=H_JkQfc9PAzLQ@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 17 Feb 2022 17:07:15 -0500
Message-ID: <CAHap4zuD4ei9XT-+L0tjah_nG0n1o+wAkdV_HMBM23SErg8CWA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/7] libbpf: Implement BTFGen
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Fixed up few things I pointed out in respective patches. Applied to
> bpf-next. Great work, congrats!

Thanks a lot for all your patience and helpful reviews!

>
> It would be great as a next step to add this as (probably optional at
> first) step for libbpf-tools in BCC repo, so that those CO-RE-based
> tools can be used much more widely than today.

I like this idea. It'll also help us to understand and improve the way
to ship those files within the application.

> How much work that
> would be, do you think?

Probably the most difficult part is to embed the generated files into
the executable. I think generating a header file with the BTF info for
each tool and some helpers to extract it at runtime according to the
kernel version should work.

> And how slow would it be to download all those
> BTFs and run min_core_btf on all of them?

The whole thing takes like 5 minutes on my system (AMD Ryzen 7 3700X
with 60mbps connection), given that almost 3 minutes are spent
downloading the files I'd say that with a fast connection and some
performance improvements (multicore?) it could take around 2~3
minutes.

Let me think better about this integration and will be back with some ideas.
