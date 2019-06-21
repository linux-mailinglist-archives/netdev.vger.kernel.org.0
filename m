Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7256F4EC8B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfFUPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:52:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39211 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfFUPwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:52:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id p24so5435995lfo.6;
        Fri, 21 Jun 2019 08:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6jHbjQhFsGSboMcXEv2aypVe6nJFvW447gHBP/AFK4Q=;
        b=c2J22ZC87kn/SQO+rhdDB4TYzUC5qbLxvlYAavtzeuMZN6csGbjpkzUtQBJBmybKpA
         ZSVwoya9QZBcoTvYF730I6AStqHkXRR96ix14o7jSOu6AZ3BaSe+IibiYSOp206HbcL3
         vkuRWpN265ax5VGRSIylqlFW+GPm0idz1Q30MZoMXN2rzCGeWexGMCUzL5QA+cEH1OpN
         hqJ3dTscMrcVxEq3P+FKmDaB5TChzjj3Qwa6NNM9PgpHUM5TW4nyR8UyaJpxHVv3DKV0
         HNJHMt6YrN6y13yTlTKYR9LyvRjQBYnQMagaYpt88kYIZIFvXNv+GMv+9SJQLqPpLnnf
         9c+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6jHbjQhFsGSboMcXEv2aypVe6nJFvW447gHBP/AFK4Q=;
        b=l1vyvzjH+ib/DqWogPxBsbyyPIPTcMp61jhntc8qTgtSU7pWAcfOv7S8BccFnnyLks
         BROB1Gq8cJQKJlzF7EEpbDLl3PlkbWm3IIriYn7pWLqITtzK5qRV04sxGtwm9drDhVkG
         A+voQpOdVpiJ+iP6teYe6Q88vHflxyUBfuTY2GboJxX6uZ4v1tq5jj2ARuv6WpMPTROh
         xpuzK9BRCU2BZF+QR4unkbSDLNeOWSJLS+rDmoQEfGFSGdHfaMtvU/tc80OL+PwFqTwk
         63mExRr74Xmy4sCMgwtYtxejPYnwTltCAwFOXuE6jmPVD36m9suP6KibnJ5/mq4amx5q
         s0xw==
X-Gm-Message-State: APjAAAXCTtDpZMjppuVgUCJoSMwqst42ScTyFA+Nq7AD2/1sA/b90FoL
        qwL/pca66iSEFJjehxOh6pW52jQmAimsiIy/iITX5aY+
X-Google-Smtp-Source: APXvYqwCKfpKNfY7+G+pRNyEGOBkbYuMksUm2ecnNnoWlHV9tR1ITXENB7C5PR45XoGphX07D/mq2DeGA0nsCdTdTAY=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr55323304lfj.167.1561132361960;
 Fri, 21 Jun 2019 08:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190618214028.y2qzbtonozr5cc7a@ast-mbp.dhcp.thefacebook.com> <20190621083658.GT7221@shao2-debian>
In-Reply-To: <20190621083658.GT7221@shao2-debian>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jun 2019 08:52:29 -0700
Message-ID: <CAADnVQ+frnYN6E5zyrNvbnhQ_XgvrEEtghiS7DOKoe6o_ErYRw@mail.gmail.com>
Subject: Re: 6c409a3aee: kernel_selftests.bpf.test_verifier.fail
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Andreas Steinmetz <ast@domdv.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Edward Cree <ecree@solarflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>, LKP <lkp@01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 1:36 AM kernel test robot <rong.a.chen@intel.com> wrote:
> # #340/p direct packet access: test22 (x += pkt_ptr, 3) OK
> # #341/p direct packet access: test23 (x += pkt_ptr, 4) FAIL
> # Unexpected success to load!
> # verification time 17 usec
> # stack depth 8
> # processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
> # #342/p direct packet access: test24 (x += pkt_ptr, 5) OK
> # #343/p direct packet access: test25 (marking on <, good access) OK
..
> # #673/p meta access, test9 OK
> # #674/p meta access, test10 FAIL
> # Unexpected success to load!
> # verification time 29 usec
> # stack depth 8
> # processed 19 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
> # #675/p meta access, test11 OK

Hi Rong,

the patch quoted is not in bpf-next/net-next.
This patch is work-in-progress that I posted to mailing list
and pushed into my own git branch on kernel.org.
It's awesome that build bot does this early testing.
I really like it.
Would be great if the bot can add a tag to email subject that it's testing
this not yet merged patch.

Right now since the email says
commit: 6c409a3aee945e50c6dd4109689f52
it felt that this is real commit and my initial reaction
was that 'ohh something is broken in the merge code'
which wasn't the case :)
