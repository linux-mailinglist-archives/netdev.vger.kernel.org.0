Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40EF38F984
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 05:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfHPDnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 23:43:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42394 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfHPDnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 23:43:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so4732966qtp.9;
        Thu, 15 Aug 2019 20:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=lwXp6Bc3lcXhB5CSaFKjX7zLyM40avBB8IHrFVa8wRU=;
        b=VO3UJfaa0JeTNzqLdcFqVVioqFhBHxOo0QJ8q4ySHZYFzuZD2TR9J82hv3/qZWZ8Zj
         Qcd8gsnJSfEgMHiM2hcO8pgrgQbIIbjK2hnsRjRjyAudmowclxRzROQ7lh2B/CPyDLjI
         UzDJ7DouMLPPJEWCRIH1IUlbZSWqRKjJZaUbDuywZNglIA8XvOKKLglF0sQyWSC3rGXO
         qcjf++LjVQ72/QJJEG57apa5HNM3m8c6QKehp9P4IenAKi6Yf+4755GZTZ3ajVlWA9O9
         vMRijIyOX84kwC6HYAJBkhNwtyQpeZypWbAK2DyI6nuom4p0Kl/5Rt/1lbudmeyNkQ2b
         CoEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lwXp6Bc3lcXhB5CSaFKjX7zLyM40avBB8IHrFVa8wRU=;
        b=cKS4At1T+WTbVdCgviO1RA6yGES14a75rhSvttnaZ1kBfZHzIzhEr+BkKfbAcHBa7Q
         NGvJo0eSK7BBRj8SkFvg4T3m19yN2viaYA769R3eTFaFhBvaEgNBKBJ5ik5tZDDVQINw
         Pma82uNoCTBZS9Kw9AxuRqUMJ2X8i3jM+omHlOE2HufXY2scaIRwbZLpseaarez4XukG
         573I1zC51uHHMrlqRyYk59h+63mb/1ug2DvB7tR7ht8r3z0lMfM5br2wNVMEgMK63mwL
         Zga6gXGZG0PnV0TGVytOTHjydY0i2M8ooE5uSzJNkLzFnd7csPfGan4JoWOB/ZJ/8wrQ
         Z4Ww==
X-Gm-Message-State: APjAAAUBjBf9kTy00Dm84/NKfkemoWAldu5QLjdXhRzhrMylp/5BptsW
        AL8KPyxzJgRZjGA+b3yS7nAiYKYKb50=
X-Google-Smtp-Source: APXvYqwVrkRy1tWB81NfjQaahNLWNGwMtD2aG+xFgZ4Hqp397TBinlizQ9StfPT1AaSgj898xl1Zew==
X-Received: by 2002:ac8:4118:: with SMTP id q24mr161656qtl.274.1565926993490;
        Thu, 15 Aug 2019 20:43:13 -0700 (PDT)
Received: from localhost.localdomain ([189.63.142.156])
        by smtp.gmail.com with ESMTPSA id l18sm2229601qtp.64.2019.08.15.20.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 20:43:12 -0700 (PDT)
Date:   Fri, 16 Aug 2019 00:43:07 -0300
From:   Ricardo Biehl Pasquali <pasqualirb@gmail.com>
To:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        jacob.e.keller@intel.com
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org,
        stefan.puiu@gmail.com, corbet@lwn.net, davem@davemloft.net
Subject: Re: [PATCH v2] socket.7: Add description of SO_SELECT_ERR_QUEUE
Message-ID: <20190816034307.GA17503@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f053fe2c-20e5-4754-8b13-89cddfbfb52d@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TL;DR: This email proposes a description of the socket
option SO_SELECT_ERR_QUEUE taking into account the change
in wake up behavior when errors are enqueued introduced by
the commit 6e5d58fdc9bedd0255a8 ("skbuff: Fix not waking
applications when errors are enqueued") in Linux 4.16.

On Mon, Jul 29, 2019 at 08:51:42PM +0200, Michael Kerrisk (man-pages) wrote:
> Sorry -- I've not had a lot of cycles to spare for man-pages of late.

Hi. No problem, I've just wondering whether you were
receiving the messages.

> Thanks for the patch. But your text doesn't quite capture the idea
> in this commit message:
> 
> commit 7d4c04fc170087119727119074e72445f2bb192b
> Author: Keller, Jacob E <jacob.e.keller@intel.com>
> Date:   Thu Mar 28 11:19:25 2013 +0000

It definitely does not.

Initially, despite the description of the commit and the
name of the option, I was investigating only the poll() case
as this was what I was working on.

Sorry.

Now I investigated the behavior of select() and poll(). I've
updated a test code that I wrote some time ago.

See <https://github.com/pasqualirb/poll_select_test>.

I've also written a Behavior section in README which I did
not include here.

> What would you think of something like this:
>        SO_SELECT_ERR_QUEUE (since Linux 3.10)
>               When this option is set on a socket, an error condition  on
>               a socket causes notification not only via the exceptfds set
>               of select(2).  Similarly, poll(2) also  returns  a  POLLPRI
>               whenever an POLLERR event is returned.
> 
>               Background:  this  option  was  added  when waking up on an
>               error condition occurred occured only via the  readfds  and
>               writefds  sets of select(2).  The option was added to allow
>               monitoring for error conditions via the exceptfds  argument
>               without simultaneously having to receive notifications (via
>               readfds) for regular data that can be read from the socket.
>               After changes in Linux 4.16, in Linux 4.16, the use of this
>               flag to achieve the desired notifications is no longer nec‐
>               essary.  This option is nevertheless retained for backwards
>               compatibility.
> 
> ?

I think the part "causes notification not only via the
exeptfds set" implies that the option causes notification
in other sets besides exceptfds. However, the option causes
notification in exceptfds (before Linux 4.16).

In "Background", before Linux 4.16, "waking up" happened
also in exeptfds (see 'Internal details' section), although
select() did not return.

A description covering poll() and select() cases plus wake
up behavior might be:

  When this option is set on a socket and an error condition
  triggers wake up (see Background below), an exeptional
  condition (POLLPRI of poll(2); exeptfds of select(2)) is
  returned if user requested it.

  Background:

  Before Linux 4.16, an error condition triggers wake up only
  if user requested POLLIN or POLLPRI (i.e. any of readfds,
  writefds or exeptfds of select(2)). However, for an error
  condition to be returned to the user instead of sleeping
  again in the kernel, POLLERR (i.e. readfds or writefds of
  select(2)) must also have been requested (implicit in
  poll(2)). The option eliminates this need in select(2) by
  returning POLLPRI (i.e. exeptfds) if user requested it.

  Since Linux 4.16, an error condition triggers wake up only
  if user requested POLLERR (i.e. readfds or writefds of
  select(2)). Wake up is not triggered when requesting only
  exeptfds, although returning on it occurs if the error
  condition was generated before calling select(2).

  // Linux 4.16 commit 6e5d58fdc9bedd0255a8 ("skbuff: Fix not
  // waking applications when errors are enqueued")

Another description, focusing on select(), might be:

  Before Linux 4.16, when this option is set on a socket and
  an error condition occurs, select(2) returns on exeptfds if
  user requested it. It is already returned on readfds and
  writefds. Since Linux 4.16, when the option is set, an error
  condition does not return via exeptfds anymore unless it
  occurred before calling select(2).

  For poll(2), regardless of the kernel version, the option
  causes POLLPRI to be added when POLLERR is returned.

  The option does not affect wake up, it affects only whether
  select(2) returns. The wake up behavior is affected in Linux
  4.16. Before this release, waking up on an error condition
  required requesting POLLIN or POLLPRI. However, for an error
  condition to be returned to the user instead of sleeping
  again in the kernel, POLLERR must also be requested. Since
  Linux 4.16, waking up requires requesting only POLLERR.

I have been rewriting this multiple times in the past two
weeks, and I still think it is not clear/simple enough.

What do you think? Please comment your understanding and
your ideas.

Internal details
================

The commit 6e5d58fdc9bedd0255a8 ("skbuff: Fix not waking
applications when errors are enqueued") introduced in Linux
4.16, changed the function that triggered the wake up. The
function sk_data_ready() (sock_def_readable()), which wakes
up the task if POLLIN or POLLPRI is requested, was replaced
by sk_error_report() (sock_queue_err_skb()), which wakes up
the task only if POLLERR is requested.

With the option (SO_SELECT_ERR_QUEUE) set, requesting only
exeptfds (POLLPRI) does not intersect the trigger events
anymore, so the task is not woken. However, if POLLERR is
triggered __before__ calling select(), select() __will__
return because availability of events is checked before
sleep.

In select(), POLLPRI is always requested [1]. POLLERR is
requested by readfds and writefds [2]. POLLIN and POLLHUP
by readfds [2]. POLLOUT by writefds [2].

In poll(), user freely requests events, but POLLERR and
POLLHUP are always requested [3].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/
    linux.git/tree/fs/select.c?id=6e5d58fdc9bedd0255a8#n443

[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/
    linux.git/tree/fs/select.c?id=6e5d58fdc9bedd0255a8#n435

[3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/
    linux.git/tree/fs/select.c?id=6e5d58fdc9bedd0255a8#n820

	pasquali
