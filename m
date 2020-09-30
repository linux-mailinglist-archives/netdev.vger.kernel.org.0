Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4806A27DD7D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgI3ApC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgI3ApC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:45:02 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF8DC061755;
        Tue, 29 Sep 2020 17:45:00 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x20so5054359ybs.8;
        Tue, 29 Sep 2020 17:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=16w5ouYxSlGV11Rjrz11+XHw5fAdPd71YoXsKBG+aLs=;
        b=h+ZCJocIJHQmw8qnWtHcHsbFPaEav0E+dvnpXfKftiyvurt91A/8A0a7KTWnWltYhx
         1z98imarr3ljbP4rMuDkSG4Zj+9SiqSRMkJbOE3M3A4uolQcSXRy/JbEyFfkkMeMSGjI
         U0KMgC3W2wKOw7KQH/MOwCaY6T7uvir5K2/4tDJeLD2FnRdCu7a0KbVucgRLl+W9EA7B
         WHRHTLKKXlaq2z5HD2wjJWSUPA+jBZNPTAUTe5+mW0wH6YNHPOfT18Q2P9CLiAZG13YC
         nEAJg/04V0VWvaj6eXNllf1IIicXqJI1Vhrdr+OAvXldCOBnc544EC9EM9xrjv4CWTgi
         Q9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=16w5ouYxSlGV11Rjrz11+XHw5fAdPd71YoXsKBG+aLs=;
        b=knBjtgcVD9e54gGGC9gauP7LtayyRFezULuZeC3/ob+4vnVOX1NK44+ug7Ti4X2Kte
         yVDaViLUaZ56EfP0jN2r3RoMeR1qlwmlF/kcU73JdLVkSO65RMMdDQMu/MZfqDztI2Eb
         8Oyt68wxxrVIgYjmldHJxJQ+Qk0IJmmyTEM54K3/hzIG3lSnO0/gIkdjecJNH4BDswwM
         TTtepP5uUNboDPsviY7GyA2ZFV9aPR+49XenKR+V58LwC2NCY7u569JpJ7RE22Goqetf
         YiwN1b8TLXCrVyJIQ6XJ0bjdqq0ZzjHoScE7ozLtFENnmCgURkeXEWBytVdwu/dLevOI
         cNPA==
X-Gm-Message-State: AOAM532hoQu/yXBgRwZWqG2Qf1WxluCGUA4/YLBpUxtWRjXAGFCrE0aC
        Hay9Fl8iEQ+tCMU1jy2dAYCAjL0W7bfVaI/VXlU=
X-Google-Smtp-Source: ABdhPJzLTbXeT2JyzleN1GfGnAcIz+PaLfG00iGzJKFSjNMsH0m+FXIl2lBwX5tANmrGulgv9QxdbOTG2rbp4uUYt5k=
X-Received: by 2002:a25:8541:: with SMTP id f1mr69684ybn.230.1601426699763;
 Tue, 29 Sep 2020 17:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200929232843.1249318-1-andriin@fb.com> <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Sep 2020 17:44:48 -0700
Message-ID: <CAEf4BzYByimHd+FogxVHdq2-L_GLjdGEa_ku7p_c1V-hpyJrWA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 5:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 04:28:39PM -0700, Andrii Nakryiko wrote:
> > Add btf_dump__dump_type_raw() API that emits human-readable low-level BTF type
> > information, same as bpftool output. bpftool is not switched to this API
> > because bpftool still needs to perform all the same BTF type processing logic
> > to do JSON output, so benefits are pretty much zero.
>
> If the only existing user cannot actually use such api it speaks heavily
> against adding such api to libbpf. Comparing strings in tests is nice, but
> could be done with C output just as well.

It certainly can, it just won't save much code, because bpftool would
still need to have a big switch over BTF type kinds to do JSON output.
I can do such conversion, if you prefer. I'm also thinking about
switching pahole to use this during BTF dedup verbose mode, if Arnaldo
will be fine with changing output format a bit.
