Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6751EB0C4
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgFAVND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:13:03 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37487 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgFAVNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 17:13:02 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c98a3428
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=1CtKHFznmYvejxQCmxfMdkVgzL4=; b=bchjoy
        Bxch+WlO8BXQvl/McWQA3xiVgaRmcruiTVhiWebwR7Dw+6sZ5bAJbm5kjhm0y5Ku
        fFqRliMuwDIBfcPGzgbLBzaBEuIuz263GUMq1Kjc/hkZjhhynafrnbWOokDJgE1s
        a0YWWErVMu4FEh9c1IpLD3OXfu60at44lPaqPL3FuY0OGq3+ZgrOHL5h5Z7ZsDem
        jAcWNpwjqiP8GsJWRq2FXM7N7Sb3QhKU+tYSFELF5MdDJ19NciZspeNXW8nueIac
        YY70Sb4fV3qPnHc4sfCjuYmf2UYMf2yh/nACmGN4NIt6N4/ezxy2t8MMrYIx6bhK
        /vIFxFPAkQ4PJ/Og==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1d1b2d52 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 20:56:56 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id 18so10780913iln.9
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 14:13:01 -0700 (PDT)
X-Gm-Message-State: AOAM531gqzsIEZuiwDXMI17qJA+2k6EPG6WCOGAm9sINUqUtzrOe37ng
        clnuitg7nrvC5UvYyE/Xz3hvpk+n0ZFyPWogLds=
X-Google-Smtp-Source: ABdhPJwQJ4wul4JI6Uc0qPfSH5pxY5Lp/fMZ+eo5fCqMoBmB+MdHJNjWnxOlgvQCkNS3tk+6MKjQu0zXrIVMVcvbnRU=
X-Received: by 2002:a92:af15:: with SMTP id n21mr16559730ili.64.1591045980768;
 Mon, 01 Jun 2020 14:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200601062946.160954-1-Jason@zx2c4.com> <20200601.110044.945252928135960732.davem@davemloft.net>
 <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com> <20200601.135602.714480015533724237.davem@davemloft.net>
In-Reply-To: <20200601.135602.714480015533724237.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 1 Jun 2020 15:12:49 -0600
X-Gmail-Original-Message-ID: <CAHmME9r-54_SgPi-qfYKajxQ-rtwj2w1NePsSFQJGeS6b94y6g@mail.gmail.com>
Message-ID: <CAHmME9r-54_SgPi-qfYKajxQ-rtwj2w1NePsSFQJGeS6b94y6g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of cycle
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On Mon, Jun 1, 2020 at 2:56 PM David Miller <davem@davemloft.net> wrote:
> Jason, I'm not discussing this.
>
> I have to backport these fixes and it makes more work for me, as well
> as others.

As I said earlier, no problem, and I understand.

> I'm also quite sad that the most important thing you could find to
> work on was figuring out how many columns should be in a line.

That seems kind of uncalled for, don't you think? But I guess I'll
take the bait: this is very much not the only thing I've been working
on, far from it in fact. There was a small window between Linus
committing the 100 column patch and net-next closing, so I took a
break from other things to make sure this at least had a shot. Turns
out that the backporting concern was paramount, which is completely
understandable, and now I'll continue on my way working on the stuff
that I resumed last night after sending this patch.

Jason
