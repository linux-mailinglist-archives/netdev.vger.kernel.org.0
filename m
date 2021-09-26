Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A32418B04
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 22:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhIZUfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 16:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhIZUft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 16:35:49 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067A2C061570;
        Sun, 26 Sep 2021 13:34:12 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pf3-20020a17090b1d8300b0019e081aa87bso11745483pjb.0;
        Sun, 26 Sep 2021 13:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Ah83D4oj0M/ZPbuDGbaur+I2bIn3iVKDa23KqXHEA1A=;
        b=MUvkwAw/J+JbJHhJu0xo7GVfmp6M77SaST9nJ6breN47wOtF87717R0gX2vViCAbOf
         2UMo0i0nB7RA+gplPcnYCTxgpY9MRr4XVIUpSnUnRI3yryx/I1sYtpM7h+bKRQyjwkdt
         4wv/a1DOrMaWzWDCvYTFDwEW/HOUeS8B2dRWh5LVttYTdIe+zB7Z5ni+Cq252p9in/Th
         lsGKyONyrqpCC/jUvEQ13sg+Xq6fBgx6bp7ZFUzSp+zqErGHPh/SxQGXb+dDhpl+qv2H
         qPad3VvWBEPYMyU9cPKGFxkkw4BDDjwKNFwsHOj5FZqFpL9WSQNR/A0SVkilXbuiGX9u
         fGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=Ah83D4oj0M/ZPbuDGbaur+I2bIn3iVKDa23KqXHEA1A=;
        b=eo96Dm8JetjvUPAw11cNbD7bGbsZgQQhOx8h2M2F0s/6xXOTYEQiUj/xY13X+HvIGO
         H3UdB5G2fqqFlkt8fwsLIoAdpAKHhIip/2tKhAUp0zbLbXoWa7NZaavSZlFhQFlKbirA
         7qWj+eTJpB7D2/L+3LvICoN096ecTIE7hCrS8lITZQ36RmXOaBY7N3f7ojP3AEtuHWKr
         X+uaY/f28Ja8f2Gg13NV88YE3l+Cu9PIy2zAGBrBP150FVPgYtlJenyVWWa5xVxkk92W
         35h/zmoBMHr1/lTlJQga6qSKq/omF+mWhMWQZTkiGAOLfFwXTQoBZmjG+0zf/VniYT9d
         yAJg==
X-Gm-Message-State: AOAM532/hDzT/NNtUnDT9XNapI5vLtJBCBGd+5/L6LfyBwPqum1iwbJ3
        c6WqBGZXCy1yIkdkugzZvsv7hAdt8yo=
X-Google-Smtp-Source: ABdhPJzaL2wRw+PRl+hEe0bgART6GV0PgRMVqbxvEXhkXyrpOuDbBHMYlMCn4gzSkKH3mxn0yJMbeA==
X-Received: by 2002:a17:902:6e02:b0:13a:41f5:1666 with SMTP id u2-20020a1709026e0200b0013a41f51666mr19411180plk.39.1632688452104;
        Sun, 26 Sep 2021 13:34:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3e55])
        by smtp.gmail.com with ESMTPSA id 26sm18727150pgx.72.2021.09.26.13.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 13:34:11 -0700 (PDT)
Date:   Sun, 26 Sep 2021 13:34:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     bpf@vger.kernel.org
Subject: Happy birthday BPF!
Message-ID: <20210926203409.kn3gzz2eaodflels@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today BPF is 7 years old. On Sep 26, 2014
the commit 99c55f7d47c0 ("bpf: introduce BPF syscall and maps")
introduced the BPF system call. I’m very proud to say that BPF has grown from a
Linux curiosity to a cornerstone of the way many technologies are built, but
that hasn’t come without a fair amount of growing pain. 

We’ve been able to scale significantly by treating the first BPF
implementations of runtime and tool chain as the reference, but with Windows
and a number of new tool chains and libraries coming into the picture, we need
to reconsider this approach to ensure that we avoid fragmentation and lose
interoperability. Specific examples of potential divergence are all over the
place. Libbpf equivalent libraries have been reimplemented at least twice in
golang and rust. GCC and LLVM have BPF backends that are similar but not
equivalent. There are implementations of BPF in DPDK and other user space
frameworks. BPF can run in the Netronome NIC and was prototyped in HW for
inclusion into general purpose CPUs. There are several verifiers (in the Linux
Kernel, PREVAIL in user space, and experimental ExoBPF). There are many JITs
for different architectures inside the Linux Kernel and in user space. BPF
programs can be written in C, Rust, bpftrace, and various assembly languages.

This diversity is a sign of healthy and rapidly growing ecosystem, but it leads
to a confusing user experience. BPF implementations compete with each other.
Despite books about BPF and pretty complete documentation at
https://ebpf.io/what-is-ebpf, developers and users complain that the
documentation is spread around.

In response, we collectively created the BPF Foundation and BPF Steering
Committee (out of the most active BPF developers) to strengthen the
collaboration. Moving forward, we must all focus on maximizing growth while
maintaining interoperability. While we will maintain the Linux kernel, libbpf,
and LLVM as the reference implementations, it's not our goal to force every
user to embrace each part of the reference stack. Hopefully the committee will
add a bit of formal structure to coordinate collaboration.

More specifically, these implementations define the de-facto standard for
various parts of the BPF ecosystem:
- The Linux Kernel verifier defines BPF instruction set, BTF format,
  map and program types, helpers, hook points.
- The libbpf defines ELF file format and CO-RE features.
- The LLVM defines BPF C language.

7 year old BPF is mature enough to put the standards before the implementations.

For example:
The kernel verifier shouldn't be a gatekeeper of new instructions in BPF. GCC
added SDIV instruction. It's not implemented by LLVM and will be rejected by
the verifier, but such new instruction has all rights to be a part of BPF
instruction set standard even when some implementations don't support it. The
BPF steering committee (BSC) could make such a vote.
Can GCC continue inventing instructions without ever talking to BSC ? Sure, but
once BSC agrees to this extension of the standard (whether it's a new
instruction or new C language attribute((btf_tag))) it will give a technical
direction to the whole BPF ecosystem. The creation of BSC hopefully will
provide implementations a way to collaborate instead of competing for BPF
users.

If you are interested in joining this collaboration, there are many ways to
reach developers in the Linux BPF community:
- The bpf@vger mailing list was an excellent place for the collaboration
  and probably should continue to be such a place.
- When email is too slow the discussion can move to BPF office hours
  (zoom call every Thursday at 9am PST).
- There are Linux Plumbers and LSFMMBPF conferences to amplify the reach.
- BPF slack channel https://ebpf.io/slack.

Linux, Windows, Rust, Golang, GCC, LLVM folks,
cheers to BPF birthday !
