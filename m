Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6222897C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgGUTvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbgGUTvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:51:32 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F68C061794;
        Tue, 21 Jul 2020 12:51:31 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a1so16128108edt.10;
        Tue, 21 Jul 2020 12:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zxi3cqFor3XTSLQepm5PAsBUgoogif6QsUbB8s9ngl4=;
        b=TXZewORFO48nhiJDYPTv/Jj+3dYsJ8hDcoecDwGBI6fWRLbKtHtjXZeXjk2td9lGMg
         GjNzISc9418BNxQwzu56l2lvEJVZ8BVy/kEIulGf8kzbJzZIa1PbRyXS+dQN3Ol7rxTG
         2RtYv5tv2mc2jouwTuUryfrfiko+oEy7Ueho4LMViZpiqF7w4dfma83P8yTIJpwho6kT
         /cXQAV2kTJt5qH283WCiDLgd8B/j+GTeCJzwdLZ+uclbuaZX2dCkpc59Bb62v0alpRPp
         hntHN6BRR/sev4GTes0DcYuH/I3+5Ix0eSdGJaPZGR3O+PwrqY5zs4NLS9NOoKDlrZTy
         0OrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxi3cqFor3XTSLQepm5PAsBUgoogif6QsUbB8s9ngl4=;
        b=ApeKMlB7EHteDLENTHexcWHxeab3jB3MxKkKR+j2mmc+RbxxwlYJiLUcago1mBuorx
         01xFHWdMBR/C2CQuYeGUNZn/18zbMyf2YG2h+3gHsLi/Ll+weZX0trpH4OlRT/qXHn3Q
         RmJcUajr7SQ55EtiSb9dOf+XyM0R+eiPBdM5uREk9X2ue4wlkux/DADPOY4TpaKgYUHc
         9Qo1iYWAJ5ZxDH8JtElzYYxcOksC4UUFq3QDyaM2DPAecQvHBOv0WfaTF/YmtRZZIrFz
         XHj8nSs86oNRDQgsW6FHh/BNchYHeTOQv3bZk2g12rCjS+v7R/dSA297KS6gzXfrT0Dl
         +Ugw==
X-Gm-Message-State: AOAM533jQsZb269+eCoIu4Xl9QYJo6z3IxaAk6FqyIZbUvWO/u2O1hEX
        EfjE1Oe97AkoqkkTrQYbkXM=
X-Google-Smtp-Source: ABdhPJz4jFhrR0xM3KcLDctozeo7FabTrQZWpKM1dZXNnPxr8l/2iUefYCtzDdj7MdxRqkSnk0RO4w==
X-Received: by 2002:a50:cbcd:: with SMTP id l13mr26719102edi.384.1595361090548;
        Tue, 21 Jul 2020 12:51:30 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id q21sm17180574ejc.112.2020.07.21.12.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 12:51:29 -0700 (PDT)
Date:   Tue, 21 Jul 2020 22:51:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200721195127.nxuxg6ef2h6cs3wj@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
 <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
 <20200720221314.xkdbw25nsjsyvgbv@skbuf>
 <20200721002150.GB21585@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721002150.GB21585@hoboy>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 05:21:50PM -0700, Richard Cochran wrote:
> On Tue, Jul 21, 2020 at 01:13:14AM +0300, Vladimir Oltean wrote:
> > I think at least part of the reason why this keeps going on is that
> > there aren't any hard and fast rules that say you shouldn't do it. When
> > there isn't even a convincing percentage of DSA/PHY drivers that do set
> > SKBTX_HW_TSTAMP, the chances are pretty low that you'll get a stacked
> > PHC driver that sets the flag, plus a MAC driver that checks for it
> > incorrectly. So people tend to ignore this case.
> 
> Right.
> 
> > Even though, if stacked
> > DSA drivers started supporting software TX timestamping (which is not
> > unlikely, given the fact that this would also give you compatibility
> > with PHY timestamping), I'm sure things would change, because more
> > people would become aware of the issue once mv88e6xxx starts getting
> > affected.
> 
> I really can't see the utility in having a SW time stamp from a DSA
> interface.  The whole point of DSA time stamping is to get the ingress
> and egress time of frames on the external ports, in order to correct
> for the residence time within the switch.
> 
> Thanks,
> Richard

I understand where this is coming from. The DSA software data path is
the mirror image of the hardware data path: first the net device
corresponding to the switch port, then the net device corresponding to
the host port, then the physical host port, then the physical switch
port. So, just as hardware timestamping makes the most sense on the
outermost PHC, software timestamping makes the most sense on the
innermost driver, the last frontier before the packet leaves software
hands. That is clear.

But I feel that going as far as saying that 'DSA shouldn't set
SKBTX_IN_PROGRESS because it already offers hardware timestamping' is
wrong. A software timestamp provided by a DSA net device is just as
valuable (or not, depending on your needs) as a software timestamp
provided by any other net device. For example, to the people doing TCP
time stamping, this software timestamp is just 'the driver timestamp',
so it makes perfect sense to have it just where it is: in DSA. Not only
that, but we shouldn't completely rule out the idea of software TX
timestamps in DSA _and_ in the host interface for the same packet,
either, since that could form the basis for some nice benchmarking.

Not only that, but with PHY timestamping, one popular way of handling TX
hardware timestamps from a PHY is to call skb_tx_timestamp(). It is
nonsense to me, and counterproductive, to end up having that in the
code, but not claim SOF_TIMESTAMPING_TX_SOFTWARE support. And PHY
timestamping with DSA is not a contradiction in terms by any means,
on the contrary, it makes just as much sense as PHY timestamping in
general.

So I think the position of "just don't have software timestamping code
in DSA and you'll be fine" won't be getting us anywhere. Either you can
or you can't, and there isn't anything absurd about it, so sooner or
later somebody will want to do it. The rules surrounding it, however,
are far from being ready, or clear.

Am I missing something?

Thanks,
-Vladimir
