Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C224E33E0AC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCPVgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCPVg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:36:28 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BD2C06174A;
        Tue, 16 Mar 2021 14:36:27 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id b10so38410640ybn.3;
        Tue, 16 Mar 2021 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHp+9ULVmt1QQ2xoZ0dgKSUcyeLsdDy2SK5QHfWjHo4=;
        b=a6l67ytmuhoiG30K3G26iS2Bi1h8RBv0+jSHaGAb1BTB8guxtjm3zJ4vpf0IbRODu/
         bETV9+26qaBRj25FZMtnwsnnpW6HKQDx9nZIVhYZjMG2UIBlI0XvW2Cg7Vb2oTQhT0fK
         EeatpGj1whPqBovRR2pL/dtksWkdI/B/jZDH22xeim2wVwos6DbnBpFJba3wQ5BpOBYx
         vrBGKv7DJPvHm9Hb+C2RTcuR/8KQ37Vu0J1cu0ijdXdAqF5uCuqpw7HShNdNGPSsC/jo
         RZ4K7hujIpy6nWlzaF2vpGRyIq3g7D3Xa9Up2Vj7WL6k1CAgqVlMIqc911i+hOfs4ABQ
         euwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHp+9ULVmt1QQ2xoZ0dgKSUcyeLsdDy2SK5QHfWjHo4=;
        b=QgcXvXRYkcR8eaYwmXZFTjLiJCuYmA5TQPr7DW/QYAybeGdpQkOUE5bOO2YeV55xjv
         hJXd1FtkXwokRl5DxnXlDVOsopLbli3sVf/qpYTsTnlCZxIQkxL5i9WDkcuL/cIpES1q
         njwoI8JkdBl9YPZjoeHbLZjVCC8t/6PdB+ZfW6sIMcPvyOwnX/it8i9KrGtS6NpnWFgf
         Du9Z+MrirqLGwTo/GayyJZq6cXTjr9xPM2tZ+BSOXKHdXMY3K1HmIVvNvl4oxQ/B8uzc
         yMSFf7f7G4k4xZA/MubnzUJzhGleKA3QJ0MuooettiXomtOQz/AMVewoOT/wfhR1zrcI
         Tzcw==
X-Gm-Message-State: AOAM532sOIQg4yWTeemhauhl9THfVnds+8W/ZvNF96BfcPGCOnliFlij
        gyokoh125tcw+oGkEp5L1eCL6OUwQyNdW/cZNao=
X-Google-Smtp-Source: ABdhPJxPC8+9EzrXixIMvkogZQxUPqlnhRlhG7gbg3Gx+gGqI0LILTCJJjWMdCePEbNU+Wgh6f7PIPU9bv6xIwWr7Oo=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr1176157yba.459.1615930587281;
 Tue, 16 Mar 2021 14:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210313210920.1959628-1-andrii@kernel.org> <272da26c-ec14-8c14-3766-acec6f07ed7f@fb.com>
In-Reply-To: <272da26c-ec14-8c14-3766-acec6f07ed7f@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Mar 2021 14:36:16 -0700
Message-ID: <CAEf4BzZFkiR8F+Xi8+uR_PZJza2YdkK8Nypqv91C+x1WAsssrA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/4] Build BPF selftests and its libbpf,
 bpftool in debug mode
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 2:02 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 3/13/21 1:09 PM, Andrii Nakryiko wrote:
> > Build BPF selftests and libbpf and bpftool, that are used as part of
> > selftests, in debug mode (specifically, -Og). This makes it much simpler and
> > nicer to do development and/or bug fixing. See patch #4 for some unscientific
> > measurements.
> >
> > This patch set fixes new maybe-unitialized warnings produced in -Og build
> > mode. Patch #1 fixes the blocker which was causing some XDP selftests failures
> > due to non-zero padding in bpf_xdp_set_link_opts, which only happened in debug
> > mode.
>
> It was applied. gitbot doesn't seem to auto-reply anymore. hmm.

Thanks! Yeah, it seems to be unreliable lately. I think it sent some
notifications yesterday, but not all.
