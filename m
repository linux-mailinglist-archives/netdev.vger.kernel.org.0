Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B348F14D319
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 23:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgA2Wbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 17:31:33 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:41696 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgA2Wbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 17:31:33 -0500
Received: by mail-il1-f178.google.com with SMTP id f10so1333440ils.8
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 14:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Geyi/S6p5PFgirfQh9KIMOaQBZ3zEtLgTXVvDkdJQ6o=;
        b=BVVRJTuggG17asd17jLkRLSyrIAOay0/0RKXTPjkZFICwkfHkf72p2xGfdwZqHHoMJ
         7ssw8H62Ih50iDHsTS7K5y4onALmDA7TGLOl5V/gZ8fumK8TWlx63lLGyLStnxZxM3aQ
         Kv1zxWQfZ506eHbGycAqXbIdmFM2T9kyyb+6bSGiKzA+uYd4/XFg7flN2q6Mb4wK8FnS
         cGzK8g4qs3/V/PNyvHjtRuC5zLfb/teu/eiiu4igcj2yoLswSMLcQKprt858I2k06sQU
         IuChz2hM92SF0LbfBw1kMSP9zUfaMTJMPxkYY6sPMo5coJ3viVMGw+n52upXJ372hQb5
         0ekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Geyi/S6p5PFgirfQh9KIMOaQBZ3zEtLgTXVvDkdJQ6o=;
        b=HYuSNOQuGIctISZWUACD8SRjzkg4oO8K12tTvMBSFxDBXOPQqR9WOWmSVAtcA7dABt
         0xYC2GgUw281/qYeDfrVelj17xXc4O4M9kk2BsxaSF6rKVK5EM3+AXUs/2RflSWND5lq
         pUM5o/Ee0wiwehFI1qOoQp1jLbD4kVSTdFZATlc8E34xVuHEN3jdaVA284QvQNNjHstX
         5oCUW2pSkQ4/cvlRKC0i0lanh2nbuYd8McuMXyKe9Fm24XTnbB+iqIYLWJ536909mHdC
         5simhSpIU0A3w2YAoCZyqMzBu6m4e/esfTs4ZvOTwiZPeR4L+Ybsuno/fB9H6YJGAQqc
         lnOw==
X-Gm-Message-State: APjAAAVKyRLbMpEECp4tWH3cV/cIsK9Z2r3Enw1aUM7+bXvTybnVxJf8
        ORxKkDLVYRSAWLi7eUOlxL5qzUbTZeqzMmoxd8OdBu5N
X-Google-Smtp-Source: APXvYqwn4R35oZiKb0GNHQjOf2aK1FdSK/KF8jfyAobqT/jPZcyPIF6IxuEj3wvy8US+EqlCA8L4PB2ceLzf/JhMdLw=
X-Received: by 2002:a92:cb89:: with SMTP id z9mr1500521ilo.145.1580337092511;
 Wed, 29 Jan 2020 14:31:32 -0800 (PST)
MIME-Version: 1.0
References: <CACwWb3CYP9MENZJAzBt5buMNxkck7+Qig9yYG8nTYrdBw1fk5A@mail.gmail.com>
 <CAHapkUgCWS4DxGVL2qJsXmiAEq4rGY+sPTROx4iftO6mD_261g@mail.gmail.com>
In-Reply-To: <CAHapkUgCWS4DxGVL2qJsXmiAEq4rGY+sPTROx4iftO6mD_261g@mail.gmail.com>
From:   Captain Wiggum <captwiggum@gmail.com>
Date:   Wed, 29 Jan 2020 15:31:20 -0700
Message-ID: <CAB=W+o=-XEu_QZtrt6_Qt-HB4CUH+4nUs1o02tVFqJJkdi_bhg@mail.gmail.com>
Subject: Re: IPv6 test fail
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     Levente <leventelist@gmail.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(resending without html.:)
I started the thread.
We are using 4.19.x and 4.9.x, but for reference I also tested then current 5.x.
I believe we got it all worked out at the time.
--John Masinter


On Wed, Dec 18, 2019 at 2:00 PM Stephen Suryaputra <ssuryaextr@gmail.com> wrote:
>
> I am curious: what kernel version are you testing?
> I recall that several months ago there is a thread on TAHI IPv6.
> Including the person who started the thread.
>
> Stephen.
>
> On Thu, Oct 24, 2019 at 7:43 AM Levente <leventelist@gmail.com> wrote:
> >
> > Dear list,
> >
> >
> > We are testing IPv6 again against the test specification of ipv6forum.
> >
> > https://www.ipv6ready.org/?page=documents&tag=ipv6-core-protocols
> >
> > The test house state that some certain packages doesn't arrive to the
> > device under test. We fail test cases
> >
> > V6LC.1.2.2: No Next Header After Extension Header
> > V6LC.1.2.3: Unreacognized Next Header in Extension Header - End Node
> > V6LC.1.2.4: Extension Header Processing Order
> > V6LC.1.2.5: Option Processing Order
> > V6LC.1.2.8: Option Processing Destination Options Header
> >
> > The question is that is it possible that the this is the intended way
> > of operation? I.e. the kernel swallows those malformed packages? We
> > use tcpdump to log the traffic.
> >
> >
> > Thank you for your help.
> >
> > Levente
