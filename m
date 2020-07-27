Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B13F22FC9B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgG0XHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0XHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:07:09 -0400
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE9A20838;
        Mon, 27 Jul 2020 23:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595891228;
        bh=oJWsmYH2tjYla9CDmKdomxEVucRBsCK2JPqp3IPB0AY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I4d1NLCtwW6PPqNpEpyh4hRfdPeEAM69Ch2OSCHEgJvfYO3mEshoq7Ak/F4Fb42vz
         kwqp4A5PGlx29sXCiJfpYtWCI6Qlw4sqVuhnTSAZP4qFT4q8/KR6iDZ92IT5tgInNI
         3IVcdGFCk95Qu3PJGFA87dJSevoFqFZhZ/LWw468=
Received: by mail-lj1-f180.google.com with SMTP id d17so19081178ljl.3;
        Mon, 27 Jul 2020 16:07:08 -0700 (PDT)
X-Gm-Message-State: AOAM532AUenRN3vzO51zz5JpMDeE8vclfD/3sY6PzdeBAW5wxWS0xi3y
        9tC7BZLY1KuH89QQvMK0RyJMkPqJt9NYkQpziPM=
X-Google-Smtp-Source: ABdhPJyuWzzvJyY6ehNJIX8VZ7MmH3UtQC2MbA9GMxDuwyNQQdQ330TKbXd2p//hr5e2Ss/J9B7+W9jmB4AjBhc0mj0=
X-Received: by 2002:a2e:8707:: with SMTP id m7mr10559896lji.350.1595891226833;
 Mon, 27 Jul 2020 16:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200727224715.652037-1-andriin@fb.com>
In-Reply-To: <20200727224715.652037-1-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 16:06:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5qvGvSCEc_1LxrJgN3Ajfv8GG2EwYvJSPcTcpQz6MRFw@mail.gmail.com>
Message-ID: <CAPhsuW5qvGvSCEc_1LxrJgN3Ajfv8GG2EwYvJSPcTcpQz6MRFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_ringbuf_output() signature to
 return long
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 3:58 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Due to bpf tree fix merge, bpf_ringbuf_output() signature ended up with int as
> a return type, while all other helpers got converted to returning long. So fix
> it in bpf-next now.
>
> Fixes: b0659d8a950d ("bpf: Fix definition of bpf_ringbuf_output() helper in UAPI comments")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
