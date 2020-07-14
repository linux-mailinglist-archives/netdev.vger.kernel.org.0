Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE921FD19
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgGNTR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:17:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728478AbgGNTR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594754274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UCZTlcjJ/TMA+FGByze3z0UBYolfq54p/LPGlVDAdBI=;
        b=V6XADhuHHUKpuJpWX7Pi49OT9lXuqfqy9zaiCCkdVxK7vG3FvNr/sk1KV7wP59cDQwILdc
        5rmchnyT/nKnnrBvBf2Q+9/hsdus76ygJ4zoxaBPhqsTOG35t+JJ490+fICukqYy4YXMzz
        UqBTSc+iKlX3c9XP2h0qKSMARVd1POQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-e3GfBTtcMK2B3X2qJG0Q9w-1; Tue, 14 Jul 2020 15:17:53 -0400
X-MC-Unique: e3GfBTtcMK2B3X2qJG0Q9w-1
Received: by mail-qv1-f69.google.com with SMTP id u1so10286903qvu.18
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 12:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UCZTlcjJ/TMA+FGByze3z0UBYolfq54p/LPGlVDAdBI=;
        b=duhiRONVRsOSzLBV4GUQlCBK8x00rOn0Xt89yHosxcxERz5UNKD0URPMHd77dGoQ5F
         YMPq/92cdR1IcEI8HUc06ZqviRcvg1C8f6ZRwdCgudzYVu6YWVQXHGm71MHJx42unNx7
         /9ssHV1THyIKSk8QLKpGaVKVCSE21M36vAXvroapMFRlbuoIXB1eoP2jK3RHd9w93DOI
         L39LwMulBdzYZ0Tq0DS1a2VaR70U7YhVpsMcPEvLB1mCzgY5J8LkgKtNlAILDYtuEFWt
         POGFECwhCeClXLQQBPKi9qZAah4Mjx5uiT0fo8GPLQ88eAa5e+5XtWtgATYwz2gE9vy7
         iJGA==
X-Gm-Message-State: AOAM531csl98SD2N/6WPPlDYQTmJY7ErClvqKYTdyFSDjik3kizg5K2A
        R5XXThs1SfCGmPrx4N2hy+uerAUQwPKMt20BGA077lG+L+OkY8DMWf46CHSNSm6O4Ho926xBj7O
        2zlx0h0k8OveFMQse
X-Received: by 2002:ad4:5307:: with SMTP id y7mr6259516qvr.63.1594754272453;
        Tue, 14 Jul 2020 12:17:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWFBYu+/EuNHh76iAdZFjwyWKLsTSM8QQ6yReICAIn4D1sbpwGfuqgESK0Rh2aC6q5KC13dA==
X-Received: by 2002:ad4:5307:: with SMTP id y7mr6259398qvr.63.1594754270748;
        Tue, 14 Jul 2020 12:17:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m7sm24901447qti.6.2020.07.14.12.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 12:17:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 553351804F0; Tue, 14 Jul 2020 21:17:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jarod Wilson <jarod@redhat.com>, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC] bonding driver terminology change proposal
In-Reply-To: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 21:17:48 +0200
Message-ID: <87y2nlgb37.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> writes:

> As part of an effort to help enact social change, Red Hat is
> committing to efforts to eliminate any problematic terminology from
> any of the software that it ships and supports. Front and center for
> me personally in that effort is the bonding driver's use of the terms
> master and slave, and to a lesser extent, bond and bonding, due to
> bondage being another term for slavery. Most people in computer
> science understand these terms aren't intended to be offensive or
> oppressive, and have well understood meanings in computing, but
> nonetheless, they still present an open wound, and a barrier for
> participation and inclusion to some.
>
> To start out with, I'd like to attempt to eliminate as much of the use
> of master and slave in the bonding driver as possible. For the most
> part, I think this can be done without breaking UAPI, but may require
> changes to anything accessing bond info via proc or sysfs.
>
> My initial thought was to rename master to aggregator and slaves to
> ports, but... that gets really messy with the existing 802.3ad bonding
> code using both extensively already. I've given thought to a number of
> other possible combinations, but the one that I'm liking the most is
> master -> bundle and slave -> cable, for a number of reasons. I'd
> considered cable and wire, as a cable is a grouping of individual
> wires, but we're grouping together cables, really -- each bonded
> ethernet interface has a cable connected, so a bundle of cables makes
> sense visually and figuratively. Additionally, it's a swap made easier
> in the codebase by master and bundle and slave and cable having the
> same number of characters, respectively. Granted though, "bundle"
> doesn't suggest "runs the show" the way "master" or something like
> maybe "director" or "parent" does, but those lack the visual aspect
> present with a bundle of cables. Using parent/child could work too
> though, it's perhaps closer to the master/slave terminology currently
> in use as far as literal meaning.

I've always thought of it as a "bond device" which has other netdevs as
"components" (as in 'things that are part of'). So maybe
"main"/"component" or something to that effect?

-Toke

