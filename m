Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D650E4C0C39
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiBWFg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiBWFg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:36:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E02C3AA4A;
        Tue, 22 Feb 2022 21:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EDA9CE13B5;
        Wed, 23 Feb 2022 05:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC17C340F8;
        Wed, 23 Feb 2022 05:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645594011;
        bh=RpQ+yXG3WFaffUN6V0S3i2gI2RX67GakuK4ftCRhl4U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Fpa7IScXDsqk4ECKhcoTOYPxb0jIoj+13R+KevQRg78oaEY9jTJGymNzCAv2JRrSa
         +7FWqta9tHZ5T7PmpBlQcbu/c1JZFx4LbwsYA/5ZM6fbyUyeZh3EdWg1M6yZ/fyozF
         G/aBkk2/QuLR6aeVxxBKrwx0OmYuUSeCXV2i1vjEOxatqRcWNqyv0y0i4kDSDfydKP
         PFrCbq1B2NzdboETdiCwYYTlwrfYsaX0J62cUmo5yCdnU4oi6L8rDifiW+G1jyMdQL
         bz1f0DIJaD7N3ODopsDhucvNFAr97h+0ZcjBsa2ggKEfE+cPLcuwAvxmL45KZD1ojh
         qpIdpilxoOtrw==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2d625082ae2so198333347b3.1;
        Tue, 22 Feb 2022 21:26:51 -0800 (PST)
X-Gm-Message-State: AOAM533tQIaIoJii/On3HMzc3/e/zg9hQSIsQxv/i9ukljZqkEHrldKr
        2vaKLX8owWWZOnevzw869iyIIkXcp8m45jdaC5U=
X-Google-Smtp-Source: ABdhPJyfshd1gVhgC3vT8dx9/92eRD19V4ZvzuTAr6QYZ+Zc+JlY31XDj0BqcEtQhmq8ohDT+WD5JxLT1FNuWFWTGFk=
X-Received: by 2002:a81:c47:0:b0:2d6:beec:b381 with SMTP id
 68-20020a810c47000000b002d6beecb381mr22698552ywm.148.1645594010676; Tue, 22
 Feb 2022 21:26:50 -0800 (PST)
MIME-Version: 1.0
References: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn> <1645523826-18149-3-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1645523826-18149-3-git-send-email-yangtiezhu@loongson.cn>
From:   Song Liu <song@kernel.org>
Date:   Tue, 22 Feb 2022 21:26:39 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6UHZYr49gSMo6bo_F9dd14SBDN=GGM4PeTTxJQPUCEPw@mail.gmail.com>
Message-ID: <CAPhsuW6UHZYr49gSMo6bo_F9dd14SBDN=GGM4PeTTxJQPUCEPw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable
 in Kconfig
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 1:57 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> Currently, only x86, arm64 and s390 select ARCH_WANT_DEFAULT_BPF_JIT,
> the other archs do not select ARCH_WANT_DEFAULT_BPF_JIT. On the archs
> without ARCH_WANT_DEFAULT_BPF_JIT, if we want to set bpf_jit_enable to
> 1 by default, the only way is to enable CONFIG_BPF_JIT_ALWAYS_ON, then
> the users can not change it to 0 or 2, it seems bad for some users. We
> can select ARCH_WANT_DEFAULT_BPF_JIT for those archs if it is proper,
> but at least for now, make BPF_JIT_DEFAULT_ON selectable can give them
> a chance.
>
> Additionally, with this patch, under !BPF_JIT_ALWAYS_ON, we can disable
> BPF_JIT_DEFAULT_ON on the archs with ARCH_WANT_DEFAULT_BPF_JIT when make
> menuconfig, it seems flexible for some developers.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Acked-by: Song Liu <songliubraving@fb.com>
