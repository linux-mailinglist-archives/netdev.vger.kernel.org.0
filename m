Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE7C1EB071
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgFAUs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgFAUs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 16:48:26 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C14A206E2;
        Mon,  1 Jun 2020 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591044505;
        bh=2f5CIiYjsvRo0oCNwVpqPmoLjGVxYJ2q8IYhP/wJ6z8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jYLYCUiawRX3kfw9MnLxJbXHLn/xQgOQGyMtqWwf1WmV3+IbUbgLJIptHV0IfCfcf
         UQhUcLNRE9jjEhmER23ws4Raqss7Qf/sLlUB31BlUA71Kiey6UJtmDkbr0hyBXPqHZ
         lQz2lzwszhm7eYtpaZHlmR6o1dP8hs/uGVHrKkPw=
Received: by mail-lj1-f181.google.com with SMTP id q2so9852221ljm.10;
        Mon, 01 Jun 2020 13:48:25 -0700 (PDT)
X-Gm-Message-State: AOAM531HkHg4bE1FArd9zLPoOU/Upguge8aQtvZC4LkxVjAgA5BrrwFK
        FRKKtzbLLVCnrZIkfMjN4XlxHBJ1CTbk/8dRUN0=
X-Google-Smtp-Source: ABdhPJzgy4EsoHzM3yZ7erVvmgxwMEHLjWPkxIowDwo4FmNcb/sBAokqx6fCrASwHiQzT4FcgNByh5iXQc5y0NJoyac=
X-Received: by 2002:a2e:99da:: with SMTP id l26mr4472972ljj.446.1591044503750;
 Mon, 01 Jun 2020 13:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
 <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
In-Reply-To: <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Mon, 1 Jun 2020 13:48:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Fnj2kU0z0hQjJgOgGeNT=ntM34hLzQgpg3JGWhRuGMw@mail.gmail.com>
Message-ID: <CAPhsuW7Fnj2kU0z0hQjJgOgGeNT=ntM34hLzQgpg3JGWhRuGMw@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/3] bpf: refactor sockmap redirect code so its
 easy to reuse
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 4:07 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> We will need this block of code called from tls context shortly
> lets refactor the redirect logic so its easy to use. This also
> cleans up the switch stmt so we have fewer fallthrough cases.
>
> No logic changes are intended.
>
> Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
