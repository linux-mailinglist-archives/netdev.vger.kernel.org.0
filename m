Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D0F14FAAF
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 22:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgBAVaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 16:30:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34801 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgBAVaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 16:30:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so12947375wrr.1;
        Sat, 01 Feb 2020 13:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-id;
        bh=Xonz9D/AFswduxxZBjuL+y0rFr7TKLhQeolot8GdlOk=;
        b=XN/KTCJlSFMpcjPP+HaZsNZwPOvNkipRRNOCENBOQLhL0cHgJOPBztv8+p6qqi4/Tq
         imNdoJz+rQk3JeQcnFGdzLx7mZn6cvB4QMJdw0/anaEVOWSBbg6ARM4ANtvASdK/Wn3g
         DOx7OaGtOPkQlJD7HAXYasUUqMYto6Cd75o68SMlD+XNZI3z+CnJzPZn7n8+jCILAvdC
         EV9mAXrtXS05FNfK3SRvDRgBWgsOPbAfELUEjjxC9P/6YAwPo5f+gb5VYNd2RlNw4kap
         txIgSUveDHMJsYapvou7IX/CPNrdPxcdKjHm2rB0FblzorK4SbDLtGC8okvbJjwk01aw
         tdTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-id;
        bh=Xonz9D/AFswduxxZBjuL+y0rFr7TKLhQeolot8GdlOk=;
        b=JMNwDkf60sTps4KpPkHWC64v8M4tOIlADoFlkjXqWiIRuJ+cA1TuNm1m5O02SvlXMz
         o0GpzDLPw//YGCYQ9S+tnqM1rtda7t/Muh/SDoxk37c4MeWyvhDp8s2zSSRtYEmZd5Tz
         7B4uE7afsSTb3rNHIVsT5QKu/wQHPl7dJiQbwh2V3QR95pu/p8FrsQtQ5+62Sx+JMdIN
         0qKGGKRwUFGPDzciNr69J5lNK9XoP+twQWJLz+a5izxZLSDwxne4T0L3EeEGl5F8LgVH
         NtfVPxmKGI7gjF5iYKPMrfCO91fl1N0O7zsC4vjvURRYldXm1ed/WW/YI3K/iqrqFfkc
         Mczg==
X-Gm-Message-State: APjAAAW7Wvbii8Yci0wZmXV46uZwKI98aehX4xBx7rX4+fktwBmesafc
        wIL+X0nBS9cn5CPTotaXPtyQXSll6ak=
X-Google-Smtp-Source: APXvYqyVx9vSml2V9JJ+u2YYVvunUl4OvzOz9RjFHrYfEiy230oRb/WhaVXYZJl53HQrEYihbsEBtQ==
X-Received: by 2002:adf:fd8d:: with SMTP id d13mr5998151wrr.208.1580592600318;
        Sat, 01 Feb 2020 13:30:00 -0800 (PST)
Received: from felia ([2001:16b8:2d5f:200:35fb:e0f1:a37a:5e0a])
        by smtp.gmail.com with ESMTPSA id y12sm16315929wmj.6.2020.02.01.13.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 13:29:59 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Sat, 1 Feb 2020 22:29:51 +0100 (CET)
X-X-Sender: lukas@felia
To:     Joe Perches <joe@perches.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
In-Reply-To: <68504e9043cbe71437460241a1814529ff2a8be4.camel@perches.com>
Message-ID: <alpine.DEB.2.21.2002012213240.3841@felia>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com> <08d88848280f93c171e4003027644a35740a8e8e.camel@perches.com> <CAKXUXMyToKuJf_kGXWjP1pu33XbiMD4kpBcqUhJu==-OBQ8TQQ@mail.gmail.com> <68504e9043cbe71437460241a1814529ff2a8be4.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.21.2002012226561.3841@felia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sat, 1 Feb 2020, Joe Perches wrote:

> On Sat, 2020-02-01 at 20:15 +0100, Lukas Bulwahn wrote:
> > On Sat, Feb 1, 2020 at 7:43 PM Joe Perches <joe@perches.com> wrote:
> > > Perhaps this is a defect in the small script as
> > > get_maintainer does already show the directory and
> > > files as being maintained.
> > > 
> > > ie: get_maintainer.pl does this:
> > > 
> > >                 ##if pattern is a directory and it lacks a trailing slash, add one
> > >                 if ((-d $value)) {
> > >                     $value =~ s@([^/])$@$1/@;
> > >                 }
> > > 
> > 
> > True. My script did not implement that logic; I will add that to my
> > script as well.
> > Fortunately, that is not the major case of issues I have found and
> > they might need some improvements.
> 
> You might also try ./scripts/get_maintainer.pl --self-test

Thanks for letting me know about that functionality.

It looks like quite some work to get those warnings sorted out properly. I 
will check to address the most important/disturbing ones that I see.

> 
> And here's an attached script to update any missing
> MAINTAINER [FX]: directory slashes and what it produces
> against today's -next.

I probably make use of that script, at least for some intermediate
processing.

Lukas
