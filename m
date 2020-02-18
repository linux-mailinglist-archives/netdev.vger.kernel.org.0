Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7B7161F25
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgBRDAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:00:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37481 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgBRDAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:00:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so22076849wru.4
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 19:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=forXypwFhiCcSwcZWMvpRbaAjJdMXFGHbQSOfj/guLI=;
        b=A0BMVJbjOlMGE67cTMt0tsXw+cKmtyDMIHRRQhWiG6sI1YQ3v/JxguOCt05L1yJMk1
         /7y3rM8xX6+R1+1/q4uvYpE+z4yZlcekrJByqb9Eias7bIp0WATKqiB2i9Co8PD0mI74
         KzLEOcd+gI8XGLefhpIU7gAGOYu+DbTz7+Lc7G0nBiSQ8rxF4jbJN2fIsGaIaoRSbjLa
         MkV9pXCEHfNgu6Qg4X448wupCz27LD/qfK75V9Z2UCpb6SspP0bCF9YEHsq80bLR736b
         H3WoJUV/c+LLf0hUCeDAp7EPUB0v+Om53oZ3ixLuhHMvH2jENahwfuB8Afy8LAtEdDzN
         P4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=forXypwFhiCcSwcZWMvpRbaAjJdMXFGHbQSOfj/guLI=;
        b=rVWtODjrFxmqLWW/U9kUpvsKGKZxI4hGg1E9beG87MkoWpy0LdIcG/OgAMMASHVVLr
         KZnPC9iy5cn23lXlTaYQMT8XXk5r2YsV1eoxkcImBoCx4Fjh2c6clb31h8S1s4WbORZk
         VVXy1gYRzNvMhvB2dBKYb6zyB/Xn9HWtFhfosJM2O4h6eAHn3Iz19Fn5cCee7/0sENaE
         dkRWJj9YIIXqHzOx7Row6B3yTQ3a9/mqXJDkkAKYY363+uVQcrXQuSb72VXh8GOrevzm
         tsi4EFFAfOHICBoeDLXDOrydv+tMueX4Y33PXoIpB9X1TRZovum7JLglU6Xq5MqQwXKL
         K5Sg==
X-Gm-Message-State: APjAAAWStTIb3HzOBKcWhc/HR0ZMjCzVTB+nD1q9aQIorjZBqQdYeEqw
        AAdcdPat2XmFOlyN9/9pLG1S/3SxjT9eZEG+s69U0jlx
X-Google-Smtp-Source: APXvYqzleHJ8CoYnXVix2VWYTCNclx2Gijkfbupv8bPqRRwjdtPnCYp+zAQmFuqR0Db2TrRTm54igz83vmGVNYSdNuk=
X-Received: by 2002:a5d:6388:: with SMTP id p8mr25493584wru.299.1581994847428;
 Mon, 17 Feb 2020 19:00:47 -0800 (PST)
MIME-Version: 1.0
References: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581933223.git.lucien.xin@gmail.com>
 <34272893-fce7-4ad7-8f07-57ae01493b39@gmail.com>
In-Reply-To: <34272893-fce7-4ad7-8f07-57ae01493b39@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 18 Feb 2020 11:01:46 +0800
Message-ID: <CADvbK_dstTtXSz-jRgGvgDC8gXxpuH6kF7a=3WanfoGzGso74g@mail.gmail.com>
Subject: Re: [PATCH iproute2] erspan: set erspan_ver to 1 by default
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 3:07 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/17/20 2:53 AM, Xin Long wrote:
> > Commit 289763626721 ("erspan: add erspan version II support")
> > breaks the command:
> >
> >  # ip link add erspan1 type erspan key 1 seq erspan 123 \
> >     local 10.1.0.2 remote 10.1.0.1
> >
> > as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
> > won't be set in gre_parse_opt().
> >
> >   # ip -d link show erspan1
> >     ...
> >     erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
> >                                               ^^^^^^^^^^^^^^
> >
> > This patch is to change to set erspan_ver to 1 by default.
> >
> > Fixes: 289763626721 ("erspan: add erspan version II support")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  ip/link_gre.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/ip/link_gre.c b/ip/link_gre.c
> > index 15beb73..e42f21a 100644
> > --- a/ip/link_gre.c
> > +++ b/ip/link_gre.c
> > @@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
> >       __u8 metadata = 0;
> >       __u32 fwmark = 0;
> >       __u32 erspan_idx = 0;
> > -     __u8 erspan_ver = 0;
> > +     __u8 erspan_ver = 1;
> >       __u8 erspan_dir = 0;
> >       __u16 erspan_hwid = 0;
> >
> >
>
> that seems correct to me.
>
> What about the v6 version? It defaults to 0 as well by the same Fixes tag.
yeah right, will post v2. Thanks.
