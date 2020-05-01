Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969071C1C61
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgEAR4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729612AbgEAR4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:56:44 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF74C061A0C;
        Fri,  1 May 2020 10:56:44 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g10so4418908lfj.13;
        Fri, 01 May 2020 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MTmjXd+sgPvsBU6TFoEwOV3vuK1F2ZIvmzsdRRV9hb4=;
        b=fl2Y9MGg8I3m7eD8X4tSFNsqtnTPs1zV6Jf0gidhU5qbshn2fVCD8N3r3S6n16O/9w
         orNqTyHu3LRlOP2XkmNY+wpZORKmUwhsq5xCu9usuEI9PfyMRy5KTRQ1WYnZy0fRMyg7
         +o2vFT65eTLb25dmglvZVIGyLLVUy1ihJnBrAqX031DCp8/3u/X9yNKBPsVDColcy8mO
         eTWvYce4kauO1nwaNAoIMAAA9OSShEOBfES69HPUwNfP0/OKZCOrYRGCL9I0ez6yQCQP
         BWIOqtai8FE4BbzyKvmuz9pChbDKHP/eIOs9NmoCSxUnoUzfYo9SwKZSP923VJWqye+4
         FVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MTmjXd+sgPvsBU6TFoEwOV3vuK1F2ZIvmzsdRRV9hb4=;
        b=qHNBNCgAUr65XwI9WZAv6PpWg08j0hU9mewuSuC3ZumFhzoxHZ8RbJorvmvGZHWtXa
         cp8qoIvkcY8GGs03P+fhHrntz19enBNyTi1tmgl5eHqrMf9WYsBIykyzlma8vmXuV8/S
         VTfdspp7CsF5Ewsrx+2vL/Fu42RVJuVSsbKKG0GpOaFNsDDsDOzk8BckkPd2xAfRUjCk
         Q4yVKycClHuHaGr7WpiJk5KNvuCBvXksc8WArkyE/ZIpviWGgSPlQ7Ti+LbSfbCINAm2
         28NXYVLYITpIW1Q1QXRal/vkV/TQrT1V5nNL4b1VlJ06Rjoh+YpCdAV22nUzRIvAtHFD
         jv9g==
X-Gm-Message-State: AGi0PuYHI35Fdi85dZ62ozftJYNV5Q2f50D34JSdGmjiRg0qyu43TOZY
        in0AA1My0x2MooOWqr2q1/nvTdgT+/ok2eENN/k=
X-Google-Smtp-Source: APiQypKWHuJWTULKVV7x/WBO/lPFPFcX7XdjYcivCJszSyik/Eev46q+TQ5PrYuuwiR+agUi1VLYu3RaxlcCA5TlopM=
X-Received: by 2002:a19:505c:: with SMTP id z28mr3247010lfj.174.1588355803010;
 Fri, 01 May 2020 10:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200430071506.1408910-1-songliubraving@fb.com>
In-Reply-To: <20200430071506.1408910-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 1 May 2020 10:56:31 -0700
Message-ID: <CAADnVQJi9jiB9M7D8vbVAY3T+kb1hFgF373PdGQKtLqPs=5p=Q@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 0/3] bpf: sharing bpf runtime stats with
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 12:15 AM Song Liu <songliubraving@fb.com> wrote:
>
> run_time_ns is a useful stats for BPF programs. However, it is gated by
> sysctl kernel.bpf_stats_enabled. When multiple user space tools are
> toggling kernl.bpf_stats_enabled at the same time, they may confuse each
> other.
>
> Solve this problem with a new BPF command BPF_ENABLE_STATS.
>
> Changes v8 => v9:
>   1. Clean up in selftest (Andrii).
>   2. Not using static variable in test program (Andrii).

Applied. Thanks
