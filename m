Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8DE1755ED
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCBIXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:23:39 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35454 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgCBIXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:23:39 -0500
Received: by mail-oi1-f193.google.com with SMTP id b18so9505399oie.2;
        Mon, 02 Mar 2020 00:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pBpc6wsvkGRBZXRQXOedwVEHxms2DjtLUfW89sueDZk=;
        b=okqs2mhjiUO8JIivGpHzGNh4pIuPDewCc5jHqCWNk3mXAICeBnBlgyw1pt/TYySTJs
         Cx3hvd6NaY/B4X5JiEoWRdQUdQqbiXUJmfQEaMPGr56Z0L98VUHaML0+nBxeiqv8L3uM
         gv1wXxEqjUa2MpkIENLLKCZzGEMKLAFN7XmzH8Nd56Sp3wzjl18T5W4BorZzv9T/ZdHb
         wZzhO/Us/Ivix09RsrYRZf6qjB27U/C0I1qZ2QnVWT5tyWv76UE9RN7WcpAfjQoPLNbx
         Rk9wYzYay8QYR6xTDg3+bm5m9foQxDMdcXcJ7fzOxNLVhx7yayVjVX2IomQTDi6G+rnw
         4HdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pBpc6wsvkGRBZXRQXOedwVEHxms2DjtLUfW89sueDZk=;
        b=L/w2PgaVMiUyHNaltMN5h31Y95QWVHuo2cYjKtIQYA4k7kIkhFNjDQijMv8ncVgdyD
         cd4KqaiTwiHa0DhA8WhP+2vscbuBboCIKdvhAS4Lx2+dLvZ8pK7wVdvQDYVjEJaPFQfA
         rFVjvh0LVBqlBbH/NHyCGJNnsflabEgv+oKenVeTkQTMGSKUgeTkrxpqV0pL8rtr7HFK
         827wOhfAlYpdManZ3bIaSbQf5EOidvsxUIVTUZEsDZPZ/qMsI09mba0e/+HyoxFz8t9l
         8r1uR16tIynq2GudzR1tX+RQEVLgXcoNwfBVuGZYEY3Jf0SDjwqbzCH7d90y9QcYCxqm
         SxaA==
X-Gm-Message-State: ANhLgQ3A62hESsgPwriQa6IGG67BCgi1WfBLHPTtf78oDNovnkvirvqB
        3twVwqNEwrMIwuXtfL6MJlGCiNKbuQBf8K5JgVv4OtDr
X-Google-Smtp-Source: ADFU+vumIHFWn/QAq65GRphsbc3M4dJy5+RcZogwja8X4eBJdfyeXz6KjxK3bWQwBTrbTcb+aEFPp1fRpnLNQpY2vVc=
X-Received: by 2002:aca:5109:: with SMTP id f9mr2280532oib.14.1583137416872;
 Mon, 02 Mar 2020 00:23:36 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com>
In-Reply-To: <20200225044538.61889-1-forrest0579@gmail.com>
From:   Forrest Chen <forrest0579@gmail.com>
Date:   Mon, 2 Mar 2020 16:23:24 +0800
Message-ID: <CAH+QybLZZwQ8QORPghOZtHyQABQRygGVF9h8i9wsCY6LnADuvg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/3] bpf: Add get_netns_id helper for sock_ops
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find that all three commits are acked by the maintainer. Could we
merge this to the upstream? Or do we have any other comments?


Lingpeng Chen <forrest0579@gmail.com> =E4=BA=8E2020=E5=B9=B42=E6=9C=8825=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8812:46=E5=86=99=E9=81=93=EF=BC=9A
>
> Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
> uniq connection because there may be multi net namespace.
> For example, there may be a chance that netns a and netns b all
> listen on 127.0.0.1:8080 and the client with same port 40782
> connect to them. Without netns number, sock ops program
> can't distinguish them.
> Using bpf_get_netns_id helpers to get current connection
> netns number to distinguish connections.
>
> Changes in v4:
> - rename get_netns_id_sock_ops to get_getns_id
> - rebase from bpf-next
>
> Changes in v3:
> - rename sock_ops_get_netns to get_netns_id
>
> Changes in v2:
> - Return u64 instead of u32 for sock_ops_get_netns
> - Fix build bug when CONFIG_NET_NS not set
> - Add selftest for sock_ops_get_netns
>
> Lingpeng Chen (3):
>   bpf: Add get_netns_id helper function for sock_ops
>   bpf: Sync uapi bpf.h to tools/
>   selftests/bpf: add selftest for get_netns_id helper
>
>  include/uapi/linux/bpf.h                      |  9 +++-
>  net/core/filter.c                             | 20 ++++++++
>  tools/include/uapi/linux/bpf.h                |  9 +++-
>  .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
>  .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
>  5 files changed, 92 insertions(+), 3 deletions(-)
>
>
> base-commit e0360423d020
> ("selftests/bpf: Run SYN cookies with reuseport BPF test only for TCP")
> --
> 2.20.1
>


--=20
Beijing University of Posts and Telecommunications
forrest0579@gmail.com
