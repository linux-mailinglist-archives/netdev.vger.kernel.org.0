Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E67628403F
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgJEUEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:04:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:34787 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgJEUEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:04:06 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1My6xz-1kaqMd3GVr-00zWYu; Mon, 05 Oct 2020 22:04:04 +0200
Received: by mail-qt1-f173.google.com with SMTP id q26so5491620qtb.5;
        Mon, 05 Oct 2020 13:04:04 -0700 (PDT)
X-Gm-Message-State: AOAM532EtAeC5I6DAStJQMyuLwhcDJWHMFQi9+gGca33oHdiqs99MWj6
        2Znd3RAKx+M9Xkg9zlwgAsCbwIrl/rRLyiz0B/I=
X-Google-Smtp-Source: ABdhPJzRHa8pk/FFvESpj+qFo0eHK+5D8ySj4hzAie0Biq5vtin25V5oB0EHJ7egA1kRq9ETWIvxczZP5mr18QYmZ9A=
X-Received: by 2002:ac8:1ba6:: with SMTP id z35mr1607120qtj.204.1601928243553;
 Mon, 05 Oct 2020 13:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch> <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
 <20201005194913.GC56634@lunn.ch>
In-Reply-To: <20201005194913.GC56634@lunn.ch>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 5 Oct 2020 22:03:47 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1qS8kaXNqAtqMKpWGx05DHVHMYwKBD_j-Zs+DHbL5CNw@mail.gmail.com>
Message-ID: <CAK8P3a1qS8kaXNqAtqMKpWGx05DHVHMYwKBD_j-Zs+DHbL5CNw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:091A2ya5H90JNy8I08QrsMLH47xCuJZ8v6k4BsqmG8D5FEVFO80
 j+bEL7GuzXYS9eUsNMZZN2zxIOfiVU0TR8k8xeUXfy+gQX5AYB4BcCmBsbw9DHHIKJYRZEv
 kaN97kKed0WceDJj1daEm8bIKFhsSBROYYw70zV0b8hXIga0cE4s6nVPqhy9HSDORLx+BjA
 1INjksjxIY5qjVH6wZ6Fw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dy/mO+HP9UU=:O5WW7HvRFJoKsRCbqSE3UX
 YMGIHzyHVlILQ1eEsEZnFEirZ/7hNhIEI7VAtSwQzQT1YMwHTmIb8GT+l1IorLATfsDmuThTO
 ojgoazJCdTIGSQd1AFcrR3K8d9L8vp+s02gkStMo7TqaYER8Ij1qlPCpjH0esbe9vl1iEdzHI
 WCKQOBQfgqafeNyz76KB+sMVhUbU3lH2Of9tu9mtSOEoaZ1kwOV6QgkQw5vSJQstjatygyp32
 gMiR4mqmHsbMnvIJpxirZlCRKLnb1SvjcslpVxDRuXT7RACOoAtVjc8pC9wkI4PAXFArSrw6N
 ZSL0rI6fPW8ciRj2UjEQr1RrvvmV4MokEZJ43zGEyXeUAQBPJq6jQBER/ESNrUIoE9weot4HQ
 fq86u1G0SRUJJAo+4+su9syJTc0IctsGv4ZEfgzWatJ15NiQPN0Pr+EkQaqGwRf7UFRrb0f78
 1cVYvetPhqPopw8ucDLOk5H35VWZFcmT2yFC4UMRDNwzBP7nmIgVD+tMy71EOWrfA7J68s8ai
 3IYlTnLukdGqbfRzp08M9yFIPe3WGmLHn801Qlief/n+VVgJ0iyeGeQaXZ4XeXoHMELD7Tz1t
 fySKoE0qcJHiTrR2CqdB7GUoNLERG2zXcYYxpDqzr2schNIZgIjQNbk7kMoT5YjepKEr/bORN
 +gDrgkR81a27GIhezZ7gEwwahMsgvTV1iKPMCKG5Ss8Sa7byXWDILWqOF/7LFwDhcItnjGfce
 U7MsWjeRkZiaK29tRFjLpMlsIs5oU+cgVPEqKZ2NBJQRirYdtTF0SKu/kRrCmI6bcCgvAn1Yi
 csY7ESXesDKAYF81LGdrSmD8iQ70fGIai54aMyz6Fl+w0uOUzNfPkxQ82qsry1sNsXVjTIG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 5, 2020 at 9:49 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Sorry, to be more specific about my concern; I like the idea of
> > exporting the W=* flags, then selectively applying them via
> > subdir-ccflags-y.  I don't like the idea of supporting W=1 as defined
> > at a precise point in time via multiple date specific symbols.  If
> > someone adds something to W=1, then they should need to ensure subdirs
> > build warning-free, so I don't think you need to "snapshot" W=1 based
> > on what it looked like on 20200930.
>
> That then contradicts what Masahiro Yamada said to the first version i
> posted:
>
> https://www.spinics.net/lists/netdev/msg685284.html
> > With this patch series applied, where should we add -Wfoo-bar?
> > Adding it to W=1 would emit warnings under drivers/net/ since W=1 is
> > now the default for the net subsystem.
>
> The idea with the date stamps was to allow new warnings to be added to
> W=1 without them immediately causing warnings on normal builds. You
> are saying that whoever adds a new warning to W=1 needs to cleanup the
> tree which is already W=1 clean? That might have the side effect that
> no more warnings are added to W=1 :-(

It depends a lot on what portion of the kernel gets enabled for W=1.

As long as it's only drivers that are actively maintained, and they
make up a fairly small portion of all code, it should not be a problem
to find someone to fix useful warnings.

The only reason to add a flag to W=1 would be that the bugs it reports
are important enough to look at the false positives and address
those as well. Whoever decided to enable W=1 by default for their
subsystem should then also be interested in adding the new warnings.

If I wanted to add a new flag to W=1 and this introduces output
for allmodconfig, I would start by mailing that output to the
respective maintainers.

        Arnd
