Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02813D8827
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbfJPFhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:37:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42008 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbfJPFhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:37:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so34306613qto.9;
        Tue, 15 Oct 2019 22:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifWWzUM+OPvSkjz/VHGuCaLoE+OCDB0c4pqApW6Yu4U=;
        b=pAg/kPfEqrondc8rRKwGmTJxKN/LY6uoDvUIx9MUOCIFSHzr/w8yrNzfdHTAn1Er1q
         pY7iHYvexTHEhboKHCQVW3E1LFjQmUKvdddi5+b+3lrkv3eGbQiT/t/2AtQejRZxqbqG
         uIMyt7xhcmVtp5aTwLKvTmcHcW6bv2CcYs+LcPnd/9riq9yPyt9hRlCtukSzcHGomVHG
         Ic6sd4zQbUUCSTqWC3TFie6124DsvyjJ43QQVvaGhsBQHluelp/qEXtSE2J+ZqoqfcNo
         yVStxzXeanELj6WlN2inNX8yfcLmG42rdj/1Z+4crXbAe5vBHUm/hZNpjTxyCulevaWO
         GRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifWWzUM+OPvSkjz/VHGuCaLoE+OCDB0c4pqApW6Yu4U=;
        b=k5tg8PfmCuhOJKZg9JVYYrpnxm3FgRzjvzQVNukwp5x9oiaEYZDntWHq2InOS/kFUE
         ST2vmg52QsAOND5StDc5D6v22p5Ux+VUPG0ZCz9gdqlDqYE2lxIS6wu1uXZXvzTX5h/z
         mnMwNj/gnavizEzqDTerno2AHDGqlTWokaZAHdrKR+W8jhvUbxXbAU43tCcveIjdzt41
         FwysIbfRPCLyXHnFcUtpjX4HA8qYGBejP+fNPcQxN+j4lXp3+53AetbiVoQy1L+n/2Ad
         kXgbhf/fa8u3MVivfyqyfrGuWl2e41FLB+KuFE8ZEdsk5br2dyV6wTg0WnZskbjJmWLF
         kQ/w==
X-Gm-Message-State: APjAAAUfaRLUEpdq07p0U+tQmaJqRzfDdeODNIWwaORT6hol7dNM6+jN
        TAS1GIHAtJwVRZIoRbw3FVre8PfU6uKstmTCF2Q=
X-Google-Smtp-Source: APXvYqwHQInIy1+kCPmhf9YMPHClikU8XDE/0kCbdlH7vZNC0YoJsjgguPtCOpUo5zJH7J1sLLZ/20zug2jNmUC0BD4=
X-Received: by 2002:a05:6214:134d:: with SMTP id b13mr39374514qvw.228.1571204239144;
 Tue, 15 Oct 2019 22:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032949.1445888-1-andriin@fb.com> <20191016032949.1445888-6-andriin@fb.com>
 <112cd221-7403-efe2-3375-bb9cc8140744@fb.com>
In-Reply-To: <112cd221-7403-efe2-3375-bb9cc8140744@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 22:37:07 -0700
Message-ID: <CAEf4BzZWESwpMymZSp7bW+701LEJrRCyydr9XpV86huT_vQRFw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/6] selftests/bpf: replace test_progs and
 test_maps w/ general rule
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 10:11 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/15/19 8:29 PM, Andrii Nakryiko wrote:
> > Makefile:282: warning: overriding recipe for target
> > `/data/users/andriin/linux/tools/testing/selftests/bpf/test_xdp.o'
> > Makefile:277: warning: ignoring old recipe for target
> > `/data/users/andriin/linux/tools/testing/selftests/bpf/test_xdp.o'
>
> I thought I can live with it, but no. It's too annoying.
> Any make clean or make prints it.

agree :-)

>
> Also looking at commit f96afa767baf ("selftests/bpf: enable (uncomment)
> all tests in test_libbpf.sh") that introduced this stuff...
> I think it's all obsolete now.
> test_libbpf* can be removed. test_progs nowadays do a lot more
> than this mini-test.
> Doing a test with clang native | llc -march=bpf is still useful,
> but at this shape of test_libbpf it's pointless to continue doing so.
> Such clang native test should be properly integrated into test_progs.
> For now I suggest to remove this extra test_xdp.o recompilation
> and remove test_libbpf*

ok, will do in v3
