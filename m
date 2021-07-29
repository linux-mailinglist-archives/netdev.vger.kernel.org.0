Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1013DA3EE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbhG2NXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbhG2NWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:22:48 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD42C06179B
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:22:43 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id x15-20020a05683000cfb02904d1f8b9db81so5803782oto.12
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ewN+TYAN6cAXbxfmtdyHRqP+4HtLzRtQqVkqElvLrvU=;
        b=Rk7hZVV/fhQHbKHSsujri+A3krn39eIhpYDXjXNC4RCuD/GzdC+cHlxQ05wHzebz5k
         79i4ZU3R0vE55veTnYKydbnJc6niX8Nt0hbKzV6fhlD8T7SVzNhW8biQppJEumEeHzYH
         1Gka6tggK+XFtwyLGKQhsBJqEnQ0uDOLgoCAfLx8D7c8m6HjXMh1XZSB/bN2uQsnFvx3
         KQBh+AEgOUFxG7nrOZhC1/NFkSFLPV32EtFZMFKO4RmlB3by6/Y8hg59q1UDuia7kVdn
         +xW0S148Nj5k3l+FRsbynVf2fo0TvsW0jlGSeeSYXWAOKN9Cl005wXzR0i+OKxaz6HQz
         zk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ewN+TYAN6cAXbxfmtdyHRqP+4HtLzRtQqVkqElvLrvU=;
        b=A31QZjW21/W6d1mAblTwxvBzXjthxWCeCBmLIRf/thXNqYiqMD/o8QVgpJnmO0ijp8
         hyF3LgpG9xPoZmKgcQC/9gGRhPshHbXABhTeQDqhWPR8wdjFi7NP9JUk4ahoz0saYoi2
         dvaIqYlS6uwtvDa+/DMlDoHR8/7qAvHEYt8lZUj3hocP9fsY6I67pFhmhjGg6R05vnaS
         mrdtfpRPyAGlvC8aTMfg0iQBMLSVl7vY46AjbpsItBL5ANT6FbrtyJI2h//ntUbVaohp
         tlyrQoJQtcIKtpZ9cvLIGyuNGPzIhQKrjnJqFAGFo6dvTtQhUVI/lMITbjWlUJgPaEjp
         cK+g==
X-Gm-Message-State: AOAM533PnzjW4dOV+q53b/MwgcWW2DbbJUVMBpRJnwbqz8PNkbMArWe9
        Ub3OnAaWj6a4Z3fkWG7Jmw7R4YWL5ugvM6Wvxw==
X-Google-Smtp-Source: ABdhPJxqIhZR0rVEnBhwXhTRNocV2s6nn0tH8tl+DkyTMDkvgPzScoWyfLYkUAg+mw1WH88n0O+OxoDdf3ol8d0yOKc=
X-Received: by 2002:a9d:1ea5:: with SMTP id n34mr3390886otn.340.1627564963264;
 Thu, 29 Jul 2021 06:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
 <YQHGe6Rv9T4+E3AG@lunn.ch> <20210728222457.GA10360@hoboy.vegasvil.org>
In-Reply-To: <20210728222457.GA10360@hoboy.vegasvil.org>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 29 Jul 2021 08:22:32 -0500
Message-ID: <CAFSKS=OtAgLCo0MLe8CORUgkapZLRbe6hRiKU7QWSd5a70wgrw@mail.gmail.com>
Subject: Re: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time stamping
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 5:25 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Wed, Jul 28, 2021 at 11:04:59PM +0200, Andrew Lunn wrote:
> > On Wed, Jul 28, 2021 at 03:44:24PM -0500, George McCollister wrote:
> > > If I do the following on one of my mv88e6390 switch ports I stop
> > > receiving multicast frames.
> > > hwstamp_ctl -i lan0 -t 1 -r 12
> > >
> > > Has anyone seen anything like this or have any ideas what might be
> > > going on? Does anyone have PTP working on the mv88e6390?
> > >
> > > I tried this but it doesn't help:
> > > ip maddr add 01:xx:xx:xx:xx:xx dev lan0
> > >
> > > I've tried sending 01:1B:19:00:00:00, 01:80:C2:00:00:0E as well as
> > > other random ll multicast addresses. Nothing gets through once
> > > hardware timestamping is switched on. The switch counters indicate
> > > they're making it into the outward facing switch port but are not
> > > being sent out the CPU facing switch port. I ran into this while
> > > trying to get ptp4l to work.
> >
> > Hi George
> >
> > All my testing was i think on 6352.
>
> Mine, too.  IIRC, the PTP stuff for most (all?) of the other parts was
> added "blindly" into the driver, based on similarity in the data
> sheets.
>
> So maybe 6390 has never been tried?

Thanks for the feedback. The datasheet covers the 88E6390X, 88E6390,
88E6290, 88E6190X, 88E6190 so I expect those work similarly but if
only the 6352 has been tested that could explain it. It certainly
helps to know that I'm working with something that may have never
worked rather than I'm just doing something dumb.

>
> Thanks,
> Richard
