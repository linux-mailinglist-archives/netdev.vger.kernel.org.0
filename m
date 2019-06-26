Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EEE56CE9
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfFZOz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:55:57 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41785 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfFZOz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:55:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id y72so1336690pgd.8
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 07:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=alw4PCVTq8xi2f10Hd2GyTR3GMpSFbNH4dhHqsNVJRc=;
        b=V6jK+6uTPdiyamqrnjZad3BbLdJlYcqgQa1AndMHjUbFJ8ByhBT0cP8PzCoVN5Kw+3
         j+6KyyQWUziof6pWjbAcKmy4oVFxdiact75vbq7m/taHn4IJVBp1mOCCYsuZI6TCuvLz
         2CxcEyCby3CAxmMjA7MdtGWJwFZIUHuUqoAdeqYrxjaIY5p1DDyFnWog1GQyQ2tc+YG0
         a+tcd7YPngEVN0Hp7WBFgrfb6TUg2mrvm9N7GfnkZGGbYzXW3132trHq2QA7lZv4n0m+
         dQWgk74lSTDNfWwsjJb+kZJIsxtDTjwjnGMjmp40X2RdHWKCVqOHY4znhP8rvD4toObT
         o78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=alw4PCVTq8xi2f10Hd2GyTR3GMpSFbNH4dhHqsNVJRc=;
        b=RGH8lMkeBfu/D4y2fYmOSiCKjFxs8QB0cV//VtXBubKJ2f0TBnvRwo8DiL4KAjxCYh
         2qGud8GejBwlJZzXFJAyLi64FBq/66TXTaeCSE+JE+09OW26XfP7R+uugCIVfx+eTsYC
         p2stTXeCtcjz2Wu0wewXni/MDo5rbdKXkBHdxP/6KgP+Nr9rZNvk9fHANnkYlzgNBX+g
         Wmjutnr5FAeVqu2GncxOtH7s6DwtIyNR7Ut3CFBmInOS5FwMYpHDvh17sRunmpMVCLoE
         VeR78hJ2DFZcPtagFDSY2fVsxF5OAU2fRIJEgXc7uyHX4yQk3TSbGEXoQTXFEQnVaNR2
         bioQ==
X-Gm-Message-State: APjAAAWbNt2VFX3Mz2kztbCViQIjuauNEJ0ncidKh0o5w5MXhFrxDt7j
        7McjFBeaZs8I0q/eGiqOUrVifA==
X-Google-Smtp-Source: APXvYqzlLXqlpsDQ6dHJBK1Gd8KCoISE1V1gn4rfzJ10CJnuQ3AxAfzYNcmznOP2TkVDfJPN86/98g==
X-Received: by 2002:a17:90a:20c6:: with SMTP id f64mr5276767pjg.57.1561560956465;
        Wed, 26 Jun 2019 07:55:56 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t5sm18189516pgh.46.2019.06.26.07.55.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 07:55:56 -0700 (PDT)
Date:   Wed, 26 Jun 2019 07:55:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH iproute2 1/2] devlink: fix format string warning for
 32bit targets
Message-ID: <20190626075549.58dbab66@hermes.lan>
In-Reply-To: <20190626033044.jmsejzopzj3wgl5f@sapphire.tkos.co.il>
References: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
        <20190625115806.01e29659@hermes.lan>
        <20190626033044.jmsejzopzj3wgl5f@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 06:30:44 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> Hi Stephen,
> 
> On Tue, Jun 25, 2019 at 11:58:06AM -0700, Stephen Hemminger wrote:
> > On Tue, 25 Jun 2019 14:49:04 +0300
> > Baruch Siach <baruch@tkos.co.il> wrote:
> >   
> > > diff --git a/devlink/devlink.c b/devlink/devlink.c
> > > index 436935f88bda..b400fab17578 100644
> > > --- a/devlink/devlink.c
> > > +++ b/devlink/devlink.c
> > > @@ -1726,9 +1726,9 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
> > >  		jsonw_u64_field(dl->jw, name, val);
> > >  	} else {
> > >  		if (g_indent_newline)
> > > -			pr_out("%s %lu", name, val);
> > > +			pr_out("%s %llu", name, val);
> > >  		else
> > > -			pr_out(" %s %lu", name, val);
> > > +			pr_out(" %s %llu", name, val);  
> > 
> > But on 64 bit target %llu expects unsigned long long which is 128bit.  
> 
> Is that a problem?
> 
> > The better way to fix this is to use:
> > #include <inttypes.h>
> > 
> > And the use the macro PRIu64
> > 			pr_out(" %s %"PRIu64, name, val);  
> 
> I think it makes the code harder to read. But OK, I'll post an update to this 
> patch and the next.

Or cast val to unsigned long long?

the real problem is devlink's macro's for printing.
If I had been paying attention during initial review, would have forced pr_out to be
a function.
