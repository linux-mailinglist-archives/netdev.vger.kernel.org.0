Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83105227207
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 00:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgGTWNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 18:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTWNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 18:13:18 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B84C061794;
        Mon, 20 Jul 2020 15:13:18 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id br7so19648667ejb.5;
        Mon, 20 Jul 2020 15:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fu9IOWLKm5uKHaDq/DHTJ69miqRghmW76IOYppK4sBE=;
        b=OQlnzm/vP0G9spnypwAbY579vINpaa3IarJEkSMKeGKTMIA7i4fDJTVwnb/thgKI0k
         hoWorCgXOn7IduuYq4hQvBWYqsS+LAQAkJmJUQ3M/hCrJu8GmE66Pew8UyQiFPdp1NM5
         gYvQTX0CaK1TWytfXmWfzVTfAOwCAsT4jDLwTmiZtb6YVDYen/nqGJWp7tLOj1mJJMbE
         ErTsuUyqNrF2NFnQ8u4kRsqHoXiZbr4m/bgfMC3nmotv1jOPHx7osYz4DJDXuLZ7K4J1
         AwaOH3/lzRdhJB3MaPxAbIPZtPVx9xTKec1kYH9uFRI65PafYktyJuysXsQBIt4T6jId
         mK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fu9IOWLKm5uKHaDq/DHTJ69miqRghmW76IOYppK4sBE=;
        b=NC/dVQ+N5LDlMWyv2zVBqkrmWOcR4kSMmdXt/mbUqQr/O8j5740c3lmvgN9w294xco
         hB455o+graVYIsaylM1kVVVYUMwAORCWbMPT/474mJwuROtU1jzRbMcK+McsSa1tYdr7
         6Nmpsf2M2u1PGmEE+wQ+UKA5R5tMs806iMMpbHbk8Zxg78p8QFwW6kUjRJ/Wku6WHkPo
         xGrIS2VJZBkLl4LB47MzVltyRR9VMMrXM0BUDP258PQACjozEBkwMQVBtjoTpazaFN0W
         78Mvz66C2owLT/EBWVbOPifvhR7VvnBgyhcbVcbeTnAGwwLRDpnULpqZ4ono1ArEP0Mx
         KWNg==
X-Gm-Message-State: AOAM533z/6uYiqR8dWjVDWTQaHFg6CMnPf9SSEnBiDOCSCFQ5o4W/5EQ
        BvUCeY0IRlPPyJXD8CKt03PMbRKO
X-Google-Smtp-Source: ABdhPJzyaEFQM4u4/Ao3NWQ1GYmeHet8E10aQgDCpaT743qAQqab4JOqBJr2u91vbqnHsFV7sDPWWA==
X-Received: by 2002:a17:906:364e:: with SMTP id r14mr21925820ejb.258.1595283196685;
        Mon, 20 Jul 2020 15:13:16 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id q21sm15387820ejc.112.2020.07.20.15.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 15:13:16 -0700 (PDT)
Date:   Tue, 21 Jul 2020 01:13:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200720221314.xkdbw25nsjsyvgbv@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
 <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 02:45:03PM -0700, Jacob Keller wrote:
> 
> 
> On 7/20/2020 2:05 PM, Vladimir Oltean wrote:
> > On Mon, Jul 20, 2020 at 11:54:30AM -0700, Jacob Keller wrote:
> >> On 7/18/2020 4:35 AM, Vladimir Oltean wrote:
> >>> On Fri, Jul 17, 2020 at 04:12:07PM -0700, Jacob Keller wrote:
> >>>> On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> >>>>> +When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
> >>>>> +and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
> >>>>> +Originally, the network stack could deliver either a hardware or a software
> >>>>> +time stamp, but not both. This flag prevents software timestamp delivery.
> >>>>> +This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
> >>>>> +option, but still the original behavior is preserved as the default.
> >>>>> +
> >>>>
> >>>> So, this implies that we set this only if both are supported? I thought
> >>>> the intention was to set this flag whenever we start a HW timestamp.
> >>>>
> >>>
> >>> It's only _required_ when SOF_TIMESTAMPING_TX_SOFTWARE is used, it
> >>> seems. I had also thought of setting 'SKBTX_IN_PROGRESS' as good
> >>> practice, but there are many situations where it can do more harm than
> >>> good.
> >>>
> >>
> >> I guess I've only ever implemented a driver with software timestamping
> >> enabled as an option. What sort of issues arise when you have this set?
> >> I'm guessing that it's some configuration of stacked devices as in the
> >> other cases? If the issue can't be fixed I'd at least like more
> >> explanation here, since the prevailing convention is that we set this
> >> flag, so understanding when and why it's problematic would be useful.
> >>
> >> Thanks,
> >> Jake
> > 
> > Yes, the problematic cases have to do with stacked PHCs (DSA, PHY). The
> > pattern is that:
> > - DSA sets SKBTX_IN_PROGRESS
> > - calls dev_queue_xmit towards the MAC driver
> > - MAC driver sees SKBTX_IN_PROGRESS, thinks it's the one who set it
> > - MAC driver delivers TX timestamp
> > - DSA ends poll or receives TX interrupt, collects its timestamp, and
> >   delivers a second TX timestamp
> > In fact this is explained in a bit more detail in the current
> > timestamping.rst file.
> > Not only are there existing in-tree drivers that do that (and various
> > subtle variations of it), but new code also has this tendency to take
> > shortcuts and interpret any SKBTX_IN_PROGRESS flag set as being set
> > locally. Good thing it's caught during review most of the time these
> > days. It's an error-prone design.
> > On the DSA front, 1 driver sets this flag (sja1105) and 3 don't (felix,
> > mv88e6xxx, hellcreek). The driver who had trouble because of this flag?
> > sja1105.
> > On the PHY front, 2 drivers set this flag (mscc_phy, dp83640) and 1
> > doesn't (ptp_ines). The driver who had trouble? dp83640.
> > So it's very far from obvious that setting this flag is 'the prevailing
> > convention'. For a MAC driver, that might well be, but for DSA/PHY,
> > there seem to be risks associated with doing that, and driver writers
> > should know what they're signing up for.
> > 
> 
> Perhaps the issue is that the MAC driver using SKBTX_IN_PROGRESS as the
> mechanism for telling if it should deliver a timestamp. Shouldn't they
> be relying on SKBTX_HW_TSTAMP for the "please timestamp" notification,
> and then using their own mechanism for forwarding that timestamp once
> it's complete?
> 
> I see a handful of drivers do rely on checking this, but I think that's
> the real bug here.
> 
> > -Vladimir
> > 

Yes, indeed, a lot of them are exclusively checking
"skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS", without any further
verification that they have hardware timestamping enabled in the first
place, a lot more than I remembered. Some of the occurrences are
actually new.

I think at least part of the reason why this keeps going on is that
there aren't any hard and fast rules that say you shouldn't do it. When
there isn't even a convincing percentage of DSA/PHY drivers that do set
SKBTX_HW_TSTAMP, the chances are pretty low that you'll get a stacked
PHC driver that sets the flag, plus a MAC driver that checks for it
incorrectly. So people tend to ignore this case. Even though, if stacked
DSA drivers started supporting software TX timestamping (which is not
unlikely, given the fact that this would also give you compatibility
with PHY timestamping), I'm sure things would change, because more
people would become aware of the issue once mv88e6xxx starts getting
affected.

What I've been trying to do is at least try to get people (especially
people who have a lot of XP with 1588 drivers) to agree on a common set
of guidelines that are explicitly written down. I think that's step #1.

-Vladimir
