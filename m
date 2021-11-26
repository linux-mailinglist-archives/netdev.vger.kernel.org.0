Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150E945E7FE
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359008AbhKZGpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358877AbhKZGnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 01:43:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B12CD61175;
        Fri, 26 Nov 2021 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637908818;
        bh=R8BcdlnGOV17J+i8TfH9xl2GNIZT02bu+liL9a4FvGc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hk5zLepPLv9dJ5mT6YHh4vBQtFwhIF7inPJbLZTymoC2J978TIwgZUJECJ4lQNCAK
         YWBO9eRwcBqezSznhpBTF7M2IGQwvSMKdzhnmatvvd8Rc7hwgFPzDAiSJFReIIaC//
         qtcpD3JIfSV/12Oo32R2Fv5KPtE8Zxefs4IpQ9ChA9mNvzBjvqNy1jXtdXAfo0bZif
         og0G1glDEgKCuNXaXsu/XdZvmWoOEth7C8Ks8sVqgyPg1euU8PnVgqg8eFpyVE81Zg
         F/5yDXMNTdhAFHZhXn2S9VS515HQUK7cnNJqUFGz5cTckWGxd7NnX7Iz/CuiO1Rbd2
         5w/N113bZE0vg==
Received: by mail-yb1-f174.google.com with SMTP id e136so17568615ybc.4;
        Thu, 25 Nov 2021 22:40:18 -0800 (PST)
X-Gm-Message-State: AOAM530H+PSSxNfvGOPd0dOs0sDiQ209AU/2UE27fGonfiKFJ+Pq/3S6
        BXY58Tb6Rz4k7nRtpECPWNbwFyYw5mO5jpKP+0Q=
X-Google-Smtp-Source: ABdhPJzr9MeakRUihP6iIzw98eiuQdgyWskgVa5nR1CkstcUUcVbutESlN6Er2jyaSiUqqDuGpMbn9BS6Fm9fyF6o5U=
X-Received: by 2002:a25:344d:: with SMTP id b74mr13159430yba.317.1637908817916;
 Thu, 25 Nov 2021 22:40:17 -0800 (PST)
MIME-Version: 1.0
References: <20211119163215.971383-1-hch@lst.de> <20211119163215.971383-4-hch@lst.de>
In-Reply-To: <20211119163215.971383-4-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 25 Nov 2021 22:40:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7U-yYZBhA3HfOMWT5LpX-gQBcOWvMsVXWEYxXk2EAOXg@mail.gmail.com>
Message-ID: <CAPhsuW7U-yYZBhA3HfOMWT5LpX-gQBcOWvMsVXWEYxXk2EAOXg@mail.gmail.com>
Subject: Re: [PATCH 3/5] bpf, docs: prune all references to "internal BPF"
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 8:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The eBPF name has completely taken over from eBPF in general usage for
> the actual eBPF representation, or BPF for any general in-kernel use.
> Prune all remaining references to "internal BPF".
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <songliubraving@fb.com>
