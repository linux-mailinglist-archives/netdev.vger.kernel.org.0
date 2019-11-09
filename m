Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B4AF605D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfKIRBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 12:01:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726125AbfKIRBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 12:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573318891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJIdeZoKypnAyfEdpiOAP/9tNaJfvhk1PkNwbrPGFII=;
        b=VuUDyAVT9z9/k5c+CDjzLqO8+92U0qbjSZ0VhPvsR2BE8+o6zMA75f81Z34wyziXhq6eew
        idAyh0+0DowTJTi4n5RzANw7bljO3ND/9x0d6fOtHOpzo4djcHtGhCgmB3x6Ss21/0qkwJ
        oo3pUxCmZdbGWUqUPnStLDteDcnb9m0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-Ew5M6zQQPXyAJeR1V-7_XA-1; Sat, 09 Nov 2019 12:01:28 -0500
Received: by mail-wr1-f72.google.com with SMTP id 4so6242403wrf.19
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 09:01:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BL/N4E/7KB3XR4SzlqwVL4cnDFVCt3CDs2W/g3320ZI=;
        b=nDcpczI8NadVy708VW0c47+6V3fAwwd+iEdB/4WaWMv5xo/x77TJ57Pllq6SmdG3k+
         co5KGRnu9ktv2M6sTUICNyZgQmhm8Hht2hSdb1KydjnOUQ+CxKue+dfP9ZAoCQYDN7A3
         RAmcUUk7by7IsgeKOYYgDKm81IwIBDtS3n/iHw8YeF2YfOJXyu4zaQbrmzi8R8I85RTk
         0I5v4BsYgDvoI7uVEbYovFs3QppvEA/XKAg8h5EuW1q55i+sL8tcOzlMiPpOX8Et/ZZu
         hV/huvf3pFbovyOTm1FATpihCjn84OKPTaS9zqumv0KrZTwv0VQd14yISeJu5d3I24Ed
         Es/A==
X-Gm-Message-State: APjAAAXU6q2HH2aeazIKBiTQnfI6whZOrOsqzBzMM4XnXWb4JV1RwIRC
        guo78ctxP7HXrzClWC1XeQTjNOzfb8hIgKpXwxBMVTNo8GlHXYiDIYZ314mdrUPWixnadPwUgNT
        Upy6GfQhRSVV0QR/+
X-Received: by 2002:adf:94a6:: with SMTP id 35mr829077wrr.108.1573318886508;
        Sat, 09 Nov 2019 09:01:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxuilu5F/HICpUoWGqDEktwIQAJtRgD05ouW0+pk54eYsK61TOg3E54UBvw4s8uaKfdvXy2cg==
X-Received: by 2002:adf:94a6:: with SMTP id 35mr829069wrr.108.1573318886296;
        Sat, 09 Nov 2019 09:01:26 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id x9sm9257897wru.32.2019.11.09.09.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 09:01:25 -0800 (PST)
Date:   Sat, 9 Nov 2019 18:01:23 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] man: remove ppp from list of devices not
 allowed to change netns
Message-ID: <20191109170123.GA2424@linux.home>
References: <beefb89b340483d75c39c46a9ec69384e839f663.1573248448.git.gnault@redhat.com>
 <20191108153159.25e09c8a@hermes.lan>
MIME-Version: 1.0
In-Reply-To: <20191108153159.25e09c8a@hermes.lan>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: Ew5M6zQQPXyAJeR1V-7_XA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 03:31:59PM -0800, Stephen Hemminger wrote:
> On Fri, 8 Nov 2019 22:28:04 +0100
> Guillaume Nault <gnault@redhat.com> wrote:
> > diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> > index 9629a649..939e2ad4 100644
> > --- a/man/man8/ip-link.8.in
> > +++ b/man/man8/ip-link.8.in
> > @@ -1921,7 +1921,7 @@ move the device to the network namespace associat=
ed with name
> >  .RI process " PID".
> > =20
> >  Some devices are not allowed to change network namespace: loopback, br=
idge,
> > -ppp, wireless. These are network namespace local devices. In such case
> > +wireless. These are network namespace local devices. In such case
> >  .B ip
> >  tool will return "Invalid argument" error. It is possible to find out
> >  if device is local to a single network namespace by checking
>=20
> This doesn't have to wait for net-next
Right, I should have posted it for -iproute2, sorry. The patch applies
cleanly there though. Do you want to take it as is, or do you prefer
that I submit it again?

