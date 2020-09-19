Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A9C271109
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgISWWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgISWWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:22:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C75C0613D2
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 15:22:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r19so4903686pls.1
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 15:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=25gVfK2bGDr534LWfZ/pQ4shMLoyA8XjkGlFCfd9UIQ=;
        b=EY9RaFhKJvXZJRe9JFZEmj/lrRJqtPj6jNB3uuL8Asw+3z3hL8ojgYDOBxgCTI3nk9
         /mXxtqUMYM7Lwl0JgYFAozO/o74Ybc5I1+WhDC3iRbQpOEwdgChJfXvUy9LaiX/RnQRf
         p/J0xsjYVG4oqNtf24952lDJD0ziSd0wiVT/i0R8ihNenTSwy/mXNvVIx+wshhqobcUy
         5EicG48utPjw3drDSP4fcvdYEf263LYbKCqq5wRH96dLaukxQtxTbM+CqP9ZHn/W3xRY
         8AFACdo1jBBh0ZpNH8dhEU0zBCFGmtnY/LeHs/0y17jDB1ByiLtkNkIHMFbVGhXPT7kd
         OVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=25gVfK2bGDr534LWfZ/pQ4shMLoyA8XjkGlFCfd9UIQ=;
        b=ePjmjkM0RFMCEcN0VBTCHG7Xqo8xiMpucD9CZ5j6Oudt/gfoGa6IlJbDnC3HhbVbWt
         Ok+EngM2Kl/8rfYa6Xc5HpgCxz/86Rbw2/47fWmgkBaufQN0jeDBqPB9kcX0/zeusyzx
         O6A7VvcwIqq1VgPU94FpcEw2UG4pJVcNFazLSOBSjeJ5aVp0pdpAMJaNH6utdasjfoHW
         4bUqQy9En63J8SJZfe74nEm/W8zCZSKzPToQNKe7OXPjvIC+cogsGnjVwgipRcKWDabS
         sZPp+ew63POV5hZr7d8RAFN0a3iSHu/0J3mOqNeu29YXEwSkV848Rxse25fIVGFNYDgU
         7gkw==
X-Gm-Message-State: AOAM530kbW0JQkkel5fqG7J3poVEAq3LrdIZfDbsUg6YsR37XrhnzUre
        MO8YvJDIPrkHVF1CBRvRMQUxtg==
X-Google-Smtp-Source: ABdhPJziI+9RTM4Q+0EM9+8+2xFKIE2ZrEYxvbFrrOPerUdpGlrHlMuO11hqWffBHcUb5BpNHvdsyg==
X-Received: by 2002:a17:902:ac97:b029:d1:f367:b51a with SMTP id h23-20020a170902ac97b02900d1f367b51amr16629268plr.20.1600554127472;
        Sat, 19 Sep 2020 15:22:07 -0700 (PDT)
Received: from localhost.localdomain ([2601:646:c200:1ef2:e9da:b923:b529:3349])
        by smtp.gmail.com with ESMTPSA id p4sm6588471pju.29.2020.09.19.15.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 15:22:06 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Date:   Sat, 19 Sep 2020 15:22:04 -0700
Message-Id: <D0791499-1190-4C3F-A984-0A313ECA81C7@amacapital.net>
References: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
X-Mailer: iPhone Mail (18A373)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Sep 19, 2020, at 2:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> =EF=BB=BFOn Sat, Sep 19, 2020 at 6:21 PM Andy Lutomirski <luto@kernel.org>=
 wrote:
>>> On Fri, Sep 18, 2020 at 8:16 AM Christoph Hellwig <hch@lst.de> wrote:
>>> On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
>>>> Said that, why not provide a variant that would take an explicit
>>>> "is it compat" argument and use it there?  And have the normal
>>>> one pass in_compat_syscall() to that...
>>>=20
>>> That would help to not introduce a regression with this series yes.
>>> But it wouldn't fix existing bugs when io_uring is used to access
>>> read or write methods that use in_compat_syscall().  One example that
>>> I recently ran into is drivers/scsi/sg.c.
>=20
> Ah, so reading /dev/input/event* would suffer from the same issue,
> and that one would in fact be broken by your patch in the hypothetical
> case that someone tried to use io_uring to read /dev/input/event on x32...=

>=20
> For reference, I checked the socket timestamp handling that has a
> number of corner cases with time32/time64 formats in compat mode,
> but none of those appear to be affected by the problem.
>=20
>> Aside from the potentially nasty use of per-task variables, one thing
>> I don't like about PF_FORCE_COMPAT is that it's one-way.  If we're
>> going to have a generic mechanism for this, shouldn't we allow a full
>> override of the syscall arch instead of just allowing forcing compat
>> so that a compat syscall can do a non-compat operation?
>=20
> The only reason it's needed here is that the caller is in a kernel
> thread rather than a system call. Are there any possible scenarios
> where one would actually need the opposite?
>=20

I can certainly imagine needing to force x32 mode from a kernel thread.

As for the other direction: what exactly are the desired bitness/arch semant=
ics of io_uring?  Is the operation bitness chosen by the io_uring creation o=
r by the io_uring_enter() bitness?=
