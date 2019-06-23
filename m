Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901C24FF89
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfFXCuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:50:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52794 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFXCuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 22:50:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so11238345wms.2
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 19:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0OalekAYRyIAH2QEFmRdzAtRfE/ShxdjHtEPlZfFF+4=;
        b=DGVVA0/BBNhBNPnmQvDiSzIbaS2TkBDHjyHBmAmSqBgIi1hTfckDwrGlvgiuEDUcfK
         HT3oZK8Gb4C2lfBwal2qzn/d/XUlo6L28P5/zNIwNO35oRS+WcpB5VdWdZU5Sdl+7kIQ
         YU95xoEMIoPFeEf256WIlLuRQwGuflYvK98CGbUVOX5rF9b+YxKB6NKex/4MRGpcwzlj
         OE2FgOJhRVFsFko4iNu26iXh32IOsuiR4FfzkoKtft636yBz9nJMvgc3Z2niDUHrJYzx
         SLpRtdnSg6/74ykaUE2Boe68jJvhr/HYxMqLgH1ZoaVqgSTHchTYLlzllRJVi0HaoN9A
         yKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0OalekAYRyIAH2QEFmRdzAtRfE/ShxdjHtEPlZfFF+4=;
        b=sjiARxd/R6tra3JyeUvxCkgY9x2sEZWLoOMyGybc0CilTCSyJzKkgf0xchPYaYMTW7
         VKKbAm3i7ucLs3ndjT3G/oH70qCjc9WjCyVws0jsf0UYoiOnTKbaCKokF6sjPAhhQ8vN
         X31E4tXMopb86EOcEaxKcQ3mcvarMtkH28eeccxGYao/I5UySjTmuCgD+AF0oOhvM+SW
         yXrnzPa6aq0cJrm+eEy6M95UwZ+3s4LTD7PWFaCRirXaLiZxM/6jrR6u/u8BQWT+tpj0
         g6kh7R8jYDK3U1UVCv3seUsvrH4ROqHlMaWdTg1Q8n81MLjpQb4kY9ZjyOpuR7dYNQJb
         icRg==
X-Gm-Message-State: APjAAAW9XqngukLlbtfG0sx2o1qXw3N2FmMTnV/xUWcwZwBjlBBgSB5U
        CVOFkJlV/m5UieqhBwyWtsSqXW5z6cIl/k42Cs1lDOqj
X-Google-Smtp-Source: APXvYqyx9/FajOh15LpPDzYXGnSjtjk3r11SPTu/VbgxIKeZUAO1BY8AAkblKPHM9qk5wnclIEJqO/snR1BBBKcyGOI=
X-Received: by 2002:a1c:d107:: with SMTP id i7mr12793895wmg.92.1561330884571;
 Sun, 23 Jun 2019 16:01:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190622004519.89335-1-maheshb@google.com> <5441f3f1-0672-fbb1-e875-7f8ceb68d719@gmail.com>
In-Reply-To: <5441f3f1-0672-fbb1-e875-7f8ceb68d719@gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Sun, 23 Jun 2019 16:01:07 -0700
Message-ID: <CAF2d9jj7uQ=y9gJ9g7tig_+S4qCRLxuv_2g+dEdZPRm0g5NBPA@mail.gmail.com>
Subject: Re: [PATCH next 0/3] blackhole device to invalidate dst
To:     David Ahern <dsahern@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 8:35 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/21/19 6:45 PM, Mahesh Bandewar wrote:
> > When we invalidate dst or mark it "dead", we assign 'lo' to
> > dst->dev. First of all this assignment is racy and more over,
> > it has MTU implications.
> >
> > The standard dev MTU is 1500 while the Loopback MTU is 64k. TCP
> > code when dereferencing the dst don't check if the dst is valid
> > or not. TCP when dereferencing a dead-dst while negotiating a
> > new connection, may use dst device which is 'lo' instead of
> > using the correct device. Consider the following scenario:
> >
>
> Why doesn't the TCP code (or any code) check if a cached dst is valid?
> That's the whole point of marking it dead - to tell users not to rely on
> it.

Well, I'm not an expert in TCP, but I could guess. Eric, please help
me being honest with my guess.
The code that marks it dead (control path) and the code that need to
check the validity (data-path) need to have some sort of
synchronization and that could be costly in the data-path. Also what
is the worst case scenario? ... that packet is going to get dropped
since the under-lying device or route has issues (minus this corner
case). May be that was the reason.

As I mentioned in the log, we could  remove the racy-ness  with
barriers or locks but then that would be an additional cost in the
data-path. having a dummy/backhole dev is the cheapest solution with
no changes to the data-path.
