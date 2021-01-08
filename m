Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC02EFACA
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbhAHVzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:32820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbhAHVzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 16:55:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B84523A9C
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610142909;
        bh=Hk0CcdSqbF4KFVlSIMVJ6KCBS/vMpc81zH5BVzJpxB4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sUyi/G3228fvcGAHC1W7uSIvfaGNFkdpDOXRkwO3ejspiyHwKJsv5v5UwbADIoJkx
         1aH+vekX5zfW8rF7e/a+CmR6g6uw8Ot8M2VclVHcEwHWKDWIqSFuKMiAP/iuE6fPvh
         bQsI2EooUN8xL2IB8Kk3DcpHg+2YZyNfN0AXeTuCnX0hVS9VhqzImw2IxICJTIDzKE
         iQzBOidX76w9OrP1lBrVbIKLu5M0qcDQza2+7ocoExaSTsBDqgqXran3FdRWhsSbz/
         qW/PeiNfKzslNnUMdC6Q1u/7nZ9wO1YDXSZL78JoPOo1cx1jZEWjNaVrzWV4t0SJWj
         mcTMt9qewth4A==
Received: by mail-lf1-f54.google.com with SMTP id o10so15516416lfl.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 13:55:09 -0800 (PST)
X-Gm-Message-State: AOAM532Qx05/ASycPA49oHl4EPWkXKmcF5JeXkgVrDdJvFH0pWg/S+BF
        y/XHMChw9PWNQmAnvbBGRo5f7ENY0j1PyRhfUMXs8g==
X-Google-Smtp-Source: ABdhPJxHeVaZsDHkpkEu6hFJwhbFcv8avKT4mhcAQSev5tIWjsHZ9IgmwDJ+7RoulRb5BCyekcuCBBLYlkzXAidWCOo=
X-Received: by 2002:a19:5ca:: with SMTP id 193mr2552974lff.375.1610142907841;
 Fri, 08 Jan 2021 13:55:07 -0800 (PST)
MIME-Version: 1.0
References: <20210107041801.2003241-1-songliubraving@fb.com> <20210107041801.2003241-3-songliubraving@fb.com>
In-Reply-To: <20210107041801.2003241-3-songliubraving@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Fri, 8 Jan 2021 22:54:57 +0100
X-Gmail-Original-Message-ID: <CACYkzJ4pvmMLx9NG3c3PHiU_nyYZZDuFkTC48GDezPA3onJZJQ@mail.gmail.com>
Message-ID: <CACYkzJ4pvmMLx9NG3c3PHiU_nyYZZDuFkTC48GDezPA3onJZJQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] bpf: allow bpf_d_path in sleepable
 bpf_iter program
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        linux-mm@kvack.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 5:23 AM Song Liu <songliubraving@fb.com> wrote:
>
> task_file and task_vma iter programs have access to file->f_path. Enable
> bpf_d_path to print paths of these file.
>
> bpf_iter programs are generally called in sleepable context. However, it
> is still necessary to diffientiate sleepable and non-sleepable bpf_iter
> programs: sleepable programs have access to bpf_d_path; non-sleepable
> programs have access to bpf_spin_lock.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: KP Singh <kpsingh@kernel.org>
