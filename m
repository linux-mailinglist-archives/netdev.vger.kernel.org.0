Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9038A42D7A9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhJNLE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:04:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230119AbhJNLE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 07:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634209371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOHMMzhnrsOQBJrmrRuks5HYXAbADBjndgDYFnDKLEE=;
        b=M+/ivBJm0aAA3//0JVb4to2xwwgiKnzSyPZrutAVzBAPNgQM1ACrfIhyj/NtLAnTuU34yO
        JMDDnUqRDfhDgyXWuHGAaTUljjla9a0VflJtRYbj1HQfetyRdOaDWgWFL9/Sw8pnuaFesI
        GgDAEXytFdCWUQYaJ/rw0t0OYoNw4p4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-LhkP6ClWNyO3c8Gj2TTZVg-1; Thu, 14 Oct 2021 07:02:48 -0400
X-MC-Unique: LhkP6ClWNyO3c8Gj2TTZVg-1
Received: by mail-wr1-f71.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso4233761wrg.16
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 04:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nOHMMzhnrsOQBJrmrRuks5HYXAbADBjndgDYFnDKLEE=;
        b=Ft9NPZiDVn7t/HDFBEKNC1npiFSYNzhbeo2HexYMBliV/jOp8PYErCDJbec2O/C9U2
         AaKfKDZS1D5SM8HpHx+agYILVbfg2IqL38PuC56FKh53Sz+Yq05EQglFs2aiV1NcSlUv
         OJyxsXdSqOnoqZJX2X7gCjFa2QfmO1b00xlxAalSA4s7zbR2YRJgWo2UVvBNuZvyx1Sz
         zUc//kOswKPwS8KHaTJIeKKkPDYL/vrvJPvtYDkylE/O3I68ZJdxO4xJ58b9abWNu4Ry
         oENvNvivJO42eGFTvA12wjciN100oNxnw1z8afWRzRShvisZ6k8uH9eppyaLdWiqxYS1
         gAGA==
X-Gm-Message-State: AOAM53205sFMPhxSuZ+0RszGrififkQ9mIGSVqwpJAIA1YgD+N6l3YzH
        LoezidJCmHkCiFI+BZVH4pEEOuIzyN7CXNx1imZ31Kjp16qK8tQ6GaPgGWIWSLv5vLlOAzf9Ip+
        oex9Jq6FVxFBeg5KS
X-Received: by 2002:a5d:6245:: with SMTP id m5mr5863520wrv.148.1634209366908;
        Thu, 14 Oct 2021 04:02:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjmGsLtuM8exQ0HnE/cyJEhTN65y0OdaHF8VF274GwcgCvQ3rS6zaFzWtrmTI69DcDetnFeg==
X-Received: by 2002:a5d:6245:: with SMTP id m5mr5863501wrv.148.1634209366716;
        Thu, 14 Oct 2021 04:02:46 -0700 (PDT)
Received: from localhost ([37.162.248.107])
        by smtp.gmail.com with ESMTPSA id e8sm3016051wrg.48.2021.10.14.04.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 04:02:46 -0700 (PDT)
Date:   Thu, 14 Oct 2021 13:02:41 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        haliu@redhat.com
Subject: Re: [PATCH iproute2 v5 7/7] configure: add the --libdir option
Message-ID: <YWgOUedjAR+sAtcG@renaissance-vector>
References: <cover.1634199240.git.aclaudi@redhat.com>
 <62f6968cc2647685a0ef8074687ecf12c8c1f3c0.1634199240.git.aclaudi@redhat.com>
 <20211014101053.GJ1668@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014101053.GJ1668@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 12:10:53PM +0200, Phil Sutter wrote:
> Hi Andrea,
> 
> On Thu, Oct 14, 2021 at 10:50:55AM +0200, Andrea Claudi wrote:
> [...]
> > diff --git a/Makefile b/Makefile
> > index 5eddd504..f6214534 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,6 +1,8 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Top level Makefile for iproute2
> >  
> > +-include config.mk
> > +
> 
> Assuming config.mk may be missing (as dash-prefix is used).
> 
> >  ifeq ("$(origin V)", "command line")
> >  VERBOSE = $(V)
> >  endif
> > @@ -13,7 +15,6 @@ MAKEFLAGS += --no-print-directory
> >  endif
> >  
> >  PREFIX?=/usr
> > -LIBDIR?=$(PREFIX)/lib
> 
> Dropping this leads to trouble if config.mk is missing or didn't define
> it. Can't you just leave it in place? Usually config.mk would override
> it anyway, no?

config.mk may miss at the first make call, but the "all" target calls
config.mk, which in turns re-generate it. Thus LIBDIR is defined when
the target all executes.

Also, LIBDIR must be defined in config.mk, as a default value for it is
provided in configure, and will be used if the user does not provide it
at command line.

I verified this deleting config.mk and printing DEFINES in Makefile to
verify it includes the correct path for LIBDIR.

