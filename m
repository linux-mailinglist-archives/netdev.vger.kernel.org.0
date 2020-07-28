Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A364230272
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgG1GOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgG1GOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 02:14:24 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E4E21883;
        Tue, 28 Jul 2020 06:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595916863;
        bh=ioJmqaO9XNZqa5IlBHxL0G6zBHKqklvtRZ81UaEUHuo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Uwx29jxypXXi/BuojC3h3Rv9bPiPORAzF9oPljHFZ0WFh0lrH01CXmwIkfv75msnb
         tQJYZdhoAWapuZoxPYoeEnQfs3cJZSPezzzzWClYklAStwt3wo8eitZzDOc9Jw8Y7P
         ogKbK68lziD/h8D689iDHYWWCu5GQnJj7XIQzpFU=
Received: by mail-lf1-f51.google.com with SMTP id i19so10335480lfj.8;
        Mon, 27 Jul 2020 23:14:23 -0700 (PDT)
X-Gm-Message-State: AOAM532wtDFJdNQHmx0+2Jxh/UGdmy5dcbsVmWuhniqgG4LZqsWwt0G6
        V031b5DkA1nwZ5kiLYZWvNi0kQEGG8pmvTpL7no=
X-Google-Smtp-Source: ABdhPJyRMzEFvfI34My7ASv3q8pbzxSq1wuMSB+5Q6orPAqRxZm4GzeqbfqUxJpGtF8fEWFul2WFyHsGm3Uy2CtqNIc=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr13301902lfr.69.1595916861800;
 Mon, 27 Jul 2020 23:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-35-guro@fb.com>
In-Reply-To: <20200727184506.2279656-35-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 23:14:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6PTtAoFJ97hH2GApbW6qiLta3rwLLqGZ25SfV48gLjxw@mail.gmail.com>
Message-ID: <CAPhsuW6PTtAoFJ97hH2GApbW6qiLta3rwLLqGZ25SfV48gLjxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 34/35] bpf: samples: do not touch RLIMIT_MEMLOCK
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
> Since bpf is not using rlimit memlock for the memory accounting
> and control, do not change the limit in sample applications.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
[...]
>  samples/bpf/xdp_rxq_info_user.c     |  6 ------
>  samples/bpf/xdp_sample_pkts_user.c  |  6 ------
>  samples/bpf/xdp_tx_iptunnel_user.c  |  6 ------
>  samples/bpf/xdpsock_user.c          |  7 -------
>  27 files changed, 133 deletions(-)

133 (-) no (+), nice! :)

[...]
