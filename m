Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254133F38E2
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 07:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhHUFnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 01:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhHUFnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 01:43:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDF3C061760
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 22:43:11 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so8690172pjb.3
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 22:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9sE8/Gezsq3ktVT1yBNWUnjMOxfVYbA50Rdyo+0rKjg=;
        b=i+WrkoXjNKg4kf7Ku0gUlQx7eIoc5b0b0YLG92TKYL9BVo0rPqj+uzdLB+MjPabU3J
         HjWDWfEsdrVtR+NH2G9+XReIX26V18hHaRdIgzgV8JpSXS7H5HUc9NyL4mjtoZdJexDM
         PZIXoQghEQmI+ZcvoTlg3lVMhlUTAKbTqJLVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9sE8/Gezsq3ktVT1yBNWUnjMOxfVYbA50Rdyo+0rKjg=;
        b=GT+yhNzP+U/qkp2KxsXeAbYIPh0T/coxyNWfZ2aUhDadLuz8CzrY6SvvlVkdPq9dPi
         xXvP6vw08xKLRNDuM7SczaLbBwByD3QOHmnci5+o2j/kRFCi7enmiv257ajqAU733357
         61I5+w6OyE8s256/jRU0vLglTJpbWUVXiVhBFkrBdfxtFPtmNQWoyGvV4Nrm+LEb4KSa
         Hx1sVSV2SIerinK60eukAkfNzWb3SlUbF9rMaCxF0RSVQAgfTuN3NAdkihrC4eW+shCX
         wsgkzuc+7WZZy1q8VcVuSaIVLmwuDrlHomr7C7Rb+w/hzUlMkfw7qOwId720gg8PRNqj
         FLUg==
X-Gm-Message-State: AOAM532xjJsJZM4AhLuh6Z5CdHhejq/8seaSZw9J90g+J5Y+wP5sgELC
        kGTSQuOCo75f0b9LImXCvnZD0A==
X-Google-Smtp-Source: ABdhPJzgQUYdkk9J8dqAROFTOnmvvqyCpq+uP6WafjZ2SeuiM0a5Vtnmi8qv2wGXx2oleUl8CurB6g==
X-Received: by 2002:a17:902:bb92:b0:12d:ad99:7fb6 with SMTP id m18-20020a170902bb9200b0012dad997fb6mr19095378pls.49.1629524590503;
        Fri, 20 Aug 2021 22:43:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n11sm7570761pjf.17.2021.08.20.22.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 22:43:09 -0700 (PDT)
Date:   Fri, 20 Aug 2021 22:43:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        LukasBulwahn <lukas.bulwahn@gmail.com>,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-csky@vger.kernel.org
Subject: Re: What is the oldest perl version being used with the kernel ?
 update oldest supported to 5.14 ?
Message-ID: <202108201856.41AB391@keescook>
References: <37ec9a36a5f7c71a8e23ab45fd3b7f20efd5da24.camel@perches.com>
 <YR/zrjiCwnzMMcmA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR/zrjiCwnzMMcmA@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 07:25:50PM +0100, Matthew Wilcox wrote:
> On Fri, Aug 20, 2021 at 10:27:59AM -0700, Joe Perches wrote:
> > Perl 5.8 is nearly 20 years old now.
> > 
> > https://en.wikipedia.org/wiki/Perl_5_version_history
> > 
> > checkpatch uses regexes that are incompatible with perl versions
> > earlier than 5.10, but these uses are currently runtime checked
> > and skipped if the perl version is too old.  This runtime checking
> > skips several useful tests.
> > 
> > There is also some desire for tools like kernel-doc, checkpatch and
> > get_maintainer to use a common library of regexes and functions:
> > https://lore.kernel.org/lkml/YR2lexDd9N0sWxIW@casper.infradead.org/
> > 
> > It'd be useful to set the minimum perl version to something more modern.
> > 
> > I believe perl 5.14, now only a decade old, is a reasonable target.
> > 
> > Any objections or suggestions for a newer minimum version?
> 
> Not an objection per se, but some data points.
> 
> Oracle Linux 5 (released 2007, still under support) has perl 5.8.8
> Oracle Linux 6 (released 2011) has perl 5.10.1
> Oracle Linux 7 (released 2014) has perl 5.16.3
> Oracle Linux 8 (released 2019) has perl 5.26.3
> 
> I don't know that we need to be able to build on a distro from 2007
> or even from 2011.  I think it's reasonable to require updating to a
> 2014 distro in order to build a 2021 kernel.
> 
> For comparison, we currently require gcc-4.9 to build the kernel, and
> 4.9.0 was released in 2014.  So perl-5.16 wouldn't be an unreasonable
> requirement, I believe.

Ubuntu name/version mapping: https://wiki.ubuntu.com/
Ubuntu Perl versions: https://launchpad.net/ubuntu/+source/perl

The oldest publicly supported Ubuntu (18.04 Bionic) uses Perl 5.26.

-- 
Kees Cook
