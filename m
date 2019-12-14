Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2511EEF8
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLNABL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:01:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39160 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLNABK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:01:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so257798pga.6;
        Fri, 13 Dec 2019 16:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xVDLFOdiYuZ2gWWU6G2SU+PR3kNuoyF0CB7hOhKkK3A=;
        b=F4zrlZ58NaT3p+QGxOYglWwmbHf95PFxUF3jKGiP+Hy1TT5Wyzi6PfMuvFASMvRo4T
         DHKvRwj70bh/7djIsvVq+csuJvvGKMr3dA5JSWjLEvdvUOycRC4ReT5iRTPNGyanDZQV
         WGGzAbPezA8CjN80dxX7+gfQ45JUuKKpSvzmlnG5FY+OAveJbPuKieA5/3JAMh2+c6RF
         iRdg/cau7+cvywdzXB+/oYKEMHtCS//I1mPgN8enVZ4qnQmLNHoPNve3Niw3DnqNZ/IZ
         KEUSi6z8A/8zQCaEAe6ehoKadPNwXdq1gNKg+QKV3ZP9RpHkqArQ3cNX5XV+nmcgcDkq
         HyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xVDLFOdiYuZ2gWWU6G2SU+PR3kNuoyF0CB7hOhKkK3A=;
        b=D+QmyF+vtqu3t5rQQIMQpv9nV6ZFhq65euEia7KM+tVE5HESQJFTVsUV9bnt8S9G2e
         ffc/+qvXVtTxrD7zbq1NT7Ez0d8XcQPzkpUTh1Yfb61hUUQVteBuOqKufqH993Pok38S
         ODPFmuwVzSj+I6GAvtmY5/BLneJyM8D/Sd52A9wci/aUlU/XaW8b4Nx6wN1jGvW5XVpF
         H5BbUiCreTHSMI12/4XMqt0ycMhT8usao3ViX5i9Y6Neo31V2Nky8sVHjEgP3uCb1nSZ
         9Q5HG8GUChMC0QtqfPifIQUFC/hizJA34aWU+7Nzk13xKIaMDTsZUuHCfBK86gvG6csR
         pP3A==
X-Gm-Message-State: APjAAAUYnm7QPZjkGGTIzBBtJI0B8gCautMeb93q85Cverlp8HbZXg64
        YuZnaRekFZ7PHI+0X3JQ1vg=
X-Google-Smtp-Source: APXvYqxMhnKdtH5xdRAK3T+9o4+yeSm4AJNU/TfGFBtC1Awll2SN4OHp+KZN27j7ZzaNnhV3J7Gz2A==
X-Received: by 2002:a63:e545:: with SMTP id z5mr2416894pgj.209.1576281670063;
        Fri, 13 Dec 2019 16:01:10 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::de66])
        by smtp.gmail.com with ESMTPSA id z26sm11792382pgu.80.2019.12.13.16.01.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 16:01:09 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:01:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 15/17] selftests/bpf: convert few more
 selftest to skeletons
Message-ID: <20191214000107.rvprwvpifsbtoruw@ast-mbp.dhcp.thefacebook.com>
References: <20191213223214.2791885-1-andriin@fb.com>
 <20191213223214.2791885-16-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213223214.2791885-16-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 02:32:12PM -0800, Andrii Nakryiko wrote:
> Convert few more selftests to use generated BPF skeletons as a demonstration
> on how to use it.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/fentry_fexit.c   | 105 ++++++------------
>  .../selftests/bpf/prog_tests/fentry_test.c    |  72 +++++-------
>  tools/testing/selftests/bpf/prog_tests/mmap.c |  58 ++++------
>  .../bpf/prog_tests/stacktrace_build_id.c      |  79 +++++--------
>  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  84 ++++++--------
>  5 files changed, 149 insertions(+), 249 deletions(-)

Another nice diff stat.

