Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96753A06F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfFHP1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:27:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34876 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfFHP1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 11:27:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so4496078wml.0
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 08:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9/sxyShoAnyJ01viZawJSmOQjMAkGfuQpB9n6+E8oxE=;
        b=E4PcI+1itL/Ro2im+VWxlPk8XW+yqBs81x7WP1eM2vyIy/w4S8Mq9qWXYiKxlo8Xcb
         sAPMbaTiYYYud0SHLggZME7YzIwRuJcX5igCOh7l/TW6wvBoU6vPOx6wmMkjA+Z0emhk
         rP8TrJ0ATANtirGdHnmZMwmjqokuoU+cEicUUVktRQyhgpJVivKJorOa9ET4sDL0lDs3
         UkuLedyKk0eSPJ9lBMlITVjxz/tBZP24LdQTmo6ESd2RWYMwMjJizqyif1/7wKgQCWsw
         ihuNM+6tJW1/ljS1dcoCNBN4B1uqiSLx29C7S7bsXooUoAk+ONM1MH2xS9Z6e7SZoRyn
         3pAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9/sxyShoAnyJ01viZawJSmOQjMAkGfuQpB9n6+E8oxE=;
        b=S1Q8PJKZzAJz8UVGGL2esyQ0SuH4VSXDNTKN5b/3aLdGhgFSLNWaWlT5aqsK0Rw5j7
         4KWjeRV/yqwNx8WGp/E3PqVqiGXCxhz7WsUzJbzu3JPDgXyNqXNZxy3YK8o0q3qw48ah
         8rId89ShCB71jnODw2FE0yqz+JgL2DI+MdMQ0yNWZs6Y0bdHxF3Ku7TksKiOaYDfjpxp
         61rbZk0Iat4mpWK+kO2hOv9DpS6t91tSplJIt6uo9LyplyHy1TAyyH+OnONUKJhWav9j
         0c2i9AgPbjgi+vMhWK2JhLpDIGghvxdCDEdqVJywdt3pz5WvisdyZaELWaeFvdZvCGsu
         n7tQ==
X-Gm-Message-State: APjAAAWs3afSvHKIQr67taQTthgHUE8HBYeVKHVxM3bgnjhBnKgYtdYg
        P3uMpXzIVKK+asHKqxl+yICe/M781+bpoLa+M5SxAQ==
X-Google-Smtp-Source: APXvYqxcB6K1Qt+iYXycuXjiOZfIRsPPvNJHe7QXlE15irY381UD4PN7uu5KA95xZPILgWQVRJUd9y8qRJ3USDYe6lc=
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr7224592wmb.13.1560007650775;
 Sat, 08 Jun 2019 08:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <1559933708-13947-1-git-send-email-tom@quantonium.net> <752a0680-a872-69d9-c67d-687d830e29da@gmail.com>
In-Reply-To: <752a0680-a872-69d9-c67d-687d830e29da@gmail.com>
From:   Tom Herbert <tom@quantonium.net>
Date:   Sat, 8 Jun 2019 08:27:20 -0700
Message-ID: <CAPDqMer8btH59cdiw37u7oJyayNpvDKWhGR5YZsFMSbKzr4GWw@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 0/5] seg6: Segment routing fixes
To:     David Lebrun <dav.lebrun@gmail.com>
Cc:     Tom Herbert <tom@herbertland.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Lebrun <dlebrun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 8, 2019 at 3:39 AM David Lebrun <dav.lebrun@gmail.com> wrote:
>
> On 07/06/2019 19:55, Tom Herbert wrote:
> > This patch set includes fixes to bring the segment routing
> > implementation into conformance with the latest version of the
> > draft (draft-ietf-6man-segment-routing-header-19). Also, segment
> > routing receive function calls ip6_parse to properly parse TLVs
> > in parsing loop.
>
> Thanks for your patch set !
>
> General comment regarding uapi changes: it might be wise to wait for RFC
> status in case the IESG or IANA decide different type/flags values.

David,

It's a "chicken and the egg problem". If we wait for publication to
implement the protocol, then we can't implement the protocol which is
necessary for publication. So we have to implement and deploy Internet
Drafts, but the definition of I-Ds expressly makes them "works in
progress" that can change at any time.

In this case, the segment routing draft is in working group last call
so it's unlikely that any major changes will occur. There is one
proposed change in changing a padding value, it has not been accepted
by the WG. IESG and IANA are very unlikely to impose different
protocol parameter values. A potential hangup for publication is that
there is very little evidence that large portions of the draft have
been implemented. Linux is the only draft cited as having implemented
TLVs and HMAC, but as these patches point out it's pretty out of date
(HMAC flag stil used, no padding, no parse loop). These patches should
help the argument that segment routing can move forward.

Tom
