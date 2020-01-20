Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E123142297
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 06:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgATFGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 00:06:19 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34444 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgATFGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 00:06:19 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so32296036iof.1;
        Sun, 19 Jan 2020 21:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=pVj9NDJx2/7PFFi3/u/5FAFIHJCLf3D58a8+o9p3tPU=;
        b=WQj7dS3crFyqCVPYcu7BdZsUrcxw0MC6mUXHuP+18Eq/HzrX6w0W50Mzsuh+o+tWUf
         twHn1yIoJERi7kGf9keO/dbYy5dMX+yCoGTNfnVzVj4v2SRaYgAil9JX/1X7DBB2TPpX
         F8B4Qf4PmwnFYxHH2c4gTv6OzmVUHH02Vkaz5R2yKWNp3pGtez2xOJWCiL2uYvPcD76W
         up/jJWZhBTa6q2WA0Xs5NkgO0t/ssUiBARmtfh+fWsRS0/D9sEOBRPCtgqlLBf294PlN
         50B6y5pb5sMMPHEWjEpwHv/npSnMRxjGMoYSQ1HOjhIcKuyYj60micNGJnPkrTUAmxuf
         gkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=pVj9NDJx2/7PFFi3/u/5FAFIHJCLf3D58a8+o9p3tPU=;
        b=X+rmP0vM9DVz+r09fySPGUPMYiKy9q7eQ8Ow/30t8tqBRcK5Pd1+bJTKuZOKOO3F45
         3DNsxg/OEkIVixFLufYBRxr1eQAomxkQ5TVTFX+WokkuhcY8pS21wjfLaJQ2C6gSjxB7
         mTKwb7M+XZwBMgWV+UdSQ2JESbsGQn/KKAY+bc3L/dW5WNPYYuSH1ZxterGZkSlxJteU
         JFK2EAI/qdV77xf/nqQPhynk0RdZCP+r7kZs5UUmcfb1rf/frxTmuAEUU1pacD/ZbMqf
         KuqJo45sW3oCUXpxOIbSaH90paouAY0gel48AcG9Bd0oNYC9TdHLI21PaYlwfpjvUKrl
         1vzA==
X-Gm-Message-State: APjAAAXu7TdafSYAs5zAUMoNFyfj6NZCgJrcCZmgJUVS1Gpxf5UBBZlL
        9LEzvW42kcCTOieZ6sTuHXI=
X-Google-Smtp-Source: APXvYqzhiB2KwqCXj4v9UXq2FBSph0My9rg5TvEMHFE4N4fVykpEPoz/JjYnicXOOgzFIWNqfFr5bw==
X-Received: by 2002:a5e:8813:: with SMTP id l19mr41499039ioj.261.1579496778554;
        Sun, 19 Jan 2020 21:06:18 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u20sm7051639iom.27.2020.01.19.21.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 21:06:18 -0800 (PST)
Date:   Sun, 19 Jan 2020 21:06:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Message-ID: <5e25354342d65_3d922aba572005bc34@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzbKMJOGGv19jCakZusQ-R5pstPo0bSpns5k-mFm9b0W_Q@mail.gmail.com>
References: <20200117165330.17015-1-daniel.diaz@linaro.org>
 <20200117165330.17015-3-daniel.diaz@linaro.org>
 <CAEf4BzbKMJOGGv19jCakZusQ-R5pstPo0bSpns5k-mFm9b0W_Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests/bpf: Build urandom_read with LDFLAGS and
 LDLIBS
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Fri, Jan 17, 2020 at 8:55 AM Daniel D=C3=ADaz <daniel.diaz@linaro.or=
g> wrote:
> >
> > During cross-compilation, it was discovered that LDFLAGS and
> > LDLIBS were not being used while building binaries, leading
> > to defaults which were not necessarily correct.
> >
> > OpenEmbedded reported this kind of problem:
> >   ERROR: QA Issue: No GNU_HASH in the ELF binary [...], didn't pass L=
DFLAGS?
> >
> > Signed-off-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>
> > ---
> =

> Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>=
