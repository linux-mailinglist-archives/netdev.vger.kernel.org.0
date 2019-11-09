Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC2F614A
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfKIUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:02:29 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39663 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKIUC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:02:29 -0500
Received: by mail-pg1-f193.google.com with SMTP id 29so6364075pgm.6
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vo3e6BMhIMu2KcpBbkORqellwsS7h8ia/w7Z+FdYeu4=;
        b=eD0M7T1HRNlyakpnb0NzKMtPvcOkOgEjESmrT/h7v+q7POllGzwrRp01VsU0KStrbC
         JpDWIYWmZfbXrXhGp7Eb7dNutMWTJezhvKo25obBenpkxgJHVci45XJ5u9LLLtlNufKD
         u7SZw5B9N5DUruE1ciAwWrztmXQyu5KF6SOSvA0JbK22ridGTBoHWltFL29QGmubEIfw
         ttndi//Eki8whGN/dZBY62zsErxM9ZcPLLYwbpnKZpdp/BhIDGfLHwZ9+CVZd8kphty2
         9jRzDv00OCE9zwDxRmZNNv750eCKK9qSN8rw2SQUa5Jnw/UIhjmp3/GmqmWv+tXp+nRa
         m4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vo3e6BMhIMu2KcpBbkORqellwsS7h8ia/w7Z+FdYeu4=;
        b=LOTc9LNkSZpoKXOxrWuPKpsoKhvp3OR/XeV1Q/EumOiNk597/WU3gjltacoT8q7wUk
         UQwlEJcx3yA3CnaHZWnfFNF9NW1ddnFchwk5jSMkpQITF8UI4cxaMRV5KAHNwF+YUqQG
         KdataibsXTCO2LwkZO6xGTHUkjWrTkrg7qhvCXJehY86E+0TXICCuxnPBBfhrGm9zcP1
         rNRmBoucrbDzGjbUuHGX1BjsrqPQl81S+6yifbuKNpPbqgBQRsdouJts40YfcTuHAprK
         QkpL7I05V+N2qVBrbg5ceXXUNCiQ3Fqhejqj6tT4RonMvcJbBC6MrBfh7zdIvPezGw0T
         UD7g==
X-Gm-Message-State: APjAAAWwV8jCxT7X3egkcgwgLl68AJdIqbYx57mwgHVWNlVAvBzN+7dY
        gk86XRfI/EbVRoe4qQeuWIMfuw==
X-Google-Smtp-Source: APXvYqzXQUTFhajMnF8uLbhR4fLgW43c3HFZ3dynwHyWYFmdUOaetkJ41kM8Y/vhdUXN1K1TH0rn8Q==
X-Received: by 2002:a17:90a:170a:: with SMTP id z10mr23938685pjd.86.1573329746804;
        Sat, 09 Nov 2019 12:02:26 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b7sm3415200pjo.3.2019.11.09.12.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 12:02:26 -0800 (PST)
Date:   Sat, 9 Nov 2019 12:02:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] man: remove ppp from list of devices not
 allowed to change netns
Message-ID: <20191109120218.1e113d54@hermes.lan>
In-Reply-To: <20191109170123.GA2424@linux.home>
References: <beefb89b340483d75c39c46a9ec69384e839f663.1573248448.git.gnault@redhat.com>
        <20191108153159.25e09c8a@hermes.lan>
        <20191109170123.GA2424@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 18:01:23 +0100
Guillaume Nault <gnault@redhat.com> wrote:

> On Fri, Nov 08, 2019 at 03:31:59PM -0800, Stephen Hemminger wrote:
> > On Fri, 8 Nov 2019 22:28:04 +0100
> > Guillaume Nault <gnault@redhat.com> wrote:  
> > > diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> > > index 9629a649..939e2ad4 100644
> > > --- a/man/man8/ip-link.8.in
> > > +++ b/man/man8/ip-link.8.in
> > > @@ -1921,7 +1921,7 @@ move the device to the network namespace associated with name
> > >  .RI process " PID".
> > >  
> > >  Some devices are not allowed to change network namespace: loopback, bridge,
> > > -ppp, wireless. These are network namespace local devices. In such case
> > > +wireless. These are network namespace local devices. In such case
> > >  .B ip
> > >  tool will return "Invalid argument" error. It is possible to find out
> > >  if device is local to a single network namespace by checking  
> > 
> > This doesn't have to wait for net-next  
> Right, I should have posted it for -iproute2, sorry. The patch applies
> cleanly there though. Do you want to take it as is, or do you prefer
> that I submit it again?
> 

I will merge it as is
