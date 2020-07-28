Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E32D2301B8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgG1F3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgG1F3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:29:53 -0400
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A75120759;
        Tue, 28 Jul 2020 05:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914193;
        bh=NxGOqzNDCiGqo7SqhZy3eBT1mOYiIlD0oSMzOtfXMNM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nxlYItFLeTyNsqaWkPzykKvJ7xRkqieMF2gcr6i/bqHf2HWL2lOjeb9XOnfJPrGSm
         SISOcPdiF4ORXZYQmdP1oWFs+SxraKB91kh5gSkxGs80v4Ly0UL6Xin6/FNXAscYo+
         lIfjPCQSKJawWM5S15qGV5dvuWI+LoriOkJjJ3Do=
Received: by mail-lj1-f172.google.com with SMTP id f5so19721490ljj.10;
        Mon, 27 Jul 2020 22:29:52 -0700 (PDT)
X-Gm-Message-State: AOAM532K5IQGyTUXZh+6zbC9PJVX9d/NRFYqyMjAxARireK8KYvrPXn6
        in5+5HLVI6zn2BLj8GHIeuJkJahOLO43ov0NNfE=
X-Google-Smtp-Source: ABdhPJzJQzNwFaJz5OOPawmi78/m/d0Gxsk+lR/hcOh9JFVfFmwJrzO9J9tHHtGcg3MPyAcn9sVDd21DQwQ/Fvg4TOc=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr3261614ljg.10.1595914191378;
 Mon, 27 Jul 2020 22:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-15-guro@fb.com>
In-Reply-To: <20200727184506.2279656-15-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:29:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW45uYHPjcjc_k2C+DL6P9vxN3+ADNeAXK9Z8CdAbgtvDw@mail.gmail.com>
Message-ID: <CAPhsuW45uYHPjcjc_k2C+DL6P9vxN3+ADNeAXK9Z8CdAbgtvDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 14/35] bpf: eliminate rlimit-based memory
 accounting for bpf_struct_ops maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:26 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for bpf_struct_ops maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
