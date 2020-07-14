Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0996021F8AF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgGNSBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:01:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22335 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728358AbgGNSBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594749682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6wTiDYzSRRjWEKEHqhDWlOlrN2pjSMlUd39mDOu9uEM=;
        b=EZLNu0ogRdtpLzOxlzDI169QrXnVunVdKC1pRUcKEjNA+eqcphTw7xD1egLut/gSE3++2d
        Q5ijpyeBwV/sVrMircKFU/HkkhVVUROdt8tHzQ/KANPv98Z9RQPo98zlCTiYz6Lv48Nl4j
        gxT2sZkxAaiuwJBAdGCbO4Mncnmip9Q=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-L8SC0y6IM7-7wzm9-l4ESA-1; Tue, 14 Jul 2020 14:01:19 -0400
X-MC-Unique: L8SC0y6IM7-7wzm9-l4ESA-1
Received: by mail-ot1-f70.google.com with SMTP id p3so10095257ota.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6wTiDYzSRRjWEKEHqhDWlOlrN2pjSMlUd39mDOu9uEM=;
        b=PUqs/Y8cHqeJgtSNXetirL1Z/JVkSwfyrBimG7OmGgVDzU5AlO5vJIjNCNAhmTCD0b
         QUupSjwjdL1bKCH6AQXGhp8LQoaDftMamdGCt62HhIxqwatb7PUMD90hm8mRPtBCruuN
         pTgn/EZ0xiXVxdvhC+GRkxKz3Ozg/0RElZQxgkCLsRWRuWFjQR3pV9aKoNz9CV38NMCz
         5uQpnymbThF1m5PezLtuJJHIpZ/mF7Ibs0rTuMYR0bhOlBo2cCsRJcNmEvk70rWk/Asm
         mdwdU3ozSqAP8e2sl/Cup28dlP8eyDNjm24dyR1SE94M+BG0j/DDYnelL7e1NH5H8oVZ
         aXGQ==
X-Gm-Message-State: AOAM533hJIQWuk+QoavqcSOQqX6n4doR1KVpbhaldCYPrSNVy8R7M1mi
        sH5VOYye/YNinBhBZnU4a2wdBwR0jDFCsCT8JpqKvgyk/yyvLIDKWMPl11z2YDm1R0rT+/Q60/Q
        /EZZuiPqh+tPyu9kDfnLv4330GLTuf3rb
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr4527058oih.92.1594749678615;
        Tue, 14 Jul 2020 11:01:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1r9zZ+XRJlNEp4AH4PLmJ6heTMgpJeMdvPxAeGmj/PDXhWw26bpYDtePSaUSvskgs7H1f2ZDO9uJK/UVF35c=
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr4527024oih.92.1594749678198;
 Tue, 14 Jul 2020 11:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <7fb02008-e469-38b7-735b-6bfb8beab414@gmail.com>
In-Reply-To: <7fb02008-e469-38b7-735b-6bfb8beab414@gmail.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Tue, 14 Jul 2020 14:01:07 -0400
Message-ID: <CAKfmpScwe_mv+Tm9sXyJqXk7bs8-ZWbNq0025Lcho_VK6qZNMw@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 5:36 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 7/13/20 11:51 AM, Jarod Wilson wrote:
> > As part of an effort to help enact social change, Red Hat is
> > committing to efforts to eliminate any problematic terminology from
> > any of the software that it ships and supports. Front and center for
> > me personally in that effort is the bonding driver's use of the terms
> > master and slave, and to a lesser extent, bond and bonding, due to
> > bondage being another term for slavery. Most people in computer
> > science understand these terms aren't intended to be offensive or
> > oppressive, and have well understood meanings in computing, but
> > nonetheless, they still present an open wound, and a barrier for
> > participation and inclusion to some.
> >
> > To start out with, I'd like to attempt to eliminate as much of the use
> > of master and slave in the bonding driver as possible. For the most
> > part, I think this can be done without breaking UAPI, but may require
> > changes to anything accessing bond info via proc or sysfs.
> >
> > My initial thought was to rename master to aggregator and slaves to
> > ports, but... that gets really messy with the existing 802.3ad bonding
> > code using both extensively already. I've given thought to a number of
> > other possible combinations, but the one that I'm liking the most is
> > master -> bundle and slave -> cable, for a number of reasons. I'd
> > considered cable and wire, as a cable is a grouping of individual
> > wires, but we're grouping together cables, really -- each bonded
> > ethernet interface has a cable connected, so a bundle of cables makes
> > sense visually and figuratively. Additionally, it's a swap made easier
> > in the codebase by master and bundle and slave and cable having the
> > same number of characters, respectively. Granted though, "bundle"
> > doesn't suggest "runs the show" the way "master" or something like
> > maybe "director" or "parent" does, but those lack the visual aspect
> > present with a bundle of cables. Using parent/child could work too
> > though, it's perhaps closer to the master/slave terminology currently
> > in use as far as literal meaning.
> >
> > So... Thoughts?
> >
>
> So you considered : aggregator/ports, bundle/cable.
>
> I thought about cord/strand, since this is less likely to be used already in networking land
> (like worker, thread, fiber, or wire ...)
>
> Although a cord with two strands is probably not very common :/

I'd also thought about cable and wire, since there are multiple
physical wires inside an ethernet cable, but you typically connect one
cable per port, so a bundle of cables seemed to make more sense. :) I
also had a few other ideas I played with, including a bundle of pipes
and a pipework of pipes (which is apparently a thing, but not very
common either, outside of maybe plumbers?).

-- 
Jarod Wilson
jarod@redhat.com

