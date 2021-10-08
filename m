Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F0C426E8B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhJHQVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:21:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbhJHQVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 12:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633709991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oV+RxjwCaqN3lMVsu5U3BPc4ztQYMb+4uqU9pnqZ3ww=;
        b=aHjBH0R0poeEbB0xVoJ52AnmES91yq9gCAl/dhnCpm1BH2hZLfM5i4WfZnyG+f10POJqF8
        kzDeUPyiXJBmWd/C2G09A2MBP0zl9QGHhbOsZLDnZrOUpp8mgGq/OBgOsPisqG44ZUh0r5
        v55+dNcLhmS5hWyeh8tn6ZM3nDqJFvA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-8XSun_7RM42DqjEk1G7JFA-1; Fri, 08 Oct 2021 12:19:50 -0400
X-MC-Unique: 8XSun_7RM42DqjEk1G7JFA-1
Received: by mail-wr1-f70.google.com with SMTP id o2-20020a5d4a82000000b00160c6b7622aso7632569wrq.12
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 09:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oV+RxjwCaqN3lMVsu5U3BPc4ztQYMb+4uqU9pnqZ3ww=;
        b=OHMxmFXa49i4R1bl/mX9yDRExjiycl+Vzcmasr74ZgpPL/gmRthZhPhufk8dDWUa6Q
         Tl+OGyv194HLS+KvueECMMZAFCRAJx+XwVI0ipCNce47/7Uwo4y81B8SAhaTx32/Vw64
         Uv6OeQaFhjyBHyt9oN+hOlIZ05W2l90xyOxFUIhn9RBwwBlh4eLkfvBOiQckylG4YBZw
         wzNx0IIQXgpBuGaSXN3WG8sTCM9MVlTMS3GkkRYTsmITQHymGp9ocSs5WxKaepbwnbZL
         zj9H9xIT7qxD5nhd55ks+Q3XTqj+Ufc87ycPkvk/dJNphadXE8YXyXh2ineHRmDoj7lV
         eKww==
X-Gm-Message-State: AOAM5327UJzhXNuf5EcNsWc0QYhUZZs68S4y6dvRlRASnlk2hNoFwgOn
        JcJkbe3LTSa+mU8RGCgE2wIiMe8LL4CQ7WWEJl5GlIEfvg7eKILj+rNeRT77UoLEcCJxX0LkXvo
        YwRxjULLZ8/jG93ZC
X-Received: by 2002:adf:8b41:: with SMTP id v1mr5328699wra.255.1633709989762;
        Fri, 08 Oct 2021 09:19:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxat0rr4t4TWzwFdNJIBYq0YHDtySMK2BP9q5IHFtb0bSVB/YSQH21ng0/9X/4TDuDU6ahFug==
X-Received: by 2002:adf:8b41:: with SMTP id v1mr5328663wra.255.1633709989509;
        Fri, 08 Oct 2021 09:19:49 -0700 (PDT)
Received: from localhost ([37.163.173.167])
        by smtp.gmail.com with ESMTPSA id u2sm2797502wrr.35.2021.10.08.09.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 09:19:49 -0700 (PDT)
Date:   Fri, 8 Oct 2021 18:19:44 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        haliu@redhat.com
Subject: Re: [PATCH iproute2 v4 0/5] configure: add support for libdir and
 prefix option
Message-ID: <YWBvoFW1RDQDYAGx@renaissance-vector>
References: <cover.1633612111.git.aclaudi@redhat.com>
 <20211007160202.GG32194@orbyte.nwl.cc>
 <YWBCx6yvm7gDZNId@renaissance-vector>
 <20211008135025.GM32194@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008135025.GM32194@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 03:50:25PM +0200, Phil Sutter wrote:

[...]

> > This avoid the endless loop and allows configure to terminate correctly,
> > but results in an error anyway:
> > 
> > $ ./configure --include_dir
> > ./configure: line 544: shift: shift count out of range
> 
> Ah, I didn't see it with bash. I don't think it's a problem though:
> Input is invalid, the loop is avoided and (depending on your patches)
> there will be another error message complaining about invalid $INCLUDE
> value.
> 

Yes, this error can be disregarded. Still I would try to avoid a
meaningless error message, if possible.

[...]

> 
> Which sounds like you'll start accepting things like
> 
> | ./configure --include_dir foo bar
> 

We already accept things like this in the current configure, and I would
try to not modify current behaviour as much as possible.

[...]

> > > Can't you just:
> > > 
> > > | [ -n "$PREFIX" ] && echo "PREFIX=\"$PREFIX\"" >>config.mk
> > > | [ -n "$LIBDIR" ] && echo "LIBDIR=\"$LIBDIR\"" >>config.mk
> > > 
> > > and leave the default ("?=") cases in Makefile in place?
> > > 
> > > Either way, calling 'eval' seems needless. I would avoid it at all
> > > costs, "eval is evil". ;)
> > 
> > Unfortunately this is needed because some packaging systems uses
> > ${prefix} as an argument to --libdir, expecting this to be replaced with
> > the value of --prefix. See Luca's review to v1 for an example [1].
> > 
> > I can always avoid the eval trying to parse "${prefix}" and replacing it
> > with the PREFIX value, but in this case "eval" seems a bit more
> > practical to me... WDYT?
> 
> Do autotools support that? If not, I wouldn't bother.

I don't know about autotools, but Debian packaging system makes use of
this, and we cannot break their workflow.

Regards,
Andrea

