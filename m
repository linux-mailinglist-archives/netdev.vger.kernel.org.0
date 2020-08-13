Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9672431F5
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 03:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHMBLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 21:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHMBLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 21:11:07 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2991EC061383;
        Wed, 12 Aug 2020 18:11:07 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 185so4314053ljj.7;
        Wed, 12 Aug 2020 18:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RX0NttPzQCjI2L1V+oLAWJnIQwGk9mAF7kI5OIfUYzE=;
        b=fEpbuetIPR26PTBftXwt9baiD+gpiLwfgszEBrWXCcJ8PLIEFaa+YYQnNUrcE7DoUD
         MZONytxe/ia9m82vc1K+broIpuahqd29t4lvfuYcgkvUP4mupFLuSTH+oMnX+rM82Ak5
         vdZxdb7uTgM1/YtHa30RN8E5ZGjSao4UsWUbDSSjbt5ApaD4hF94EbX6/g4RfxyvJkSX
         GHRiOuDIN37kNOovhr0xZxYxCZhFg2LA1823oBQ2uMrhC11XjNGEq3TDHjlSKvXByRyi
         OqCmP0tVzFPI+RZcdCePKSQ3nNry+9sYIy1RqZeXMvEov5CkLRcFUN7AZFMu2U7u8trv
         Lrhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RX0NttPzQCjI2L1V+oLAWJnIQwGk9mAF7kI5OIfUYzE=;
        b=ScipZh/7HJL1U7SRllBGgDReyscYnlQoMSWU8ShAHr9+pXpCZUaj0YAK/y9uUqKCVt
         +ChRnFFL6/Lx41Mks2M2uAjxO0O2EiNKOe4/eKlcWfjvrZI5asg5DOiIRX0RYuWNDw7g
         CfxREJIGDes6CmwGKLwVwSy4JM+Q+tYJ4pIpYzUszRPHW1eZqqNHnCujj50squMkjIIf
         4heopCwr8QFNDx+FMQOP5Kg/j2Kw4ChHywfAY6FS45DJ6l+gFYwvF21k4RtHiEOVf7FF
         eoKbCWCsKQ4poIHeINkPbYhdYQWnwqNzBY5HcLohxfPchIOJVx1UKJ8eX6iI+HjL1Zsu
         sekg==
X-Gm-Message-State: AOAM532A6nQ65FHwPrh8yQb9o7dBFilEEH9Txz5YxEO10kWrj/xj4kyD
        ns6DaIdIiTFa7JTtOzyv41IBlUgbLfbwxljKlqM=
X-Google-Smtp-Source: ABdhPJyN5U0IMukS85HkGduLxghCIP9StXjaaMlhYbSloZis0Alx4d3PBA4KGCTIykeKrmyHRAUx5aBNVnObra9rwq4=
X-Received: by 2002:a2e:968c:: with SMTP id q12mr760626lji.51.1597281065557;
 Wed, 12 Aug 2020 18:11:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200812025907.1371956-1-andriin@fb.com> <510B2A6E-60EA-459D-A40D-9C21182C166A@fb.com>
In-Reply-To: <510B2A6E-60EA-459D-A40D-9C21182C166A@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Aug 2020 18:10:53 -0700
Message-ID: <CAADnVQLbhyOwGuV0+Kq-nuACC3mUVFOUU9mG+aPkUV5N-6ykDg@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: make skeleton code C++17-friendly by
 dropping typeof()
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 8:35 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 11, 2020, at 7:59 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Seems like C++17 standard mode doesn't recognize typeof() anymore. This can
> > be tested by compiling test_cpp test with -std=c++17 or -std=c++1z options.
> > The use of typeof in skeleton generated code is unnecessary, all types are
> > well-known at the time of code generation, so remove all typeof()'s to make
> > skeleton code more future-proof when interacting with C++ compilers.
> >
> > Fixes: 985ead416df3 ("bpftool: Add skeleton codegen command")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
