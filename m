Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122671F7EE5
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 00:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgFLW1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 18:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgFLW1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 18:27:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF32AC03E96F;
        Fri, 12 Jun 2020 15:27:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q19so12833842lji.2;
        Fri, 12 Jun 2020 15:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=etKK0PJEb1db058qQhJXVFpsTlugAG+cnL16z01cY8o=;
        b=M/K6eexYQiZP+v489DoNeUNJc0xtkvhIymy/lKVPEG79FLY6p9iAgIZ6EY0IcLfpPc
         C1FTksIO5lrv5XYIrAviQsfUDrge+1qOp7j9HimIMA7Q1SIUAmCAMwhlaZyYrsJLKpOX
         WVjk92eZSkiGkCxeW/4TWIOFvENQ1UFljl8dj9vjNTPKYu3jD67sWZUCxAjVpxkoTLGO
         5OLHDqFILSq9SFL+d+GKiHnrY5EPLRTMtBqXCbqsgWuq8rfKMyvOv8nT/dPjLkGpOCcI
         r6H/qN4mEirZ9svv1oGVzNoigcxV+d0Rpp3JMMHgp91pAk3hxdiVQXxJKH1sQTrbhOh8
         eC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=etKK0PJEb1db058qQhJXVFpsTlugAG+cnL16z01cY8o=;
        b=U19wZ9Kf3xzIuHxNcqXlfQp/O87L4/umWWn0Zrgsc1G0YeRUXAOvoIR2RWYCm3YxpX
         EQnKOazzjSlWHJrrH7ccXzH9yuqZCcR0k4s/1w8Ot9Arr1+Rw+i7IQDJS8/a+fkHPOIx
         qn+tb04zivvpzbOYq1IrMdMFiErt6+gEq0JOS5H/Ihk+ukSGqjfeYm2nhBYz4BjDmkWm
         Q5PKmvY6OpsPst67iUWd7MCNBwU5VpH4M/hdZzTB1dxJaSxyNhgqzOwTLBXRbbTv4Y7Y
         lu3+jHb5+vvkqohUCtEput1EWxWcyuNpw8BTGlrNB8ADelc7stTJzL/XmOI2MdD+hW8E
         Kr/A==
X-Gm-Message-State: AOAM533RejlWdq6FU1adF1muF4EZN66Tso5The3xM+QAyib81NrogcyK
        OaArfYjSp2LLk6U7sUgq9fsF1qrbEyjxygFDX/I=
X-Google-Smtp-Source: ABdhPJzU3Ajj2pba/mzBGU5dNaLOgn81OQ4fAU3tcndyhMjQMzroJo9umsi3ROWn5K8zXlvxsi3BebvILKJoabwKp6s=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr8114683ljg.450.1592000820240;
 Fri, 12 Jun 2020 15:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200612201603.680852-1-andriin@fb.com> <20200612220506.nad3zmcg7j75hnsz@distanz.ch>
In-Reply-To: <20200612220506.nad3zmcg7j75hnsz@distanz.ch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 12 Jun 2020 15:26:48 -0700
Message-ID: <CAADnVQKiyCaqPAO0yCuiFJOmvrxexxkaXJNCQEwxpsHjcm6j8g@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: fix skeleton codegen
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 3:05 PM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> On 2020-06-12 at 22:16:03 +0200, Andrii Nakryiko <andriin@fb.com> wrote:
> > Remove unnecessary check at the end of codegen() routine which makes codegen()
> > to always fail and exit bpftool with error code. Positive value of variable
> > n is not an indicator of a failure.
> >
> > Cc: Tobias Klauser <tklauser@distanz.ch>
> > Fixes: 2c4779eff837 ("tools, bpftool: Exit on error in function codegen")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
>
> Sorry about this, thanks for fixing it.

Applied. Thanks
