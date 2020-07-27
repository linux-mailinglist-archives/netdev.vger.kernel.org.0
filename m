Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4C622FBF0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgG0WMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0WMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:12:30 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AEC22083E;
        Mon, 27 Jul 2020 22:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595887950;
        bh=0yrOceQ4ThJg8bvXzYV7sUock5Bm6u65FacsCAg9Sto=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EYVaR9hjuc3lX6dAyBEoFmST/hApD6sOnGavFziizdPggYn88O578HLq5Tl+i0VxF
         wcNkZlmjkgHf9n0Sg48UdPM9LsnSYJYH51ogOqvXM237UqeDxQBAkkOtH82INZHajR
         UMntsU7dNIfTTk+G7XlmV9qkRFEyd4182URWz2oU=
Received: by mail-lj1-f179.google.com with SMTP id f5so18949735ljj.10;
        Mon, 27 Jul 2020 15:12:30 -0700 (PDT)
X-Gm-Message-State: AOAM533rpdO2l1+t2dZxpnj/Gevol1C1Anfq+eyLb3EjveKpwzJby3v5
        wS7EIvebjbJNoLQJQ8Se31TpcyR+7DzIZKv73zw=
X-Google-Smtp-Source: ABdhPJyD8OEPzS+nHFNLJuhfUifHEzJvxGfY5o1OtZDdVVTYydgko05HFP8M++HOJsk7/OrNBLV1/TfyjmPfRyqTSAU=
X-Received: by 2002:a2e:7c14:: with SMTP id x20mr11171357ljc.41.1595887948418;
 Mon, 27 Jul 2020 15:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-3-guro@fb.com>
In-Reply-To: <20200727184506.2279656-3-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 15:12:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7OAhRMvS0wcDFCPqGO=UiN2k3vRCvPr3gH6QyJgY-MgQ@mail.gmail.com>
Message-ID: <CAPhsuW7OAhRMvS0wcDFCPqGO=UiN2k3vRCvPr3gH6QyJgY-MgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/35] bpf: memcg-based memory accounting for
 bpf maps
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

On Mon, Jul 27, 2020 at 12:23 PM Roman Gushchin <guro@fb.com> wrote:
>
> This patch enables memcg-based memory accounting for memory allocated
> by __bpf_map_area_alloc(), which is used by most map types for
> large allocations.
>
> Following patches in the series will refine the accounting for
> some map types.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
