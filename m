Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ACA44EBC2
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhKLRHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhKLRHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:07:43 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC7C061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:04:52 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id q14so9036002qtx.10
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKH3uQ8Puz8euGKdPmXcZTSsxpYwOvRFhDCsc/Y1RfA=;
        b=PrDlCiGgVfz4z6UlLKoUH4RmKqGZ9uYINIF8DpsspNt3gcLsi9EpFsEwjH7c3Fkeow
         1OLspzFzJ6CC7xByUsJX7DnXfEws5YnRETqNc+0uMJ0FkUcw2CifAGLGhM+JgBFEoJ3f
         M41drxtOugzRNgAHBKU9Hl5z+Emx4iUCYPNBJZ4OSAbEsQxxsdj1C202RaPA5ohPNX9C
         rja7JMd7voADCAaJKcTI75T3YWudj+p9uUxQ5lHhLXo2f85Xjg/UUP3GgXeEVk0+vPjD
         zWLm2sYYy2Fw4rxLWz2s2sEr0FWW4dlMvI4rKDsSpIDIDpBjfISukr4SLtHZO4fDWoey
         6biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKH3uQ8Puz8euGKdPmXcZTSsxpYwOvRFhDCsc/Y1RfA=;
        b=xyPYCVcA71Fu6xIIeTUWolBXOzpJEPcfzQzZdd78nVFoIXgJvhUdKcS854iyaWMCtP
         6wK2jnLhz87/aKqQkkA39f2vPl20aQP2+wyqysZYqZ2FACNP1kseNO4GZD05f7+0yAfM
         YFdeSVzFokve0ewOgiO0xV4YOjzpjSMbWPq1jqliLU2+uyzaQL7ZxKamHcfLCNmk05O6
         XF/wDXq4bGGRv3MQf+Y7rj649oUYNQeC/2OUhEn6MXiUzlDinlFhadpyGLfAWtg7urRT
         pIB4Zw7ojx2hzI/0XwGJCg6vO93bd9Ed1PVFSl9+P0nsfy2y8GhttMuYw+wY1+fjieOO
         J5Uw==
X-Gm-Message-State: AOAM532iFqAsGB9W+bGNlDns51wi289yTMvNwUJt3i8OgpUae7JQFB9s
        YYFQj+x1lmWlVpJYCDvrStciVT2BjvyYnqzqgOZdVgpg1m5Rjw==
X-Google-Smtp-Source: ABdhPJzNq/xWEEkTrzDu6JFaon5G7sxSJDCPZCfvLv4WPSFmWgEn8jZCjTz0M7v0CDWtXYh8m4xiGKxCuD1SmP1fBsg=
X-Received: by 2002:a05:622a:4cd:: with SMTP id q13mr17781264qtx.180.1636736691682;
 Fri, 12 Nov 2021 09:04:51 -0800 (PST)
MIME-Version: 1.0
References: <20211112164432.3138956-1-sdf@google.com> <2a34cc7d-1d84-99af-715e-5865dfdcc72b@isovalent.com>
In-Reply-To: <2a34cc7d-1d84-99af-715e-5865dfdcc72b@isovalent.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 12 Nov 2021 09:04:40 -0800
Message-ID: <CAKH8qBupNbmxSOAC+SuyDfjVD7JotmtnXMsO4fE4yNKUOD=jUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: add current libbpf_strict mode to
 version output
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 9:02 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-11-12 08:44 UTC-0800 ~ Stanislav Fomichev <sdf@google.com>
> > + bpftool --legacy version
> > bpftool v5.15.0
> > features: libbfd, skeletons
> > + bpftool version
> > bpftool v5.15.0
> > features: libbfd, libbpf_strict, skeletons
> > + bpftool --json --legacy version
> > {"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":false,"skeletons":true}}
> > + bpftool --json version
> > {"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":true,"skeletons":true}}
>
> Nice, thanks!
> The following doesn't work as expected, though:
>
>     $ ./bpftool --version --legacy
>     ./bpftool v5.15.0
>     features: libbfd, libbpf_strict, skeletons
>
> This is because we run do_version() immediately when parsing --version,
> and we don't parse --legacy in that case. Could we postpone do_version()
> until after we have parsed all options, so that the output from the
> above is consistent with e.g. "bpftool --legacy --version"?

Oh, good find! Let me move some code around to fix that.
