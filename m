Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C227C332F3E
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhCITou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhCIToR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:44:17 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA04C06174A;
        Tue,  9 Mar 2021 11:44:17 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id o11so15303775iob.1;
        Tue, 09 Mar 2021 11:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0LdCjjwzecnp1EYokdW4ebJBaUE+V7zj86mopJQUfk=;
        b=kGKbT37spDgGsq64b2yUwd05ipI+8eRT+NKbHxXN/JRiGVRW/3lpfcSGRLEh0PgUxm
         S+fzmf0yeP8Z2TqhFZtTHZzF+Ce7QrXg2RFRXFCEN/z847MuyOFOtPpI+llRKWc4Xa+7
         zZHTxAxs5zjqeqBFu5rFXVNuA+Dtps1Msvwd8KLv+FTFZVSvlKUUedwXBl5IOP/ilJSt
         8emDedCKrXwSrUjgPIyrRXnXQG71WdL3rnOIKvtEVJq5pnj5lR9cV44CN4fEFb9Es0Fe
         qHu/mOJoiM9ieSNimMDWVhpOftTUFSGH9SbMMjzjWTeTL5XWKVctMVMvU1lmjiaGrjdR
         08Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0LdCjjwzecnp1EYokdW4ebJBaUE+V7zj86mopJQUfk=;
        b=NUmqnbG5WIYw3m+bh29WQvNJqmcqlGHQHkrvuVD+6BLo6BiAhsruS7yyug8FK7GhpF
         I9rNazlMmP5dgD3mqaMxxakizawUjqyL21KdDHUMlUj9N/u6+42zbfNh43n/TrGvAJhq
         w20U+sfcI3MZoaDfYvWDI+13H79XuAb8gZ3ZjzA2jER0uE4k9B7xeOEvG4pCGHpYOVxs
         AkTCmDKOchj1e8AaeLSyQHvsz9GttkMj+1VHDq8bi0AW5upRAilf2HqL5N7JZptlxAQ3
         juQXkwPIoCtqiIjNhxTMjKRBEpe3DP+YnoFk58IZA7hDNn2dbqjrJsjA8Sd0TYlvEqYG
         L1MA==
X-Gm-Message-State: AOAM530tcRW7qVvH/i8hXy0CI2oImWWiyfEfEI/smjhAe5AaVFlp4sNr
        Pek98leLoXOgy2777z3/OBcVygGr1PXomftfZUg=
X-Google-Smtp-Source: ABdhPJyDizL1CBOqwFRy8H1vQEuwTFNUXxlaJPi2bSerzyJM/ggHe+xUxloch1cnoAX1BKQ4gBb5dmjCzMrHhMSb/PM=
X-Received: by 2002:a5e:990a:: with SMTP id t10mr24345727ioj.161.1615319056963;
 Tue, 09 Mar 2021 11:44:16 -0800 (PST)
MIME-Version: 1.0
References: <20210309152354.95309-1-mailhol.vincent@wanadoo.fr> <20210309152354.95309-2-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210309152354.95309-2-mailhol.vincent@wanadoo.fr>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 9 Mar 2021 11:44:05 -0800
Message-ID: <CAA93jw5+wB=va5tqUpCiPu20N+pn8VcMxUdySSWoQE_zqH8Qtg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] dql: add dql_set_min_limit()
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I note that "proof" is very much in the developer's opinion and
limited testing base.

Actual operational experience, as in a real deployment, with other applications,
heavy context switching, or virtualization, might yield better results.

There's lots of defaults in the linux kernel that are just swags, the
default NAPI and rx/tx ring buffer sizes being two where devs just
copy/paste stuff, which either doesn't scale up, or doesn't scale
down.

This does not mean I oppose your patch! However I have two points I'd
like to make
regarding bql and dql in general that I have long longed be explored.

0) Me being an advocate of low latency in general, does mean that I
have no problem
and even prefer, starving the device rather than always keeping it busy.

/me hides

1) BQL is MIAD - multiplicative increase, additive decrease. While in
practice so far this does not seem to matter much (and also measuring
things down to "us" really hard), a stabler algorithm is AIMD. BQL
often absorbs a large TSO burst - usually a minimum of 128k is
observed on gbit, where a stabler state (without GSO) seemed to be
around 40k on many of the chipsets I worked with, back when I was
working in this area.

(cake's gso-splitting also gets lower bql values in general, if you
have enough cpu to run cake)

2) BQL + hardware mq is increasingly an issue in my mind in that, say,
you are hitting
64 hw queues, each with 128k stored in there, is additive, where in
order to service interrupts properly and keep the media busy might
only require 128k total, spread across the active queues and flows. I
have often thought that making BQL scale better to multiple hw queues
by globally sharing the buffering state(s), would lead to lower
latency, but
also that probably sharing that state would be too high overhead.

Having not worked out a solution to 2), and preferring to start with
1), and not having a whole lot of support for item 0) in the world, I
just thought I'd mention it, in the hope
someone might give it a go.
