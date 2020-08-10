Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9D240D1C
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgHJSn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbgHJSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 14:43:22 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601D1C061756;
        Mon, 10 Aug 2020 11:43:22 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q3so5681041ybp.7;
        Mon, 10 Aug 2020 11:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6TJk/fTAPADshSTiLb7E9ncJKjWoZVvq9Eei8Ciqoek=;
        b=jN3ByG0us6cOH8uL62xPMUyDh4ma6G/mp//w4k0ibrbvYBZqtQ3MoxB9GniqyspdgX
         M7spWPFfQY1j6+qRwWb3wT/CUJFIqDysNf4eIEcAohJdw1lFi/iBsh3Zg7SQv/D7ffQj
         IYKUTn+oDmOI8K98VZvG6FqH8hE1JDUsKKe+XHCVm3m0gAGuKhhCzNEhDZZ4UrhC0PuX
         i7bLxbqcwI98CrJ6H7PwpnJTjAJcWwOgmHpuPSBU9zFSdShpKass5flZyEhJYA5ShOvx
         4bJxZ1+Mz6MrlaZsZx+0m+lpRi+i7RWewQd7G7xMJxmzSrzrOwzWT571/dPx3A9xTJTk
         o2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6TJk/fTAPADshSTiLb7E9ncJKjWoZVvq9Eei8Ciqoek=;
        b=pU9RqVja517PhU3T3ZSFNruPZEQ8gfwIAP3hSxhO2TzAg6E4n2PIJLOyfGD/Ercdh0
         XoPKne/dPHVckMvX8rf5BBHP4vw1WivXeRfEHdMvT+qiylOZIEdMEq9XoV3nUpDz7so8
         2M+l0FQFL+gHrSGsmIAorxjov0ac3rEUXJLuXC3cH7NkNyi9zTbaj1GwAgoYulZww7ub
         WqM3fdIG/upKfCTqzCkxyG1ILd+tTsMmFUbz3CYmg2TJ+j/NUcTJEEJmFiZ9D4I4c5Fd
         zPgHWZNKkKA980X7H/HA05jgFBBCdsr8RrWnM9Ua55D/3jh/hJl0Dd3jvL6X0FrddO0X
         Qf3g==
X-Gm-Message-State: AOAM533Z4xnIhrKuAobwG2aa+bl16YCB4VfehyHNEFESBNWkfGYArGmi
        u9d/IhKu9wUYrjborF3CvdIO1pbSvZkAjvOsrJw=
X-Google-Smtp-Source: ABdhPJxZ3KsKtBwpinpUTiczE18BrN3WSRsllO0BAtkdCeiLl97agLSuvJgPGyHEDBzABr2Z/SZfPdzkiR12XgXGS+0=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr40638793ybq.27.1597085001590;
 Mon, 10 Aug 2020 11:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200729230520.693207-1-andriin@fb.com> <874kpa4kag.fsf@toke.dk>
In-Reply-To: <874kpa4kag.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Aug 2020 11:43:10 -0700
Message-ID: <CAEf4BzZMC4LWpgOMBgKaLAGLPmt4rz0D7_sNC+i=yaVhEtDG9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] BPF link force-detach support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 8:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > This patch set adds new BPF link operation, LINK_DETACH, allowing proce=
sses
> > with BPF link FD to force-detach it from respective BPF hook, similarly=
 how
> > BPF link is auto-detached when such BPF hook (e.g., cgroup, net_device,=
 netns,
> > etc) is removed. This facility allows admin to forcefully undo BPF link
> > attachment, while process that created BPF link in the first place is l=
eft
> > intact.
> >
> > Once force-detached, BPF link stays valid in the kernel as long as ther=
e is at
> > least one FD open against it. It goes into defunct state, just like
> > auto-detached BPF link.
> >
> > bpftool also got `link detach` command to allow triggering this in
> > non-programmatic fashion.
>
> I know this was already merged, but just wanted to add a belated 'thanks
> for adding this'!
>

You are welcome!

> > Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> BTW, I've noticed that you tend to drop Ccs on later versions of your
> patch series (had to go and lookup v2 of this to check that it was in
> fact merged). Is that intentional? :)

Hm.. not sure about whether I tend to do that. But in this it was
intentional and I dropped you from CC because I've seen enough
reminders about your vacation, didn't need more ;)

In general, though, I try to keep CC list short, otherwise vger blocks
my patches. People directly CC'd get them, but they never appear on
bpf@vger mailing list. So it probably happened a few times where I
started off with longer CC and had to drop people from it just to get
my patches into patchworks.

>
> -Toke
>
