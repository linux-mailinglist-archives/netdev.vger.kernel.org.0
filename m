Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CF2263603
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgIISaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgIIS3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:29:49 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0387C061573;
        Wed,  9 Sep 2020 11:29:48 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r24so4879764ljm.3;
        Wed, 09 Sep 2020 11:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=33FN8FIP+zQLWL3O0pnQyPfU/xHipxIUxcsb3ufQ3M4=;
        b=HwdJ+Bpk+LGUIs3Qrq04mzdV70yspj1C/zfLFxbMSfhgZjRCVgdHQgSdl0nBUw0fCp
         QXTJwoBaslbO2ZFyE/8cWELzOA3GQUK/TA1eBtcy8Vbj4jumhsbmQeYiteS6hGeYAMSW
         STKlB8KQbFye4BnAVa/0ZJ0KdL6AWpUe0DfviEQw5MHk42GXr1GjqCaYgQcUdKNCaTyl
         mKwlIUdKoSSxDuW3IsVwUeEfSWvP2Dwlo6ESzVlY4eppDrJQTIa07W+vOF6p2jKc0dx8
         5lv4XxIo7d5WibcdOtkzUb+4VbGtBM2cETfwiiI7qUtQEHZBRGH+sCSavDDMfqlWC27l
         +JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=33FN8FIP+zQLWL3O0pnQyPfU/xHipxIUxcsb3ufQ3M4=;
        b=IUekx661A3uBtb5DEHxC8TDhBkdDxEV7ACWUT8TKujSuF8MAzDOCPzEThledS/ImdD
         xsbghcX2wzdBa4x+3Gg61Nqh0t1y2Wdc30c0mm0ec0xQAlmrKuqdeNcRuEjF2gxMSQy8
         Mq6To2cqyV/leiD98QvPp0iwXV48pIxJLGgau6VoCNLX2FqfABmeTeq5vnTeoA8ZYFym
         E+oy5+1uxfC9s9wi4cdVis2BxZ70AC8BBVFF7712s3oaCYOuwZ7/hY7sglf1uQGlhm3g
         mE9JLuWknFAyzx2jeRLECpuKbPmX3dlmJWqhMglKhrMwqLmf+WMrCPyBQgVuLDisP1rN
         Tr/w==
X-Gm-Message-State: AOAM532bi27S4uqUbzjCUWhmVKX68AcU5YrayxqNSPIBmnwrzKrAToRK
        3RjhJDaka8p3fo8U5iuryiY/lDsuSFD3znj8kcw=
X-Google-Smtp-Source: ABdhPJyuict1kKxpVLunAXYWseT6F69HsmBBfedjGkq3Eb1OiD1k7JXWE8b8RqRDDWqBWyDxs7GY5dIhplFjGx96m6E=
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr2605461ljr.2.1599676185570;
 Wed, 09 Sep 2020 11:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200908180127.1249-1-andriin@fb.com> <20200909091227.3hujrwl5ol7de2b2@distanz.ch>
In-Reply-To: <20200909091227.3hujrwl5ol7de2b2@distanz.ch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Sep 2020 11:29:34 -0700
Message-ID: <CAADnVQKKYfrVyGXS7Yb-s3xhq-C-uf3mz_B0rOPvx5oeFKWwLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] perf: stop using deprecated bpf_program__title()
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 2:13 AM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> On 2020-09-08 at 20:01:27 +0200, Andrii Nakryiko <andriin@fb.com> wrote:
> > Switch from deprecated bpf_program__title() API to
> > bpf_program__section_name(). Also drop unnecessary error checks because
> > neither bpf_program__title() nor bpf_program__section_name() can fail or
> > return NULL.
> >
> > Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

Applied to bpf-next. Thanks
