Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4783F7C02
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhHYSGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhHYSGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 14:06:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E53CD610C9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629914721;
        bh=4X5LPpQNtCtwaVCdBoKhK0t58slkTfkLJw00xz+L1pw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HoTc2el8ysbw1WUQirqjMGXR3U3s65jLDQNdSbKQFdlX4LErhbWOF0xcR5GUQbw3w
         Ccy3JVRev2SMpFBEe6bbo8+SXg00+8DHM6JvmXbWnJw+3qfhbFNGmz9TE2MkbQHSo6
         ++lYo/Yrl2sOGyhLuLLoIYvfDfsFAJugTmlxjpaEguG2XmKgLcPXasejAKXQ4Iyszw
         TYSd/bVdKnx1m/UeCYnFGqov0qV6lQnC1Vhh5E4pyJauzoDhgEgFvteck4U2ItwMpa
         tTUBC5Q5Mbi250W6Q97ldhkmuKSB1TQ698J7r9RSQRA8eG3XYeaK2yN+n8aQFrPBwj
         928J0GOdu8PiA==
Received: by mail-wr1-f53.google.com with SMTP id q11so534442wrr.9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:05:21 -0700 (PDT)
X-Gm-Message-State: AOAM533L4EJipEEDv6QZrAALqePrhMVTnLQNAzI0Ex583JrtSTBwRsKs
        RWuAcqhyzZhnjiWGoqawvt2NialIX5ZtGum4wQo=
X-Google-Smtp-Source: ABdhPJzpb1zL6G1GvZSRpBFlWhk+gfOj7VFdG1qBEmH8DuolSfxIjHAw/zpbRbed9dBu7ylwRkWi/pTK3g9Br8FW9zE=
X-Received: by 2002:a5d:58c8:: with SMTP id o8mr16697160wrf.361.1629914720609;
 Wed, 25 Aug 2021 11:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210813203026.27687-1-rdunlap@infradead.org> <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org> <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
 <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
 <20210825170813.7muvouqsijy3ysrr@bsd-mbp.dhcp.thefacebook.com> <8f0848a6-354d-ff58-7d41-8610dc095773@infradead.org>
In-Reply-To: <8f0848a6-354d-ff58-7d41-8610dc095773@infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 25 Aug 2021 20:05:04 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3YHBNDNb8ThXzN844FHhMYJW-95kQ5Y=nfOYxYcMms6Q@mail.gmail.com>
Message-ID: <CAK8P3a3YHBNDNb8ThXzN844FHhMYJW-95kQ5Y=nfOYxYcMms6Q@mail.gmail.com>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 7:29 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> On 8/25/21 10:08 AM, Jonathan Lemon wrote:
> > So, something like the following (untested) patch?
> > I admit to not fully understanding all the nuances around Kconfig.
>
> You can also remove the "select NET_DEVLINK". The driver builds fine
> without it. And please drop the "default n" while at it.
>
> After that, your patch will match my (tested) patch.  :)

That version sounds good to me.

       Arnd
