Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D837CC933A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfJBVCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:02:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55253 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbfJBVCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:02:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so343864wmp.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gzsVfLOt59b7p12S85OGyalCddgvvAPhErI7gXkFcYg=;
        b=RqQpbgOole5asKDtt8qB8e5VR3VSs9DlaL2SVnUSpwz0XxjEB+9tKbGrbLcDPhyAVv
         HAMUMiksZJK/VUoF7bEWOlq842z/WY+dB4Gbg7DSCqDXFlr4aLmXpv/nuA8fbClV9wrE
         eDG+Lguo5Ktqw4xuYp1NUjtKcLgKD0LDESUtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gzsVfLOt59b7p12S85OGyalCddgvvAPhErI7gXkFcYg=;
        b=UHA/ytoGZoS11GsmYkdDxWBREIifdsfkV5eRiTs0J/beOmrvXDq1181Gzy76sTrHdu
         5t7Bmba82TLQx+eMLsg4z2M5ZYOve76COaKwiSbzFcAN6hMFEHRvYuGPEowYuagYwiXl
         N/LacnePVUQY0K1ftDUdfze2pvXaij1r+E6T1Qg1F6idP3Fs+dIKKFboAFXwdJbrly1S
         9OLuYvGTSlAGBhLm78hMqE4YB4U1tWyILdw2Y/w0CnDygnbvClZqPkwcG9IK8KdRFUWm
         pQ2Qd8GKR8B44Fh/VLRJfXJvmwVJkn/0RCbiDoOIQgNU2PTyF+WdG7qSBhawb3iyfQiJ
         xAaQ==
X-Gm-Message-State: APjAAAUlL5AasMMOzFMYaaJUaWnnTAwgCG9SQJOaLx8XjJHvTXy59png
        3hG1OF8rms0REDNVO9SZPKrc3HBYj+xAtMdzRpmWmg==
X-Google-Smtp-Source: APXvYqy77dFOGBu4403Tyjq8z5N/mPTGFQ8GkPVWiC9umTKskB0g1g3ykwUl1VxzEWwpzkIznz+o2oeXfB/1oJwIW7A=
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr4355597wmu.139.1570050139565;
 Wed, 02 Oct 2019 14:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191001112249.27341-1-bjorn.topel@gmail.com> <CAPhsuW5c9v0OnU4g+eYkPjBCuNMjC_69pFhzr=nTfDMAy4bK6w@mail.gmail.com>
In-Reply-To: <CAPhsuW5c9v0OnU4g+eYkPjBCuNMjC_69pFhzr=nTfDMAy4bK6w@mail.gmail.com>
From:   KP Singh <kpsingh@chromium.org>
Date:   Wed, 2 Oct 2019 23:02:09 +0200
Message-ID: <CACYkzJ6EuhtEPDH=3Gr8eo5=NtUVgCMvqq64POX31pB-gVSbTA@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: fix build for task_fd_query_user.c
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 8:46 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Tue, Oct 1, 2019 at 4:26 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
> >
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Add missing "linux/perf_event.h" include file.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Tested-by: KP Singh <kpsingh@google.com>

(https://lore.kernel.org/bpf/20191002185233.GA3650@chromium.org/T/#t)
