Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3125B3BF440
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 05:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhGHDTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 23:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhGHDTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 23:19:31 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D01CC061574;
        Wed,  7 Jul 2021 20:16:49 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id p21so10482410lfj.13;
        Wed, 07 Jul 2021 20:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EuBitGCp9JesYh5sdj5eqPVCDuGNnzs3S7G9gvYO70w=;
        b=qpNFpx5bxvVv1h0F6VLtN6W2IWGNHL+2J/ewNcUPtz6onCLvDYomy4A7MKtst86kYH
         wFYfj4hiwIBbMaszradNZd4JF493z64kryks4Chu9Um9oDCO9k+en+9DJx6OVav1v2JD
         vFK2Gd5Ii9QLGkx7X69ynqvdp1kuqwDxMmXVeLl90fbaS1rS3lXhztCt2hh95Bqp12bd
         zf4rR3576PmWDvj+Boy0Btj62znU3Y9CVT6bA1RR5l0JAqp1prprT7rUTzSFLJTvHsjB
         wBtBlygpkUmBmtoSv1f9jNS/nVLPsHsWyvImiP/owMr5On8QfgcWyWveX3AA9a8uvFB+
         IVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EuBitGCp9JesYh5sdj5eqPVCDuGNnzs3S7G9gvYO70w=;
        b=HAhe53b+gLe44NcyyNmTE4S8xYozMcdVRLAahMI+9g5scnj61KnqtE/z3IB/ujhAd5
         ouwxTWX7INi/kqmmj1iZXIxfjJ6s5vnWYES2FNQ2L2GALIOIn5+Freph6+5FTRgcsTOc
         QyZd1yekSkD6rFBm2iajFZckWF1hG8jct856HVXjHJ8GFyeax4BEEGgeNV0LK5wawM2a
         LPOmMYejs7rUh+2B22sJHSei0hn72tPnQINEAiviWWnzfLepvuNYW7Ho3gY2AY0p7GlT
         YoN7rKQdMlSF1Di0/o3nsW4O/Vyhwgl3c3Rr8scIhZNKAhRsP8SpMI17O/tzng++4Q86
         oRSQ==
X-Gm-Message-State: AOAM531pm7qIGQx39tC1RNOLvZ1E5NxUeqS7MtCQri67OxcZ0Fl526fS
        wDjP14gMws0GRpQyAg0uh1Ts044c0ESNR9Eax9Y=
X-Google-Smtp-Source: ABdhPJy2VhIfF+IB0Zop6gyB8VX7dVvGHnVKbHU1VcZn9vFB13Gr84kZfOwE/m3z/c35KwTC6q4QsCxYC0AytsLx/Cg=
X-Received: by 2002:ac2:4893:: with SMTP id x19mr1592041lfc.214.1625714208020;
 Wed, 07 Jul 2021 20:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210707060328.3133074-1-Jianlin.Lv@arm.com>
In-Reply-To: <20210707060328.3133074-1-Jianlin.Lv@arm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Jul 2021 20:16:36 -0700
Message-ID: <CAADnVQ+FV6J-y3VkbP6B6cJEO0sFa40kHpinSuwVN1Rk2Fk=qA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: runqslower: fixed make install issue
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>, iecedge@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 11:03 PM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> runqslower did not define install target, resulting in an installation
> tool/bpf error:
>         $ make -C tools/bpf/ install
>
>         make[1]: Entering directory './tools/bpf/runqslower'
>         make[1]: *** No rule to make target 'install'.  Stop.
>
> Add install target for runqslower.
>
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>

Andrii applied a patch that removed install target.
I don't mind whichever way.
