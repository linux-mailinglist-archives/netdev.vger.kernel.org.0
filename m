Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA66622FE10
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgG0Xf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0Xf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:35:29 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D38D2070B;
        Mon, 27 Jul 2020 23:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892928;
        bh=MDZ7lLfbWVYaUmNwmDlo9SAQvLSrljgq4d+0AZEmT6E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nI0crXSJJab9r4hfPBToRy3uxAdfJaRN+jgI6ENRNxKLd8E20J3jYFHVq9NUlgIvm
         CfAx/dg3WNJ6CbdBF8ZCNIxevkW6jCs1RDJsHi0QwvlwZFN6qWMXxOcvHzgBWMXFu4
         FhDwzDy9kIjRjKBi2gvRlt+j1I1WUi2HSw/s0tIg=
Received: by mail-lf1-f42.google.com with SMTP id i80so9940809lfi.13;
        Mon, 27 Jul 2020 16:35:28 -0700 (PDT)
X-Gm-Message-State: AOAM533Lyvl0JsTa1xR9INXS7j2CQS7MCDDnlMzHAJPNjfzunDam7oRS
        si13T/oefIT1mqAsqjj935oa0A1HB7ArnwQiIlU=
X-Google-Smtp-Source: ABdhPJxei2hmBmnqi2yQaVZuziq1AimM5UhakwHq3l0Hyfhmm7uGzTgsYMcwR87FnEl78tOADBzL8L+Tvg6v9qcfVJ4=
X-Received: by 2002:a19:7710:: with SMTP id s16mr12917059lfc.162.1595892926792;
 Mon, 27 Jul 2020 16:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-7-guro@fb.com>
In-Reply-To: <20200727184506.2279656-7-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 16:35:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6dY3CNiXK3r5UY6TXDNTSjQkD_2OJS2x+boJTyF1k78g@mail.gmail.com>
Message-ID: <CAPhsuW6dY3CNiXK3r5UY6TXDNTSjQkD_2OJS2x+boJTyF1k78g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/35] bpf: refine memcg-based memory
 accounting for devmap maps
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

On Mon, Jul 27, 2020 at 12:22 PM Roman Gushchin <guro@fb.com> wrote:
>
> Include map metadata and the node size (struct bpf_dtab_netdev) on
> element update into the accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
