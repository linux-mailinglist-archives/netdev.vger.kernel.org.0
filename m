Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C903F7DC5
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhHYVd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhHYVd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 17:33:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6CFF610C8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 21:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629927160;
        bh=2kxD9oBMpmUQaqdwC3YSWCKXgSyHZNK0XfZzIMdaD3M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=R0pXi+tDMirwe4JascDOZPHgFM183tv+m/+jSXFfZYf1FH0lmDSmNk+hu8D6S+4NH
         p9OjqcbpARNO+KMOg7IGNtxabiZbraBmup7oqYTQznLYuhcQ95d1sBmDbiItPDer1z
         JxnVXTmS+ABVjkgZjm8u/gpWstfbuhpUF5M2iLUzpUEK3Z0skKbVhK61jQ9AhdYAUE
         LpppzxHh46Hu41SW2+vWusEiJtgilxEYLPxovBH5rm5V8C7RhfVZcq/qvhSGAddJOT
         SKxAn+T90Ng71WNkdQDhEeYnM4ipwuAQHOY3x2i1FAJavoV/Sc//9/lSj6FNbUjaCR
         UkVDFAnfbbJ7g==
Received: by mail-wr1-f41.google.com with SMTP id x12so1457263wrr.11
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 14:32:40 -0700 (PDT)
X-Gm-Message-State: AOAM530hQ4fUOESR6b0ytohDWERg/VvrjRgtLg7XlMZgpxzKmIkgCnE/
        DfpNftqZQ6wXp0LuHiV535ZuK4y8WZxJHTnD8D8=
X-Google-Smtp-Source: ABdhPJzFC7z1Fmpxgi8a0UwzcW/TvcolFKW5Ch+zYJ5fO74cKeBtt/Mb/0NA4X1r8H99nD+fqU9osFBvtykSxqSocGw=
X-Received: by 2002:adf:d1c3:: with SMTP id b3mr224413wrd.286.1629927159486;
 Wed, 25 Aug 2021 14:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210825211733.264844-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210825211733.264844-1-jonathan.lemon@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 25 Aug 2021 23:32:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a21pov6f578=ewBKHJUxKvDJTO=iVYypHx3KPKQOHEcmA@mail.gmail.com>
Message-ID: <CAK8P3a21pov6f578=ewBKHJUxKvDJTO=iVYypHx3KPKQOHEcmA@mail.gmail.com>
Subject: Re: [PATCH net-next] ptp: ocp: Simplify Kconfig.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 11:17 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> Remove the 'imply' statements, these apparently are not doing
> what I expected.  Platform modules which are used by the driver
> still need to be enabled in the overall config for them to be
> used, but there isn't a hard dependency on them.
>
> Use 'depend' for selectable modules which provide functions
> used directly by the driver.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/ptp/Kconfig | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
