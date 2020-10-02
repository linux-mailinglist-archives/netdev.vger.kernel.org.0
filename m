Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8644B280E94
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgJBIPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBIPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 04:15:33 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AD5C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 01:15:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z4so763783wrr.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 01:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MlaKVfkPpT/wZ3uwfOMARPnp01dXTPkatGMCWmW3xNI=;
        b=oGPecUVA4lMGf/+dlfoZ24Y3jDJa+kPjs/Oaix/Z24PQUD3FWgZoPnCXFOLSRaEA6i
         xURyMWvz5A9kAtQPr10yXdY1c27XpVwwWRjPC2RmB7uqipWW5UYAhxbqnJu0nPmy7ipp
         GtKl/wzAAlbP/hiQHTDBuxl0N/axcYiuoksNPjs09zFTrNu06BYKQg9ivJToU5WGyeM2
         ldm0yQxxRv7EShgXW7f2hiK7sH6GpnnAYnklieRANVVETc0lluHT/xhfm+LRNYHQ6v+P
         tHCYvBuMGGkdwfjV+/SMgS54WTdWWtL/TbjVtTNCrz3TQJNkk5FvogugRqj1eBvkVzd1
         mCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MlaKVfkPpT/wZ3uwfOMARPnp01dXTPkatGMCWmW3xNI=;
        b=g18vMkfBaNejBHBBxAL/lcOdMEk8DZ+BFpEGzv+IPm/D+L7FdG8CvPelchDpHM4OkD
         hVDuL0huT5IBZEO/uhAkPUnM15IMWMzgQEKqXa/iKbor8n9tSqrJhgAQZ0aYLzOIN2OS
         CleleiRtGwNNtSnPI/x/yhWVW3l1m46sSE52s0Jo+7Gb7AEPmb+nXrnjln2anHZA7xom
         B049eic7FqXhDVfflAvI1wm5d7iQfOrFab/UzUVcAQIvoga8yrlrbpV0aNNh2OfNwgCM
         HgCu7Th2NpE8dcEOT8Rv1pZs2UKGx/aEeW0oj5wsQc6VP2PsklclC5N66zsEG3Ehdnwc
         6i0w==
X-Gm-Message-State: AOAM5306MolXtVcWE0xWlHoR25n1BQWC7+i6O4wcDqLfMUs72EV3KQwU
        s3iaPD7LxMLgyEBkXoJazWI=
X-Google-Smtp-Source: ABdhPJzf6KPuE0DqROYX3vwH+6PX/yTLjcgWZ2Z0HtlG/2gfdlS4M1AeQLNKdwt3tFjXJc89EB+2Cw==
X-Received: by 2002:a5d:4709:: with SMTP id y9mr1603884wrq.59.1601626530673;
        Fri, 02 Oct 2020 01:15:30 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id n4sm838823wrp.61.2020.10.02.01.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 01:15:30 -0700 (PDT)
Date:   Fri, 2 Oct 2020 11:15:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20201002081527.d635bjrvr6hhdrns@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <87y2lkshhn.fsf@kurt>
 <20200908102956.ked67svjhhkxu4ku@skbuf>
 <87o8llrr0b.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8llrr0b.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 10:06:28AM +0200, Kurt Kanzenbach wrote:
> Hi Vladimir,
> 
> On Tue Sep 08 2020, Vladimir Oltean wrote:
> > On Tue, Sep 08, 2020 at 12:14:12PM +0200, Kurt Kanzenbach wrote:
> >> On Mon Sep 07 2020, Vladimir Oltean wrote:
> >> > New drivers always seem to omit setting this flag, for some reason.
> >>
> >> Yes, because it's not well documented, or is it? Before writing the
> >> hellcreek DSA driver, I've read dsa.rst documentation to find out what
> >> callback function should to what. Did I miss something?
> >
> > Honestly, Documentation/networking/dsa/dsa.rst is out of date by quite a
> > bit. And this trend of having boolean flags in struct dsa_switch started
> > after the documentation stopped being updated.
> 
> Maybe it would be good to document new flags when they're introduced :).

Yup, will definitely do that when I resend.

> >
> > But I didn't say it's your fault for not setting the flag, it is easy to
> > miss, and that's what this patch is trying to improve.
> >
> >> > So let's reverse the logic: the DSA core sets it by default to true
> >> > before the .setup() callback, and legacy drivers can turn it off. This
> >> > way, new drivers get the new behavior by default, unless they
> >> > explicitly set the flag to false, which is more obvious during review.
> >>
> >> Yeah, that behavior makes more sense to me. Thank you.
> >
> > Ok, thanks.
> 
> Is this merged? I don't see it. Do I have to set
> `configure_vlan_while_not_filtering' explicitly to true for the next
> hellcreek version?

Yes, please set it to true. The refactoring change didn't get merged in
time, I don't want it to interfere with your series.

Thanks,
-Vladimir
