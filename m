Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAA769FDDA
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbjBVVqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjBVVqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:46:30 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CBA37F29;
        Wed, 22 Feb 2023 13:46:29 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id eg37so32334120edb.12;
        Wed, 22 Feb 2023 13:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fnpJo9GeGM9xQ3p25gs8DLQbx9dR+fuVXVEhSOnzgeI=;
        b=klb5lzCTBeuJ0xU/75S7eUSB0ew4GqrhEQclGcmTyAbGwyW3hkTUv0fSBOYPSyNNBO
         FRHTsHlzVjTaDHYZimdtQ3i8f4ijqCo2isqI7OknYKCAJTUTsWomYmIBrHl1epPGHjV/
         D1iMUFF1ziHLwCRu3ygHjdQ/gtEAw3YRwoEOEo9Puews6TDHBBk162mjnIukbB+HF2EQ
         u0eBvEA/lZZm0fqqidYV8XXEOjJDZ/y8LFDn3nkHLQIfMnnWBOV4fWE8fPHuABBaM3jp
         USnCm/6M7sh2/ee3fvl1uIto3jqfpMpSuOYL+tR2LrzR1oOYXlMv9y1Bndrqhtnh7kfV
         P5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnpJo9GeGM9xQ3p25gs8DLQbx9dR+fuVXVEhSOnzgeI=;
        b=Lwf6zzUkmL/BDbe8tUeRfAIky1zImQr+dF1TMeKOAQlYSt8bsin0KNUf8QqHhrcI+K
         GM8jhdCC12daJukPVxWzAWbCzWVTKconfU7cMKbeFLYFov9NDL8/n75GBUqWYlO8Y4CS
         uq8OsZXqKhQ8NUrSfRieOo+dD/xnyrmv7HSAu+IlnvsXLzllIZQbxufch6WGHxzmefs4
         0q6VU//XxHE16fnz5/JuJaivRt80vjQvLFxSIMd0CkFbtf08lwTqlTJgDfKrZANGk2Iq
         0d14uMCltDnzeKc57UZQhs5Xx5uDj/XzCz6HjvuaQpuoPbDpDPGkb+drTc/+SqyRX3jI
         myhg==
X-Gm-Message-State: AO0yUKWQ3ZLuSTfFvqGJK3cWqs441s24sL1poqHg9nlfN/u2+dTyDqcx
        oC8NlU0GNVxoZCVxinG4ljeQC3AgjLvsE5yKjh4gmgahQpc=
X-Google-Smtp-Source: AK7set//TTexfcnPWylFNJeEzurORZ/yrmI+2vPYbGJR8RTIVs6w7femHHvWtnwMmc3lA/EkfXMtwj4Io/xEPLnpUA8=
X-Received: by 2002:a05:6402:3216:b0:4ad:7bb2:eefb with SMTP id
 g22-20020a056402321600b004ad7bb2eefbmr5892351eda.3.1677102388228; Wed, 22 Feb
 2023 13:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20230223083932.0272906f@canb.auug.org.au>
In-Reply-To: <20230223083932.0272906f@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Feb 2023 13:46:17 -0800
Message-ID: <CAADnVQJHdD4gZ_EbYb4e=eTfwS0JQEdsJrUqe1010SPv3bzkgw@mail.gmail.com>
Subject: Re: linux-next: duplicate patch in the bpf tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 1:39 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> The following commit is also in Linus Torvalds' tree as a different commit
> (but the same patch):
>
>   345d24a91c79 ("bpf: Include missing nospec.h to avoid build error.")
>
> This is commit
>
>   f3dd0c53370e ("bpf: add missing header file include")
>
> in Linus' tree.

Yes. I just dropped it from bpf tree.

FYI we also added it to BPF CI's special folder for patches
that CI applies before it runs.
So it's no longer an issue for BPF CI though commit f3dd0c53370e
didn't make it into bpf trees yet.
All good.
