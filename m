Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17702491AF
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHSAMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgHSAMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:12:09 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9386DC061389;
        Tue, 18 Aug 2020 17:12:08 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f26so23394070ljc.8;
        Tue, 18 Aug 2020 17:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMZwxOv3Lvfi0TB5TG9oNmH0OF9cGItROpkDx6t7XuQ=;
        b=h63Vu4eWlCuzTHXpPSMkKkkWhCNw9WcTFLD2JAM4kvMknLrJUawGvWyUtUaaU7moNp
         DF1NEH7lEcLyx6bEEab+35EU3Yr4TBJi/QZNnX5Bd2JmUsZ+zYenDhNOS0NEeqHORC/+
         wACllzckr7OYdZ6VBYRF9sY0OVVs/IhikJvvSYAQiUIdIo3I057Fj/4R6W37H8VJifWe
         vkmcXmjSozsp34Ravu/mjz0OV6x6qmds0FT4t1XwDJZIKhkmNu12H+S7opFE0VEWyfRe
         Ki8uk3TeEALZB5CV80JcR6P1QfgbngnFzdU5YjRDShSQBnpfAbGAvA5+uVdWz6cgOr/E
         4itg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMZwxOv3Lvfi0TB5TG9oNmH0OF9cGItROpkDx6t7XuQ=;
        b=KL0HPorUSKyw5rNxGh/8qfGI9pHDQqq11DPN87IBu0Zj6YoZ6APPC4oJ0CnNH7iOZb
         +b9b3x4pH+kqBPCo2O3eA0HWufs0cfFovQR5zz6b7q2d8KNVOpyzRi2bDwkKlqCYk/Rb
         DI4D/cAOxWhjwiHrxRdfSd4AJBVItGEV3xMqegy2BexjHdea2DNyuBPaaNLFkp2evlqq
         x92LJjGGixsqpBpmU9m0B2xI5fW5vbY2/R3EZXuO6B3fxI7uoXGz/72H3TErlNOW+0R8
         vudo1p2Lxp17JTwZCoSvAc2zwdCZl5bDEj7t8Cr6ifdJ7HjJliGo94m6a9UFp1h1qc2x
         UroQ==
X-Gm-Message-State: AOAM531cYVZ9OukKSvp7jDV1fgIklfgsalTukboI/9WphbT1JuJqyhiC
        Pv1A6F0gU2uc9COjgicGvQ7rruAARFjLh4wdxrA=
X-Google-Smtp-Source: ABdhPJyZw15kABec0HQY94MdvEgS3Kv8I8ZafKEragLhOmF8JCQGexE12bVT/3A7XjRbZl8CZ83/hi6YFMFrn6xUG2U=
X-Received: by 2002:a05:651c:82:: with SMTP id 2mr10503303ljq.2.1597795926981;
 Tue, 18 Aug 2020 17:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200818071611.21923-1-vulab@iscas.ac.cn> <92e4b6ad-89a2-626e-d899-7d0e35f37ba5@fb.com>
In-Reply-To: <92e4b6ad-89a2-626e-d899-7d0e35f37ba5@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Aug 2020 17:11:55 -0700
Message-ID: <CAADnVQK0cGx2QL+zNDP6hSo6N8yi71PVTSPJA5HLdsy0FP1VQw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: convert comma to semicolon
To:     Yonghong Song <yhs@fb.com>
Cc:     Xu Wang <vulab@iscas.ac.cn>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 8:54 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/18/20 12:16 AM, Xu Wang wrote:
> > Replace a comma between expression statements by a semicolon.
> >
> > Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
