Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3015021F8BC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGNSE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:04:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59663 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgGNSE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594749894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Uy5z+zxEHDM/mc2k96aF628zofsGGjD7E3o182DxAU=;
        b=Ps8vi/NLmJkjPJGmuaISE9zDSljqs6BG37gelpCJhexsFZVaidClzDMLeVgWVN0zD5YGqC
        SjKkrY186ztqVGGxXq3u2TEyXzjTXBnSYiaC9rS+pcQT6xvk3cUqogl2W99B90ASXDnh9x
        u6q4Hug5G08I/Du+ZMkbvEY1IyOI+wk=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-QX-jTkRYNkmPpp6e0WgnWA-1; Tue, 14 Jul 2020 14:04:52 -0400
X-MC-Unique: QX-jTkRYNkmPpp6e0WgnWA-1
Received: by mail-ot1-f69.google.com with SMTP id g70so10103268otg.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Uy5z+zxEHDM/mc2k96aF628zofsGGjD7E3o182DxAU=;
        b=jpD1LIx+wCpB+wYBd9yvLKta5UugbCT/ZPRD3xot3s0H8bVF+8OpGdZ47Am6PlUJIl
         dcvZ8Pqd2uZvg0g92fv0UTP7rPWLwRjZqKk4YOeZVekL95ZAE9ReZOEc37LrWYxi1+uo
         WbFPChqbKUlmy+UNSryTRuDBQWhVcRnWIYiC7CPhgsGx/CAETT315yA8C+XB+TGzxM2o
         IPJmK1ttOeNqj5775WOgIstisA5pSEBgSGY6xPwordbK9pxskSws8ekuJ6h1m1upseWF
         7yOXxXhfSa+1UBd8ML/aAlaFUj4uFT6NJXgBhoQwqb+VZKPG1r4Tnp08JNwKrahC+8ek
         BgRw==
X-Gm-Message-State: AOAM531Mqm1aXvaQMU4g3SxlTQznoYK2pPeTOXCXr4wojr1L6CGdgyQ8
        8+jMc05zq9MJyJHV6bI15v9bPiBkHWiAlu5Ic4jGZhx4ta7K7pvWU3p8SfAMNoLdddG2o/dU0yc
        fVuA8gU1I46VxsaYeY4a8mdLP3OM6ZA2u
X-Received: by 2002:a9d:6659:: with SMTP id q25mr4787607otm.330.1594749891606;
        Tue, 14 Jul 2020 11:04:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLtIsrXfYU4Yt0qlNhorFSBy9tXwFNDsuTQ3C8thgmpG4m2LzoSruDjlozWrpYiTRKmZ4GAd7jfS8bjbp3d6A=
X-Received: by 2002:a9d:6659:: with SMTP id q25mr4787593otm.330.1594749891384;
 Tue, 14 Jul 2020 11:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
In-Reply-To: <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Tue, 14 Jul 2020 14:04:40 -0400
Message-ID: <CAKfmpSfwdAOgXjHwE3bxf7r1oV6XskqMvpTFAk-DMSzt4dH-9g@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 6:00 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Mon, Jul 13, 2020 at 02:51:39PM -0400, Jarod Wilson wrote:
> > To start out with, I'd like to attempt to eliminate as much of the use
> > of master and slave in the bonding driver as possible. For the most
> > part, I think this can be done without breaking UAPI, but may require
> > changes to anything accessing bond info via proc or sysfs.
>
> Could we, please, avoid breaking existing userspace tools and scripts?
> Massive code churn is one thing and we could certainly bite the bullet
> and live with it (even if I'm still not convinced it would be as great
> idea as some present it) but trading theoretical offense for real and
> palpable harm to existing users is something completely different.
>
> Or is "don't break userspace" no longer the "first commandment" of linux
> kernel development?

Definitely looking to minimize breakage here, and it sounds like it'll
be to the point of "none", or this won't fly. I think this may require
having "legacy" aliases for certain interfaces and the like, to both
provide a less problematic interface name as the new default, but
prevent breaking any existing setups.

-- 
Jarod Wilson
jarod@redhat.com

