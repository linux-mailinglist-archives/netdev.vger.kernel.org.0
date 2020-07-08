Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54C521860D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgGHLZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbgGHLZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:25:28 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CEFC08C5DC;
        Wed,  8 Jul 2020 04:25:28 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t27so33770619ill.9;
        Wed, 08 Jul 2020 04:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ROJmAmlrv2K7BTumTUPVQDyi0qWehgUULex/JMDOtg=;
        b=T4l4YxNUQK6zjbqIgyyPtPtZPhbJWv5nwD043lVas5RIHsEkMkqLf18GCAo456tjCY
         pgIUPDiCZ29hNKcbB+hZHNz2IWLNnE9pPWGP6eL3UStzgv658p7s6m1QkOKSwxX5lA0c
         ce8gKWBj4/qIG6CjeFJvv7qRoZJ0Q/8oeGY6F82dHYI+kHL7tmmN4T0zkT8dbgSHYOxe
         peD7J79Dr01tgJb9WzCeZjMgJN3gTuv8N05wUGJO8GdFSFqxKG7k//APWJyxnF9dZv3Q
         SB+uQySi+sQqWqqhKASLHLbR9+q07gokqztvN4K/9qtDMNOtlUUsuhK3Mm58fN0ScW3V
         by9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ROJmAmlrv2K7BTumTUPVQDyi0qWehgUULex/JMDOtg=;
        b=PFPgFWGGlKvNcgeKmAUgyQrqg+17GOMaCIsiYCPXj1kCPbMehSs6WFJdxV5T7/mRF7
         ku0hUPm3hh9Ynlb8CNHURmIRXvh590evuKWzqYGrivMLMTomfirG4C85nXW9NFU8NFnu
         +ZU7v4oMIXhghEulvEgxs1Zq8hN/AUoYGwYJth+ZU//pJS59b1TGPnZoChXAFdPM7Lk3
         HjBm1764anpXkGvWDB2aAG+wkdVxRpUeaduwoY12lEj4Eh7QjwPgI4TnCyvsFVp6kkPH
         Uvy9KaqWfxehzfTc/h7SJ8VBSY25HixZTevbHt/RN5Vda+f5jSDUtTJ0K03zhcpNOboY
         OSAg==
X-Gm-Message-State: AOAM532CaPNDV8uu8qTw1QwAZH9GGQcBZU9FTp2BAKIw1OY2EU3o1fLe
        D58Klchuvnp36Q4FeG6YOyuqpp1hulGQ+y5AnkqsccUMTHo=
X-Google-Smtp-Source: ABdhPJyxDeLrfCflP+Xy4iTpQCHzKv+AsR6M56vWlh6bN5a1kfAxmpQpB1A3ivVpGAbrlZ4kYCjZG9sLcHwA0nTcuFQ=
X-Received: by 2002:a05:6e02:970:: with SMTP id q16mr30878956ilt.112.1594207526418;
 Wed, 08 Jul 2020 04:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200708065328.13031-1-grandmaster@al2klimov.de>
In-Reply-To: <20200708065328.13031-1-grandmaster@al2klimov.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 8 Jul 2020 13:25:35 +0200
Message-ID: <CAOi1vP_vS-nNMXuo4n8njx=pRVUQd-C8LAeSTpVTufqiHsCS-g@mail.gmail.com>
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: CEPH COMMON CODE (LIBCEPH)
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 8:53 AM Alexander A. Klimov
<grandmaster@al2klimov.de> wrote:
>
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
>
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
>
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
>
>  If there are any URLs to be removed completely or at least not HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
>
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
>
>  If you apply the patch, please let me know.
>
>
>  net/ceph/ceph_hash.c    | 2 +-
>  net/ceph/crush/hash.c   | 2 +-
>  net/ceph/crush/mapper.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ceph/ceph_hash.c b/net/ceph/ceph_hash.c
> index 9a5850f264ed..81e1e006c540 100644
> --- a/net/ceph/ceph_hash.c
> +++ b/net/ceph/ceph_hash.c
> @@ -4,7 +4,7 @@
>
>  /*
>   * Robert Jenkin's hash function.
> - * http://burtleburtle.net/bob/hash/evahash.html
> + * https://burtleburtle.net/bob/hash/evahash.html
>   * This is in the public domain.
>   */
>  #define mix(a, b, c)                                           \
> diff --git a/net/ceph/crush/hash.c b/net/ceph/crush/hash.c
> index e5cc603cdb17..fe79f6d2d0db 100644
> --- a/net/ceph/crush/hash.c
> +++ b/net/ceph/crush/hash.c
> @@ -7,7 +7,7 @@
>
>  /*
>   * Robert Jenkins' function for mixing 32-bit values
> - * http://burtleburtle.net/bob/hash/evahash.html
> + * https://burtleburtle.net/bob/hash/evahash.html
>   * a, b = random bits, c = input and output
>   */
>  #define crush_hashmix(a, b, c) do {                    \
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 3f323ed9df52..07e5614eb3f1 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -298,7 +298,7 @@ static __u64 crush_ln(unsigned int xin)
>   *
>   * for reference, see:
>   *
> - * http://en.wikipedia.org/wiki/Exponential_distribution#Distribution_of_the_minimum_of_exponential_random_variables
> + * https://en.wikipedia.org/wiki/Exponential_distribution#Distribution_of_the_minimum_of_exponential_random_variables
>   *
>   */
>

Applied with a couple more link fixes folded in.

Thanks,

                Ilya
