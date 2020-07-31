Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A0D233D7B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 04:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgGaCuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 22:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbgGaCuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 22:50:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779E5C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 19:50:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w17so16030962ply.11
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 19:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ny+m1UgdF8UGSvbxW/TgPfxAfKe28vmGxndogRsQZPQ=;
        b=DklqSlp4yil/x+sWCPJVTAHhkgXK/1P2p64SjA7PA1fmCL39o9VotARMzqTI0fYS2M
         IuWOdNDJMas6ONH92G5VBufC0PLZQ9xxwEY+bQHmjyRDxKQWrNz2mp4WsNeIFKiK2I7C
         NbvYXH4nIQaLuvCDiR5khXJjyPZs0hGhbhKT+A4u5VNg8c8j5ehybYiqJP/kbjskA56X
         CTEBEwW36OHqYZfClOqdPyK83p+rXipgZf4J4x7LX1o0Te+8kkHdgOMQ3Ebyv8aZV4fx
         7MwedqMJS1FBehlVgI1RW/UPvWAftWENWBMh2yhGGUBHVFkjbC138sZrwkoQIa5Cz+Sh
         8rOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ny+m1UgdF8UGSvbxW/TgPfxAfKe28vmGxndogRsQZPQ=;
        b=TLcuN4svjwgkeIJANLx+KvmAJhqtdXmFOCHuI78RcRlpYWriD63pLu4yIQHe/mDagd
         MOGq2Uk+NSrghk/iCpVTje8i3fMMGNIIOY/awz3BApVNB8tTuAwhac3UJiqBs7csirnv
         4nQ0snk96LtPUZc+lh+hWvfXIMpxuexqNHn/A53brPC9p2tGHIgMTH3JXNBKl0j20faA
         K0FockMZjue+k9ghrY0wkVBFKFU7gYmm0M0tcK+AcrdHFyRFtRZK3YTvPRV33VDXGmNk
         uHpJSjoccMd9PDfjQM81MVC1ucQ5Ms/6tK4ihTHYcehhjJWqzuKC45mmuLW8UQKWknj+
         dHbg==
X-Gm-Message-State: AOAM533FAP2JUA9igFEJKI1BBzntOzvemv/NiblyZ0M86Bhykl9JEfLF
        ieyAaupmXSxI3FdNN+giLBKCuZdC
X-Google-Smtp-Source: ABdhPJxaOqQo3s0kX5W5BPt12fyQfzXYnxMq3/v8zHDq2wwZFxp7QWUVqk6hVlAg+bYiVsXMJ6ZI/g==
X-Received: by 2002:a17:90a:348d:: with SMTP id p13mr1992084pjb.108.1596163838851;
        Thu, 30 Jul 2020 19:50:38 -0700 (PDT)
Received: from martin-VirtualBox ([42.109.131.30])
        by smtp.gmail.com with ESMTPSA id l22sm6878787pjy.31.2020.07.30.19.50.37
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jul 2020 19:50:38 -0700 (PDT)
Date:   Fri, 31 Jul 2020 08:20:34 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jbenc@redhat.com,
        gnault@redhat.com, Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net] bareudp: Disallow udp port 0.
Message-ID: <20200731025034.GA2653@martin-VirtualBox>
References: <1596128631-3404-1-git-send-email-martinvarghesenokia@gmail.com>
 <20200730162030.0b5749a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730162030.0b5749a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 04:20:30PM -0700, Jakub Kicinski wrote:
> On Thu, 30 Jul 2020 22:33:51 +0530 Martin Varghese wrote:
> > From: Martin Varghese <martin.varghese@nokia.com>
> > 
> > Kernel does not support udp destination port 0 on wire. Hence
> > bareudp device with udp destination port 0 must be disallowed.
> > 
> > Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > ---
> >  drivers/net/bareudp.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > index 88e7900853db..08b195d32cbe 100644
> > --- a/drivers/net/bareudp.c
> > +++ b/drivers/net/bareudp.c
> > @@ -578,8 +578,13 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (data[IFLA_BAREUDP_PORT])
> > +	if (data[IFLA_BAREUDP_PORT]) {
> >  		conf->port =  nla_get_u16(data[IFLA_BAREUDP_PORT]);
> > +		if (!conf->port) {
> > +			NL_SET_ERR_MSG(extack, "udp port 0 not supported");
> > +			return -EINVAL;
> > +		}
> > +	}
> 
> Please use one of the NLA_POLICY_**-ies, probably NLA_POLICY_MIN() ? 
> That's better for documenting, exporting for user space, and will also
> point the user space to the attribute in exack automatically.

Ok, I will check how to do this way. Thanks for the feedback.

Regards,
Martin
