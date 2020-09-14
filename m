Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C80269743
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgINVBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINVBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:01:01 -0400
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C2821D24;
        Mon, 14 Sep 2020 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600117260;
        bh=F3PEmIDj5PsX21DEDZlDPQZKaY42uEMzhiOeDRcD5kE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qHDu01Ep74IqEUFVflDvaWVFS/AXlHDFkVM8UfKuN216aGOUOgOEoEodgL5PToGjK
         KxtFM9RApBwVur20DYVSW9F78Un/LpzZgmpzIzJlCdaEQe5cZPlj95WFSqFHamg95j
         7YD/zLIqTW1QyxL51ntIE1vmMu7NH8iYuVRzhPnc=
Received: by mail-lj1-f171.google.com with SMTP id v23so922422ljd.1;
        Mon, 14 Sep 2020 14:00:59 -0700 (PDT)
X-Gm-Message-State: AOAM5314my43e3uhPcx+XCYUeStieHi47CUsTbb7V2GnxOH7FJo/pUwh
        exFZp1uz2nXPrfp1R1+ipNbI3eZmqEWpMhzLSiI=
X-Google-Smtp-Source: ABdhPJx7qdiVmj1sX187oBLQwliwXcyi7XyVZXjqUwGWJBMJBcFKfvZdMyg112+oyHMwCpu3E4TZfx7dpSSnbVt5VAM=
X-Received: by 2002:a2e:9c15:: with SMTP id s21mr5790370lji.27.1600117258411;
 Mon, 14 Sep 2020 14:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net> <20200911143022.414783-3-nicolas.rybowski@tessares.net>
In-Reply-To: <20200911143022.414783-3-nicolas.rybowski@tessares.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 14:00:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Qk8bea0efQspCOBbBaahgYt5eebvwvnGrA3xz9tw1Tg@mail.gmail.com>
Message-ID: <CAPhsuW7Qk8bea0efQspCOBbBaahgYt5eebvwvnGrA3xz9tw1Tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/5] bpf: add 'bpf_mptcp_sock' structure and helper
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        mptcp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 8:15 AM Nicolas Rybowski
<nicolas.rybowski@tessares.net> wrote:
>
> In order to precisely identify the parent MPTCP connection of a subflow,
> it is required to access the mptcp_sock's token which uniquely identify a
> MPTCP connection.
>
> This patch adds a new structure 'bpf_mptcp_sock' exposing the 'token' field
> of the 'mptcp_sock' extracted from a subflow's 'tcp_sock'. It also adds the
> declaration of a new BPF helper of the same name to expose the newly
> defined structure in the userspace BPF API.
>
> This is the foundation to expose more MPTCP-specific fields through BPF.
>
> Currently, it is limited to the field 'token' of the msk but it is
> easily extensible.
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>

Acked-by: Song Liu <songliubraving@fb.com>
