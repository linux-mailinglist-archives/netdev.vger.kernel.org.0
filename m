Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB74C3047C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfE3WBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:01:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34552 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfE3WBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:01:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id h1so9015989qtp.1
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 15:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xUrEWzZQfNW3Ko2ZWNLxImFggBKxzmBgkihSD1gWgW0=;
        b=Is1zd4SDvd6ZWvtvAYJ67dlcwr8V/61dT3N1tlUOkcZwnsfMcEtreN/4wMWHgkijuJ
         fehIbSV7QgKzRoi8VwUd0W3WoXvOqExCo54m3DUWvZUS4I4JGGA9nNtGyMoFCaqPHUhd
         VxlWr6suY3YYkFaNBvaCCLAgcx4fsNiUjFNkmboSgvURicz+xVee3x2fjbJ/RZaI0fXc
         di/c6A8CiJ9tE3erznkf1k+x25DEYKFnKRAqv7OCt9cZkE4Yo9/znC9IX8mfIklKs7yd
         Gkn4IjHNQ5rZvpyrDAC5jDFha3I65uww7VBZkCmusfLq9q94+NHvcaB9Kal9s6v3VSuv
         Rtdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xUrEWzZQfNW3Ko2ZWNLxImFggBKxzmBgkihSD1gWgW0=;
        b=RMktZIhWeDlMIO184RVqR8KQy0rxc2k9udwsIzF5WYMgsIbEGZu3A+Ys1h/9armc30
         UHGRGDPR8BWVXdK4fnAu3jqIhIsbUUOVpPFBs0caDnSFFQpplK981bAFB9b0x7zclie/
         0HrTG9onRxF7L7fvQUnIcq2GWfuSOtm/eSGyHIB1uy+zI3w/doUrkVWNbCV3PKeNDtNC
         bvur+OkOWSuQRqgAhGU8VpwRyCphXgO0Zu/XIHO+AHg2ySUwKbacIACEkVSu2q15hpe8
         j10fUAojZXdoXh/v4BPPC/hAyOZoReOiZM4WzPDOhm1g0muc6jdlPFS5MzqiAMXv8lhM
         H7kQ==
X-Gm-Message-State: APjAAAXLMSZ398vpRlZ9SftcG5/sd7SlmOcY5Xaa+LDxvaWrJJkr2Dmm
        NezzO6biVSPBV1Jj8mxn21q27w==
X-Google-Smtp-Source: APXvYqw3Gbiesdzd/yRAh8ImxVsYAztosD/Dz/fx+HhBvOt45z0S/5LhH2Nn++H9E2AwV5xsyZZVcQ==
X-Received: by 2002:aed:39e5:: with SMTP id m92mr5818400qte.106.1559251744607;
        Thu, 30 May 2019 14:29:04 -0700 (PDT)
Received: from cisco ([2601:280:6:ca14:840:fa90:7243:7032])
        by smtp.gmail.com with ESMTPSA id d5sm1904111qtj.3.2019.05.30.14.29.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 14:29:03 -0700 (PDT)
Date:   Thu, 30 May 2019 15:29:00 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Message-ID: <20190530212900.GC5739@cisco>
References: <cover.1554732921.git.rgb@redhat.com>
 <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco>
 <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco>
 <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco>
 <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com>
 <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 03:29:32PM -0400, Paul Moore wrote:
> 
> [REMINDER: It is an "*audit* container ID" and not a general
> "container ID" ;)  Smiley aside, I'm not kidding about that part.]

This sort of seems like a distinction without a difference; presumably
audit is going to want to differentiate between everything that people
in userspace call a container. So you'll have to support all this
insanity anyway, even if it's "not a container ID".

> I'm not interested in supporting/merging something that isn't useful;
> if this doesn't work for your use case then we need to figure out what
> would work.  It sounds like nested containers are much more common in
> the lxc world, can you elaborate a bit more on this?
> 
> As far as the possible solutions you mention above, I'm not sure I
> like the per-userns audit container IDs, I'd much rather just emit the
> necessary tracking information via the audit record stream and let the
> log analysis tools figure it out.  However, the bigger question is how
> to limit (re)setting the audit container ID when you are in a non-init
> userns.  For reasons already mentioned, using capable() is a non
> starter for everything but the initial userns, and using ns_capable()
> is equally poor as it essentially allows any userns the ability to
> munge it's audit container ID (obviously not good).  It appears we
> need a different method for controlling access to the audit container
> ID.

One option would be to make it a string, and have it be append only.
That should be safe with no checks.

I know there was a long thread about what type to make this thing. I
think you could accomplish the append-only-ness with a u64 if you had
some rule about only allowing setting lower order bits than those that
are already set. With 4 bits for simplicity:

1100         # initial container id
1100 -> 1011 # not allowed
1100 -> 1101 # allowed, but now 1101 is set in stone since there are
             # no lower order bits left

There are probably fancier ways to do it if you actually understand
math :)

Since userns nesting is limited to 32 levels (right now, IIRC), and
you have 64 bits, this might be reasonable. You could just teach
container engines to use the first say N bits for themselves, with a 1
bit for the barrier at the end.

Tycho
