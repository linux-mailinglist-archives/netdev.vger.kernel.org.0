Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FBF21206E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgGBJ5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:57:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41521 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726862AbgGBJ5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593683872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f3kfuWYGlC50GXlnOMv1+hQ30xOg3rl9x08/Uls8sYc=;
        b=MLD1NWq1U3KBlT2A4nqK7J9NLbQ5Kic5VDFzPlbXr10D9fLarO7CYgrt81gfPSzhC1+88g
        nQmZ/soSfNjP3SXlsfsUrxJWkD9JIr2VoZaYm0dTJY/CoGkG3O2M4RGs8e8J/Ps1q60KHr
        bJ0G5WxreMHDuVifLzvJxYy1BNRlC4E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-gOMT12j2M0uHzFLoihjT3A-1; Thu, 02 Jul 2020 05:57:50 -0400
X-MC-Unique: gOMT12j2M0uHzFLoihjT3A-1
Received: by mail-wm1-f71.google.com with SMTP id g6so21929638wmk.4
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f3kfuWYGlC50GXlnOMv1+hQ30xOg3rl9x08/Uls8sYc=;
        b=O4KORsPhanTdAJSoorR1cSS0+z3g0dz2+FWa/B+3s9pg+VXiUZ0ZFc3F/8YIeHAdO2
         ENVZEHJkO3s7GwGmZp2VIA3Vu14HGI5/LRYx4G71une1fEoONivoIxjGy0pVEBld7o2D
         Y0BQaN4fFS/kMMnnmya8cLOaLqfm8171WMB02aLjQsDT/L+vSmJlxaKc0e+j6ritHaNu
         ZGfMlv/CDiS1Jgi6SmhZfeoso3XkOLdnQ+XzkpEARez8Gf3/3iALGfmtLVbrKSmEJXZs
         zgwK/w3rKEmbkEAft7JcNRtIIo+Dfg6ClXHchQoHw6yOOECZdUd8RqP/i5pm0LK+JW3F
         cHlg==
X-Gm-Message-State: AOAM5309AYr2cehboXoPVEvuwQgtcA43xr/uYPlJpsa3ztS/mW6FYLmi
        PTMXwFsYayUFQm3O+mpjYU+Uap2M06dV/jzUIOJB5yyfNodrmdL5q3hHidrJRC51lHKF312CQU3
        EAmc1dtO7QtIgeqCI
X-Received: by 2002:a5d:6990:: with SMTP id g16mr22438329wru.131.1593683868908;
        Thu, 02 Jul 2020 02:57:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIuBx0g5KUbZxdFPgRpnvrt+J1lGK6D/nDrSxbG9TMyl4amZhM6O1UQIvOhDuZDNvWv5SsHg==
X-Received: by 2002:a5d:6990:: with SMTP id g16mr22438319wru.131.1593683868709;
        Thu, 02 Jul 2020 02:57:48 -0700 (PDT)
Received: from pc-2.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id c2sm10490089wrv.47.2020.07.02.02.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:57:48 -0700 (PDT)
Date:   Thu, 2 Jul 2020 11:57:46 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devicesy
Message-ID: <20200702095746.GA3913@pc-2.home>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200702091539.GA2793@martin-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702091539.GA2793@martin-VirtualBox>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 02:45:39PM +0530, Martin Varghese wrote:
> On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> > +		} else if (matches(*argv, "ethertype") == 0)  {
> > +			NEXT_ARG();
> > +			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
> > +				     "ethertype", *argv);
> > +			if (ll_proto_a2n(&ethertype, *argv))
> Does this function takes care of mpls proto names ?
> 
> The original idea of bareudp is to allow even reserved ethertypes.Hence i think we
> must take ethertype in hex aswell

ll_proto_a2n() handles both symbolic and numeric ethertypes.

> > +				invarg("ethertype", *argv);
> > +		} else if (matches(*argv, "srcportmin") == 0) {
> > +			NEXT_ARG();
> > +			check_duparg(&attrs, IFLA_BAREUDP_SRCPORT_MIN,
> > +				     "srcportmin", *argv);
> > +			if (get_u16(&srcportmin, *argv, 0))
> > +				invarg("srcportmin", *argv);
> > +		} else if (matches(*argv, "multiproto") == 0) {
> > +			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
> > +				     *argv, *argv);
> > +			multiproto = true;
> > +		} else if (matches(*argv, "nomultiproto") == 0) {
> do we need nomultiproto flag. Is it redundant

It allows users to exlicitely disable multiproto without having to rely
on default values. Also nomultiproto appears in the detailed output, so
it should be usable as input.

> > +	if (tb[IFLA_BAREUDP_MULTIPROTO_MODE])
> > +		print_bool(PRINT_ANY, "multiproto", "multiproto ", true);
> > +	else
> > +		print_bool(PRINT_ANY, "multiproto", "nomultiproto ", false);
> Comments from stephen@networkplumber.org on the first version patch is given below
> 
> One of the unwritten rules of ip commands is that the show format
> should match the command line arguments.  In this case extmode is
> really a presence flag not a boolean. best to print that with
> json null command.

The detailed output prints either "multiproto" or "nomultiproto". Both
keywords are accepted as configuration input. I can't see any deviation
from the unwritten rule here.

