Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C87269473
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgINSJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgINSJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:09:05 -0400
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 567CF217BA;
        Mon, 14 Sep 2020 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600106943;
        bh=CfRmeNK8D5eIpf04wtkC++/Brt6HDeUzFDnNUyWFqtM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t1XNYlyclMMvW/+rTr8PGPfHUPz3WdRkEIeELx1JxILygNT5C7WqC+pdjAuSK3au8
         eyMoOqOrU374tGQ/0uBes33aikMbBd+A+fzfIvMiSjFlSmMb4Z5Uz319034UTYXUyH
         nFI4wok2RyhvcrbfJV3qrtlxyLCLCoQL6Xlyrj9s=
Received: by mail-lj1-f182.google.com with SMTP id b19so447716lji.11;
        Mon, 14 Sep 2020 11:09:03 -0700 (PDT)
X-Gm-Message-State: AOAM533BvotRhoysHJZ9B2UQdrXCP5A4+VEMurMy9ElUiTyGIUBCvA6p
        xaLjKfXH6pZPJjPsdgS5K2ZMsZjujz/zozAfQHA=
X-Google-Smtp-Source: ABdhPJyhFwXcQhjr/Dwv56XqnO5N8lffzd+39atnp5aKkQKEMYjHJGZQglkDrc4oH2F8b9Ofd32Fp+XwQqhWORmLfMw=
X-Received: by 2002:a2e:9c15:: with SMTP id s21mr5578169lji.27.1600106941660;
 Mon, 14 Sep 2020 11:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net> <20200911143022.414783-5-nicolas.rybowski@tessares.net>
In-Reply-To: <20200911143022.414783-5-nicolas.rybowski@tessares.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 11:08:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5j0i0fk+XBun=v15H+-TvKjTF=XUhueuf30Hgp1=dESQ@mail.gmail.com>
Message-ID: <CAPhsuW5j0i0fk+XBun=v15H+-TvKjTF=XUhueuf30Hgp1=dESQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] bpf: selftests: add bpf_mptcp_sock()
 verifier tests
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 9:46 AM Nicolas Rybowski
<nicolas.rybowski@tessares.net> wrote:
>
> This patch adds verifier side tests for the new bpf_mptcp_sock() helper.
>
> Here are the new tests :
> - NULL bpf_sock is correctly handled
> - We cannot access a field from bpf_mptcp_sock if the latter is NULL
> - We can access a field from bpf_mptcp_sock if the latter is not NULL
> - We cannot modify a field from bpf_mptcp_sock.
>
> Note that "token" is currently the only field in bpf_mptcp_sock.
>
> Currently, there is no easy way to test the token field since we cannot
> get back the mptcp_sock in userspace, this could be a future amelioration.
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>

Acked-by: Song Liu <songliubraving@fb.com>
