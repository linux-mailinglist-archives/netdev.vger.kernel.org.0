Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA785426B78
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242165AbhJHNK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230258AbhJHNK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633698510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9frZenqPPaUX2o04u3FU7+8valgnbzmeD9UUL0oqtOc=;
        b=T3lxiWKa455W5MzGN7SZmjJpZVU0VIMStsV+sr7h/46MetneiNzR64kblbg9lBhE/9vfHG
        sgOO0FBKYeHHaOSyzcpjG2sSRPNqeVGq91XaW7XGqrnEfebtjwRcx/PZAXwA2ztxgc70AD
        21FdpXBeLfyrkcLRoicpL5xK2/MYovY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-P4PPCL78OMKdCu1j4tDzhQ-1; Fri, 08 Oct 2021 09:08:29 -0400
X-MC-Unique: P4PPCL78OMKdCu1j4tDzhQ-1
Received: by mail-wr1-f72.google.com with SMTP id v15-20020adfa1cf000000b00160940b17a2so7275693wrv.19
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 06:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9frZenqPPaUX2o04u3FU7+8valgnbzmeD9UUL0oqtOc=;
        b=F/yVQdoY28ndGIXRFPwR1CeIzHyph4ueZmJxguNrll7klC/QHAPX4KVHTJ6hxx+5yD
         jq/O+BK42AKykc8oGt8qVKQKS2lEmzGtiJLKkS0SCnZZ06HKnW84DnziHYA7IOodzCSb
         C/pRY2IFg1aNV//Qs4RN6KhJn6NR3uvE9ev2CZ/+jumuWDowlzEvoCjiElD8Bp2S6ghh
         /kRWisY0fLvUe5DIT8zYBtnWVtpILjEpU16hoMr0gqgBi1tbFqNllqoNexM881ngS8y3
         HTFRQ6r4qH9Or3qoP7wXq6s8/5sqZbtsYDvmmCp59/uwkXh2Ifz9zcQ/ogfPzrVzWMf2
         57bQ==
X-Gm-Message-State: AOAM532ssx5m+zj84IlODQUflnLp1NOed0mYcWBO950ysXQyVb9mOSyz
        HVQmhlcdfmsMhgLUSaVxAloc/YvdJ4nY3Wef+gnsRBGtnnVsOd8aWVEufmBnFynlxsvntNKgm22
        Fj9s4+y/mv7rKEqG0
X-Received: by 2002:a05:600c:35d4:: with SMTP id r20mr3406177wmq.24.1633698508699;
        Fri, 08 Oct 2021 06:08:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA/sMEj9z1Gmz3B9GWfxD4/rc2GrTDgkJzbiD+HtZjG3jJP3rRmuC4rU1u0yMNQZ5p+pndTQ==
X-Received: by 2002:a05:600c:35d4:: with SMTP id r20mr3406157wmq.24.1633698508414;
        Fri, 08 Oct 2021 06:08:28 -0700 (PDT)
Received: from localhost ([37.163.173.167])
        by smtp.gmail.com with ESMTPSA id g144sm12776724wmg.5.2021.10.08.06.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 06:08:28 -0700 (PDT)
Date:   Fri, 8 Oct 2021 15:08:23 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        haliu@redhat.com
Subject: Re: [PATCH iproute2 v4 0/5] configure: add support for libdir and
 prefix option
Message-ID: <YWBCx6yvm7gDZNId@renaissance-vector>
References: <cover.1633612111.git.aclaudi@redhat.com>
 <20211007160202.GG32194@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007160202.GG32194@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:02:02PM +0200, Phil Sutter wrote:
> Hi Andrea,
> 
> On Thu, Oct 07, 2021 at 03:40:00PM +0200, Andrea Claudi wrote:
> > This series add support for the libdir parameter in iproute2 configure
> > system. The idea is to make use of the fact that packaging systems may
> > assume that 'configure' comes from autotools allowing a syntax similar
> > to the autotools one, and using it to tell iproute2 where the distro
> > expects to find its lib files.
> > 
> > Patches 1-2 fix a parsing issue on current configure options, that may
> > trigger an endless loop when no value is provided with some options;
> 
> Hmm, "shift 2" is nasty. Good to be reminded that it fails if '$# < 2'.
> I would avoid the loop using single shifts:
> 
> | case "$1" in
> | --include_dir)
> | 	shift
> | 	INCLUDE=$1
> | 	shift
> | 	;;
> | [...]
> 

This avoid the endless loop and allows configure to terminate correctly,
but results in an error anyway:

$ ./configure --include_dir
./configure: line 544: shift: shift count out of range

But thanks anyway! Your comment made me think again about this, and I
think we can use the *) case to actually get rid of the second shift.

Indeed, when an option is specified, the --opt case will shift and get
its value, then the next while loop will take the *) case, and the
second shift is triggered this way.

> > Patch 3 introduces support for the --opt=value style on current options,
> > for uniformity;
> 
> My idea to avoid code duplication was to move the semantic checks out of
> the argument parsing loop, basically:
> 
> | [ -d "$INCLUDE" ] || usage 1
> | case "$LIBBPF_FORCE" in
> | 	on|off|"") ;;
> | 	*) usage 1 ;;
> | esac
> 
> after the loop or even before 'echo "# Generated config ...'. This
> reduces the parsing loop to cases like:
> 
> | --include_dir)
> | 	shift
> | 	INCLUDE=$1
> | 	shift
> | 	;;
> | --include_dir=*)
> | 	INCLUDE=${1#*=}
> | 	shift
> | 	;;
>

Thanks. I didn't think about '-d', this also cover corner cases like:

$ ./configure --include_dir --libbpf_force off

that results in INCLUDE="--libbpf_force".

> > Patch 4 add the --prefix option, that may be used by some packaging
> > systems when calling the configure script;
> 
> So this parses into $PREFIX and when checking it assigns to $prefix but
> neither one of the two variables is used afterwards? Oh, there's patch
> 5 ...
> 
> > Patch 5 add the --libdir option, and also drops the static LIBDIR var
> > from the Makefile
> 
> Can't you just:
> 
> | [ -n "$PREFIX" ] && echo "PREFIX=\"$PREFIX\"" >>config.mk
> | [ -n "$LIBDIR" ] && echo "LIBDIR=\"$LIBDIR\"" >>config.mk
> 
> and leave the default ("?=") cases in Makefile in place?
> 
> Either way, calling 'eval' seems needless. I would avoid it at all
> costs, "eval is evil". ;)

Unfortunately this is needed because some packaging systems uses
${prefix} as an argument to --libdir, expecting this to be replaced with
the value of --prefix. See Luca's review to v1 for an example [1].

I can always avoid the eval trying to parse "${prefix}" and replacing it
with the PREFIX value, but in this case "eval" seems a bit more
practical to me... WDYT?

Regards,
Andrea

[1] https://lore.kernel.org/netdev/6363502d3ce806acdbc7ba194ddc98d3fac064de.camel@debian.org/

