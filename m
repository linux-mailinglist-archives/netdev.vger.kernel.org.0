Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B066142E77
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfFLSTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:19:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39280 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFLSTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:19:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so10154039pfe.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LJbZPXroroVEhMsStPS6WHEobyePt++cAb0huFVT+mc=;
        b=WMQWIe6d93Pft/ierGrQsk8oO3WJxjQLrTnKxBtvSG7qHpsatZdD5SIm7eJ1tsxlYo
         qEXe1YtREHMGynZV4IuA9HYXq8EzXUADFuawNSXdeuISbTcRLEed5jY86ozj2vxY9HGf
         miUnv92nJXjkMASsQMdHXGDF7WSq/0p0bAxbGrQfGLZ5ckF0lM2kLV+MkoHYe8ZjouXi
         CKAR7K9Hwhq3qWjM3GaAeuruwcg2b8h2rsfv+6nyMl7GQl+KLPY7rvAu97Nor8Gm/iOk
         f1MHKxOy3KwuJL+npZGaMKE6KGiPDpJOagfc13jgFvSvbzWDkTl7/v2rg4VsylyDUxPI
         P1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LJbZPXroroVEhMsStPS6WHEobyePt++cAb0huFVT+mc=;
        b=jzzDq+RspnR7m3dTc1nr4gcPiUSFGSp4IaU/vYRqh3Dhami0TXWFNzlw8o8BX0sugs
         eMI/c4rhW3xKTNxuAT1LSyEvd4odmBvhgOu8hyef6XRZJsSfaZizT1Z+OEKwfJ1cTDiS
         FVMyq99S1TpOO75Tykz7EfgUwnig0KmPPTMLH5Hfiy++nYcbaAJ9fqAGgOliWWmQLg5o
         q63pkkNvDJkCfxi/bMjKqwsDLs+WwupXKuBZLGMVnTkPUKdkaWJ5k5q1vzv5R+bTdMRS
         rIEuT/EULZNUC5AjfOpiInnqNN7l8KhZl6Y1rih/yt8OzywhWHCE13M2IslYLoyB9Cs8
         d2IA==
X-Gm-Message-State: APjAAAXF98mzGYDIHLjy1FLqcriDyt6aqNk3Kz5dIV8JFmcrVVue/WUO
        KzStQo5X9GHornCjWIXOHfBvCg==
X-Google-Smtp-Source: APXvYqyhwRFqh7wiafQwU8PS7W7JInNwoxJc8Fa6sSdX+Et6G2m8rEYJ3joxzobdJKj6U0r/A/EjJA==
X-Received: by 2002:a65:5889:: with SMTP id d9mr242029pgu.39.1560363585324;
        Wed, 12 Jun 2019 11:19:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d6sm119413pjo.32.2019.06.12.11.19.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:19:45 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:19:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] testsuite: don't clobber /tmp
Message-ID: <20190612111938.1c9da723@hermes.lan>
In-Reply-To: <CAGnkfhz-W64f-j+Sgbi47BO6VKfyaYQ1W865sihXhCjChh_kFQ@mail.gmail.com>
References: <20190611180326.30597-1-mcroce@redhat.com>
        <20190612085307.35e42bf4@hermes.lan>
        <CAGnkfhyT0W=CYU8FJYrDtzqxtcHakO5CWx2qzLuWOXVj6dyKMA@mail.gmail.com>
        <CAGnkfhz-W64f-j+Sgbi47BO6VKfyaYQ1W865sihXhCjChh_kFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 19:32:29 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> On Wed, Jun 12, 2019 at 6:04 PM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > On Wed, Jun 12, 2019 at 5:55 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:  
> > >
> > > On Tue, 11 Jun 2019 20:03:26 +0200
> > > Matteo Croce <mcroce@redhat.com> wrote:
> > >  
> > > > Even if not running the testsuite, every build will leave
> > > > a stale tc_testkenv.* file in the system temp directory.
> > > > Conditionally create the temp file only if we're running the testsuite.
> > > >
> > > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > > ---
> > > >  testsuite/Makefile | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/testsuite/Makefile b/testsuite/Makefile
> > > > index 7f247bbc..5353244b 100644
> > > > --- a/testsuite/Makefile
> > > > +++ b/testsuite/Makefile
> > > > @@ -14,7 +14,9 @@ TESTS_DIR := $(dir $(TESTS))
> > > >
> > > >  IPVERS := $(filter-out iproute2/Makefile,$(wildcard iproute2/*))
> > > >
> > > > -KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > > > +ifeq ($(MAKECMDGOALS),alltests)
> > > > +     KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > > > +endif
> > > >  ifneq (,$(wildcard /proc/config.gz))
> > > >       KCPATH := /proc/config.gz
> > > >  else
> > > > @@ -94,3 +96,4 @@ endif
> > > >               rm "$$TMP_ERR" "$$TMP_OUT"; \
> > > >               sudo dmesg > $(RESULTS_DIR)/$@.$$o.dmesg; \
> > > >       done
> > > > +     @$(RM) $(KENVFN)  
> > >
> > > My concern is that there are several targets in this one Makefile.
> > >
> > > Why not use -u which gives name but does not create the file?  
> >
> > As the manpage says, this is unsafe, as a file with the same name can
> > be created in the meantime.
> > Another option is to run the mktemp in the target shell, but this will
> > require to escape every single end of line to make it a single shell
> > command, e.g.:
> >
> >         KENVFN=$$(mktemp /tmp/tc_testkenv.XXXXXX); \
> >         if [ "$(KCPATH)" = "/proc/config.gz" ]; then \
> >                 gunzip -c $(KCPATH) >$$KENVFN; \
> >         ...
> >         done ; \
> >         $(RM) $$KENVFN
> >
> > --
> > Matteo Croce
> > per aspera ad upstream  
> 
> Anyway, looking for "tc" instead of "alltests" is probably better, as
> it only runs mktemp when at least the tc test is selected, both
> manually or via make check from topdir, eg.g
> 
> ifeq ($(MAKECMDGOALS),tc)
> 
> Do you agree?

Why use /tmp at all for this config file?
