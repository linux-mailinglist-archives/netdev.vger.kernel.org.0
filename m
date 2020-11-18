Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2CD2B7C2E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 12:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgKRLO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 06:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRLOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 06:14:25 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0979AC0613D4;
        Wed, 18 Nov 2020 03:14:24 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id j7so1822076wrp.3;
        Wed, 18 Nov 2020 03:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3lVLTHtft+9EnTWp89LC5ry75XIftcYoLGTsHkuSEI=;
        b=cuyfbM3Gnmv0q0lEnj/zahIJAsze5tSV+HYjtUhbtTpDTTTl5R8sdjgwiBnLkzWNs5
         3iwKj63ZLxMsBvgbsznmQhqQc7iO02loZ9JwDwdQMnsPr1L76gy9zewresH3cxxRNco2
         hQaf2flN0qbopYAh7Cfd9ZdxcrRfR++pSJ88GTkGK5v2ubFw3PNVuSbzlUpWB9v4w5/2
         5VwMqs69gSZskgaDZ5v5j+hQTJ7ioEecmya9O3N2oInLMpZ1I23Gb8hu1nYHYnMKmW1f
         8tm0rF0khWob2Unb9bLDbUM6hboZabmNBPQmIUHAmvXVXnLSYL+ZNvtdY1yKCKwTag/j
         FF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3lVLTHtft+9EnTWp89LC5ry75XIftcYoLGTsHkuSEI=;
        b=jJOafrb+WflsZWheIf2TKRURvJzcHRN0mSRCcBUTlfx+oLVo4Z8wkDT7Xa9JCZnXrK
         LKsE+Nc2b62hU75uz996gbaYcN8PYdGhqiASdEHXaEkqhjf8nxeTjSLhdwV/JK1Y5zTH
         BgIvUy3pTP9X3N995mSzglkTe647gY3A0A7GDLNec4Zq+BZMDgTIxCR4j95Qqtmk+Tpq
         Hm6NIidB0eSNtBXJVe5N4NgsJNFLx+YM/WGcUdiPWYcgtvu9rhp9/3yxbXv+9cBqqPnI
         HHuto0go7O8ePQ5HhbkDYc4Wen46i92oC6pB1v5xzjNHI8Z3lPeEjf14HvY4hmVJriFG
         r25A==
X-Gm-Message-State: AOAM5334MrslJYOwvh/M5lYcBykfV1nuBHllIi/UZktv3nPfk/X6iCg3
        40DDUkOQT9ZDi9r4dPVhNcg6zn7YybdB9zAIJQ==
X-Google-Smtp-Source: ABdhPJwhgsRuQfB6oXjbMQreT2rRoZVdWz+p+0mMdTZ2kHP2YSpfSpFEZdRb7Oa8nN1+Z3nZHWuVmw4g/OA4tUveftM=
X-Received: by 2002:a5d:6288:: with SMTP id k8mr4290464wru.30.1605698062631;
 Wed, 18 Nov 2020 03:14:22 -0800 (PST)
MIME-Version: 1.0
References: <20201117095207.GA16407@Sleakybeast> <20201118102307.GA4903@katalix.com>
In-Reply-To: <20201118102307.GA4903@katalix.com>
From:   siddhant gupta <siddhantgupta416@gmail.com>
Date:   Wed, 18 Nov 2020 16:44:11 +0530
Message-ID: <CA+imup-3pT47CVL7GZn_vJtHGngNexBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>
Subject: Re: [PATCH] Documentation: networking: Fix Column span alignment
 warnings in l2tp.rst
To:     Tom Parkin <tparkin@katalix.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Himadri Pandya <himadrispandya@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 at 15:53, Tom Parkin <tparkin@katalix.com> wrote:
>
> On  Tue, Nov 17, 2020 at 15:22:07 +0530, Siddhant Gupta wrote:
> > Fix Column span alignment problem warnings in the file
> >
>
> Thanks for the patch, Siddhant.
>
> Could you provide some information on how these warnings were
> triggered?  Using Sphinx 2.4.4 I can't reproduce any warnings for
> l2tp.rst using the "make htmldocs" target.
>

I am currently using Sphinx v1.8.5 and I made use of command "make
htmldocs >> doc_xxx.log 2>&1" for directing the errors into a file and
the statements in the file showed me these warning, also to confirm
those I tried using "rst2html" on l2tp.rst file and got same set of
warnings.

> > Signed-off-by: Siddhant Gupta <siddhantgupta416@gmail.com>
> > ---
> >  Documentation/networking/l2tp.rst | 26 +++++++++++++-------------
> >  1 file changed, 13 insertions(+), 13 deletions(-)
> >
> > diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking/l2tp.rst
> > index 498b382d25a0..0c0ac4e70586 100644
> > --- a/Documentation/networking/l2tp.rst
> > +++ b/Documentation/networking/l2tp.rst
> > @@ -171,7 +171,8 @@ DEBUG              N        Debug flags.
> >  ================== ======== ===
> >  Attribute          Required Use
> >  ================== ======== ===
> > -CONN_ID            N        Identifies the tunnel id to be queried.
> > +CONN_ID            N        Identifies the tunnel id
> > +                            to be queried.
> >                              Ignored in DUMP requests.
> >  ================== ======== ===
> >
> > @@ -208,8 +209,8 @@ onto the new session. This is covered in "PPPoL2TP Sockets" later.
> >  ================== ======== ===
> >  Attribute          Required Use
> >  ================== ======== ===
> > -CONN_ID            Y        Identifies the parent tunnel id of the session
> > -                            to be destroyed.
> > +CONN_ID            Y        Identifies the parent tunnel id
> > +                            of the session to be destroyed.
> >  SESSION_ID         Y        Identifies the session id to be destroyed.
> >  IFNAME             N        Identifies the session by interface name. If
> >                              set, this overrides any CONN_ID and SESSION_ID
> > @@ -222,13 +223,12 @@ IFNAME             N        Identifies the session by interface name. If
> >  ================== ======== ===
> >  Attribute          Required Use
> >  ================== ======== ===
> > -CONN_ID            Y        Identifies the parent tunnel id of the session
> > -                            to be modified.
> > +CONN_ID            Y        Identifies the parent tunnel
> > +                            id of the session to be modified.
> >  SESSION_ID         Y        Identifies the session id to be modified.
> > -IFNAME             N        Identifies the session by interface name. If
> > -                            set, this overrides any CONN_ID and SESSION_ID
> > -                            attributes. Currently supported for L2TPv3
> > -                            Ethernet sessions only.
> > +IFNAME             N        Identifies the session by interface name. If set,
> > +                            this overrides any CONN_ID and SESSION_ID
> > +                            attributes. Currently supported for L2TPv3 Ethernet sessions only.
> >  DEBUG              N        Debug flags.
> >  RECV_SEQ           N        Enable rx data sequence numbers.
> >  SEND_SEQ           N        Enable tx data sequence numbers.
> > @@ -243,10 +243,10 @@ RECV_TIMEOUT       N        Timeout to wait when reordering received
> >  ================== ======== ===
> >  Attribute          Required Use
> >  ================== ======== ===
> > -CONN_ID            N        Identifies the tunnel id to be queried.
> > -                            Ignored for DUMP requests.
> > -SESSION_ID         N        Identifies the session id to be queried.
> > -                            Ignored for DUMP requests.
> > +CONN_ID            N        Identifies the tunnel id
> > +                            to be queried. Ignored for DUMP requests.
> > +SESSION_ID         N        Identifies the session id
> > +                            to be queried. Ignored for DUMP requests.
> >  IFNAME             N        Identifies the session by interface name.
> >                              If set, this overrides any CONN_ID and
> >                              SESSION_ID attributes. Ignored for DUMP
> > --
> > 2.25.1
> >
