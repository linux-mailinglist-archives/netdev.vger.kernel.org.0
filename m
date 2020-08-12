Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE0242582
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 08:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHLGfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 02:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgHLGfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 02:35:50 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941D6C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 23:35:50 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id k4so922938oik.2
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 23:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=0gS4BiUd8kCN2bCUPI5tQyGVRCbbK0/sDj7XuBeAwEY=;
        b=KCu2COy7P3cZRYJD33qvg0H9HOFkm57+geS8J2smPZOWxW90JzTnonciFqsvrUoiqe
         mqP0PuR1BjwWqJ3gjeLkChR1NevrS41lB41srDsDpsgnatXALYT2isdCfCxwyp2TUh0h
         SOcVqv65RC1RqZwshoCeCrUnei/fT8ebeitJwsH+StxH269aHclHEPX5KJvMj6gCP4bS
         HpA350oDyRo5svHsqrqFURAJCyURIDmPMxLaGU6F6eoKa7vrqH7aQBEjV3SgKUIJWUHI
         xsvw5u49rDKLBMURqD6gp44qso4bhUKSC4GeIxP9Hk8uvOOhc6Jljs0lEbiLluHzxQUz
         zoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=0gS4BiUd8kCN2bCUPI5tQyGVRCbbK0/sDj7XuBeAwEY=;
        b=XasrhnHb/8dC5gVmGbnl7miRZQ/QK7h4pBz7hUeYk6noUtfFYvf45BGlO5aA7Sujpk
         TGj5ooOAtBQ4ZK0XgLGvKdtt/UTMcrsUSIX6JAnmA1tgfJIn9vQWJDM62hccrmny40oF
         xx6os3pmpy9NN6y5up49+ryCQbybNnpsdfAJi5t4FKdKh+XFvgt0DFEjk5Ro1DxT8Jo8
         AjRjuszjzElBe+1ugFg8tVHdYga1SvPhcGyQUzgYsvGw4iI81AQm6nx90W8u3+wvfXLd
         Ruvx0boLBu0d+BYkgVGfvvwxa4t4uQBdK035PBIUaxiwqTjaJ1LsRKJ/Dl/xinJvMrIF
         ORAA==
X-Gm-Message-State: AOAM530XqP/mgV6V+XoAtOqBjSw68O5+oe1MoxXQHl1NFLmr8CKn1bKz
        tem2aG7Y0nZ3aKKMoWL2XrfuS5RyGW/sqF2WNSdJdbIpjeQ=
X-Google-Smtp-Source: ABdhPJzn6xniFLA3v+GxlXKZjA0bosSWmT2MwGCPG0umlo0FAvCY/GNMl3ocXuVAeLU8V3G2blG3761EFDCWNFXV6Ao=
X-Received: by 2002:aca:724f:: with SMTP id p76mr6359821oic.35.1597214149610;
 Tue, 11 Aug 2020 23:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
In-Reply-To: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 12 Aug 2020 08:35:37 +0200
Message-ID: <CA+icZUVNt4H5Tm2wTxq-7nS9w3nn7PKVQ=8CW-egyTJqTzUWZQ@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ INSTRUCTIONS ]

echo 1 > /proc/sys/kernel/sched_schedstats
echo prandom_u32 >> /sys/kernel/debug/tracing/set_event
echo traceon > /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
echo 1 > /sys/kernel/debug/tracing/events/enable

/home/dileks/bin/perf record -e random:prandom_u32 -a -g -- sleep 10

That gives me now some perf data.

- Sedat -
