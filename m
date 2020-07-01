Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0427F2108D1
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgGAKCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:02:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53480 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729339AbgGAKCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 06:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593597724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fyxg+Ji0zQrI7znU85VBdvoQ2fhrXxY8f/1fcLyLeJ0=;
        b=YJ89t1rXU0mwaLgBr6sfZ6qPf714/jcadlleFORW6lZ9fKFR3686kWLvpaFMMfA7B012px
        n0ZrfdLpGSjWTaPwkBr7yFasJs3R+lsI5jUOzDxzMdJ0u84GDyo7Yd2SwOqrgk4lNNpI2J
        ae4HrqGxhhLrIL+AOvWJU2nfDyHBiDU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-IWwmh9exO9iVhuT9BL_eaQ-1; Wed, 01 Jul 2020 06:02:03 -0400
X-MC-Unique: IWwmh9exO9iVhuT9BL_eaQ-1
Received: by mail-wr1-f69.google.com with SMTP id a18so20030353wrm.14
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 03:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fyxg+Ji0zQrI7znU85VBdvoQ2fhrXxY8f/1fcLyLeJ0=;
        b=pOD6ITJ4iEIEFh1cSdksz+a743bD4IukkHS1iE2h2A3DRyFZdVo6T8cWn71xg1oV72
         CgRcsbphU2ZGPSak5rbrhaCSwMZLe3mdM93oWz3skXTN3TszGueO/mcGUpWodXVFYPyh
         n7FuaXjFkeHu8L0QH9CAhGT8hJOC5nXsv2uoO1FzyIltrDI9Uo9rdkiFejO5LxkNu/Gs
         Phb+35jRYIr1mP69ILrShrPIkkB5oNLKfifVWo22C+O3PLSIQCYCNN9MLOpYr0XrD6JR
         fv5QntzsgWIYYY1RLoGYEeS9L0j7SdqPJoVr23k1XSnM+vZZuVBPoYwr3FfBCQ9kRJ6p
         ZlSw==
X-Gm-Message-State: AOAM531nbxuYU3AyFAS4Ciqs85aJQoBR4IA6MNzIzqo4wwo5xyr7r4SU
        IYLWW++rwH6cgLH+SeisKFuPanbYvJgr7XFdbNbq/jwt+peBqZ/PwTyBGIek+wox0a4anh3/4O4
        Y/Q1QntyisGDmTcJy
X-Received: by 2002:a5d:6990:: with SMTP id g16mr17775553wru.131.1593597721880;
        Wed, 01 Jul 2020 03:02:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaLkNNY2PFBcdWh7z+i2muEDeNV0SFL3xWpfilNonnOr01o+NHCg68vUn9kh0HctYjz3JADg==
X-Received: by 2002:a5d:6990:: with SMTP id g16mr17775535wru.131.1593597721627;
        Wed, 01 Jul 2020 03:02:01 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id v66sm6847252wme.13.2020.07.01.03.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 03:02:01 -0700 (PDT)
Date:   Wed, 1 Jul 2020 12:01:59 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] tc: flower: support multiple MPLS LSE match
Message-ID: <20200701100159.GA18417@pc-3.home>
References: <4c364e19b552a746489dd978677d7b25cee913cf.1592563668.git.gnault@redhat.com>
 <CAPpH65ymT_peXCvG5+fKYD0ZpNk5=M-=-4Hp9BiXqVBu66cz=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPpH65ymT_peXCvG5+fKYD0ZpNk5=M-=-4Hp9BiXqVBu66cz=g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 11:17:56AM +0200, Andrea Claudi wrote:
> On Fri, Jun 19, 2020 at 12:51 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > +.BI depth " DEPTH"
> > +The depth of the Label Stack Entry to consider. Depth starts at 1 (the
> > +outermost Label Stack Entry). The maximum usable depth may be limitted by the
> 
> limited

Looks like I forgot the spell-checking step before submitting :/

> > +static int flower_parse_mpls(int *argc_p, char ***argv_p, struct nlmsghdr *nlh)
> > +{
> > +       struct rtattr *mpls_attr;
> > +       char **argv = *argv_p;
> > +       int argc = *argc_p;
> > +
> > +       mpls_attr = addattr_nest(nlh, MAX_MSG,
> > +                                TCA_FLOWER_KEY_MPLS_OPTS | NLA_F_NESTED);
> > +
> > +       while (argc > 0) {
> > +               if (matches(*argv, "lse") == 0) {
> > +                       NEXT_ARG();
> > +                       if (flower_parse_mpls_lse(&argc, &argv, nlh) < 0)
> > +                               return -1;
> > +               } else {
> > +                       break;
> > +               }
> > +       }
> 
> This can probably be simplified to:
> 
> while (argc > 0 && matches(*argv, "lse") == 0) {
>     NEXT_ARG();
>     if (flower_parse_mpls_lse(&argc, &argv, nlh) < 0)
>         return -1;
> }

I wanted to use the same loop construct as is commonly used for parsing
options in iproute2. I find it easier to verify code correctness when
the same construct is used consistently.
Also this allows to easily add new keywords in the future, even though
I can't see a need for that at the moment.

I'll keep my original while() loop for the moment, unless more voices
speak against it.

Thanks a lot for the review!

