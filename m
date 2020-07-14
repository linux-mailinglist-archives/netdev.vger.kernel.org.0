Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2643E21E459
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGNALR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNALQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:11:16 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804FBC061755;
        Mon, 13 Jul 2020 17:11:16 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y13so10272580lfe.9;
        Mon, 13 Jul 2020 17:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VP82AmNODkIZDsrJHwS5EQOS87SFzy6wLeqD3456CTo=;
        b=AleOdpkuAjavnDnuZoBwyuLmopaxMvFxNP1qetXY4FRj7VjcPdJeCto/nLfB2eIDyo
         XNPxs8Bs5TUmrNDq8Ygk0CW+c7F4st5mjJ6hJZgL+QU2tM5lL/wbA2aZamWoP/525kZM
         GTzWj32PqggRN2PP2UPh9QaxZBZizrX+ZTGg7Nn/bIg1fW3kfqlMLp3JxO630/FsJw6Z
         o/yZ/kY1K5zXvlV1r2N+bvU8YifMUFp4L299EaI8aJ694ZsvnlO689dxt0S80WaDbuN1
         6QtJ7MTYDIRg/LbCpaCZMapqiMnt3UMZBVRBVaBKeEpyOklVz2j7B0rT7JI9O3eIkrs7
         6q/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VP82AmNODkIZDsrJHwS5EQOS87SFzy6wLeqD3456CTo=;
        b=hmC4nqxuN/djkZoD+gAiZTNKZ37Nq2sByXuXX6vX8xDYddr7Xl4zj2RuVGSTWIgP+8
         ZM93c6qw4v3rJcO+kGezYyTrglbqqXljr+gnTTKfwyINhkE1dk3/JT/Zeo+CjsZcZkGB
         RwL+/lC0A7Dy7ZYJezU+S6fsIP618Mcjs6/zErxn2DMB6O0ML2XZrbKz3Ss2mj2XQHMh
         /J1WDTue4mdWXjSfSPqw+ekgOJY/08CkYhSSte79d1tYxnib/f9VlxmCbdM7H4t09+14
         +Xdo9xVxnieKOfSNy+DpzwGBsgenJR1577sOKcxl21iQ/9p4NqSgyHhrK8ewK6Slzput
         1Oyg==
X-Gm-Message-State: AOAM533c6ceXdKXyTOTpikwm0aZsd5Pqdw7rv+Kx3HtTjzxlxyvWH7Kz
        7P3+P74tKL1zY5swioxpgxxizu2vxSJtc8hbWGc=
X-Google-Smtp-Source: ABdhPJyMA/JsNRIVo/OtHv/pkyeSkMUMJdicN1MguHhO8+QzhLnT/2aezd/gJaZ/bJqyU3qEg7EDGCq8EvdUjWTV4bU=
X-Received: by 2002:a19:8307:: with SMTP id f7mr779411lfd.174.1594685474877;
 Mon, 13 Jul 2020 17:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200713232409.3062144-1-andriin@fb.com>
In-Reply-To: <20200713232409.3062144-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jul 2020 17:11:03 -0700
Message-ID: <CAADnVQKOS+kYfQTCyv5ezZFF+K9UZhDcdm9jP94Y4o4C5zzacg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/2] Strip away modifiers from BPF skeleton
 global variables
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 4:25 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Fix bpftool logic of stripping away const/volatile modifiers for all global
> variables during BPF skeleton generation. See patch #1 for details on when
> existing logic breaks and why it's important. Support special .strip_mods=true
> mode in btf_dump__emit_type_decl.
>
> Recent example of when this has caused problems can be found in [0].
>
>   [0] https://github.com/iovisor/bcc/pull/2994#issuecomment-650588533

Applied. Thanks
