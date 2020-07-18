Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380B7224AFC
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgGRLfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgGRLfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:35:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24845C0619D2;
        Sat, 18 Jul 2020 04:35:23 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so13560435ejb.2;
        Sat, 18 Jul 2020 04:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Q6Y3coy8/GfK5pBTD7N4wQAN58FaNaEy92aRxSt8V8=;
        b=TcmyFC2o9IJpTUTJ/IBk2ogNmErJvD/Uuq5gLsf1Ayb7XSOGx3kx0FwCpbOHjPXU9U
         1qXg8bFOJiMADUKJnsa1fNpWSMW6Eiv8GBkr71wCxpGW9dRgqTSiL0yyo5++xaoMoJp4
         QVr1nRvWFusM1ZNhgkNjKNde8zoHc5bFk+OMeHYpxZcZKKVDh9XVHofdtD7ZkLfCF7Xw
         nOeLetaI28WuCeh172DokrfHFIw/Eg3XqQIxyok8zvFysBey9KhVCpzNrhAuJRnsXLQW
         ZyrOmoCcLX2ybwtzgB2XuQDCkebu82bzRgz22kTZFCkLtED1/Lwm4FqXFQ7nTKUxQs2V
         tzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Q6Y3coy8/GfK5pBTD7N4wQAN58FaNaEy92aRxSt8V8=;
        b=C8pVHjnY+jW6CjDJKhkLCX2AeamtE0a2oz5Fb0LDbmLOjgE/bnkZHHR5bo/U73IGDM
         UM24RL4zQlsDHzDqyzedWUfpTJ3XeTb+yhFCtsB9QeXxyIeaKVDjBlXXfWzObxhYPlVZ
         DXB7mq0Ho6qaF1j0/XSK2vD7lP/nK+MUiovXBLk7jAVg7tAVbpHLbj/EgKs8tmp8edwe
         AzRrrpR5R9IoDCwVgR9C2jis+rqyXc3MFIxK4+E/5Dn4x6pFLMLZ1sczEqUB3uEIW0jn
         iFD7f9nbEkU2Oc4zskdaBghDwAfcZ4DlbD3aKHgfet9B7a8FKewf1dCKlN7QiQ7ADlOG
         Ye4Q==
X-Gm-Message-State: AOAM533aqHDulapTxRuIk99IxOiiUwbDj5vpcpdghelH0BUUsutnyVXZ
        BDuGbi1ENnf/hRUohKgF7XE=
X-Google-Smtp-Source: ABdhPJxZLdHv8aMkzYiea/wyQytNRKQhM7woBxNwlS4DVESAOeJot7TRgB0PxLBOiSc7QAJmfY9zGg==
X-Received: by 2002:a17:906:355b:: with SMTP id s27mr13254891eja.368.1595072121653;
        Sat, 18 Jul 2020 04:35:21 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id l1sm11174689edi.33.2020.07.18.04.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 04:35:21 -0700 (PDT)
Date:   Sat, 18 Jul 2020 14:35:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200718113519.htopj6tgfvimaywn@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 04:12:07PM -0700, Jacob Keller wrote:
> 
> 
> On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> > These are some questions I had while trying to explain the behavior of
> > some drivers with respect to software timestamping. Answered with the
> > help of Richard Cochran.
> > 
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  Documentation/networking/timestamping.rst | 26 +++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> > index 4004c5d2771d..e01ec01179fe 100644
> > --- a/Documentation/networking/timestamping.rst
> > +++ b/Documentation/networking/timestamping.rst
> > @@ -791,3 +791,29 @@ The correct solution to this problem is to implement the PHY timestamping
> >  requirements in the MAC driver found broken, and submit as a bug fix patch to
> >  netdev@vger.kernel.org. See :ref:`Documentation/process/stable-kernel-rules.rst
> >  <stable_kernel_rules>` for more details.
> > +
> > +3.4 Frequently asked questions
> > +------------------------------
> > +
> > +Q: When should drivers set SKBTX_IN_PROGRESS?
> > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > +
> > +When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
> > +and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
> > +Originally, the network stack could deliver either a hardware or a software
> > +time stamp, but not both. This flag prevents software timestamp delivery.
> > +This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
> > +option, but still the original behavior is preserved as the default.
> > +
> 
> So, this implies that we set this only if both are supported? I thought
> the intention was to set this flag whenever we start a HW timestamp.
> 

It's only _required_ when SOF_TIMESTAMPING_TX_SOFTWARE is used, it
seems. I had also thought of setting 'SKBTX_IN_PROGRESS' as good
practice, but there are many situations where it can do more harm than
good.

> > +Q: Should drivers that don't offer SOF_TIMESTAMPING_TX_SOFTWARE call skb_tx_timestamp()?
> > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > +
> > +The ``skb_clone_tx_timestamp()`` function from its body helps with propagation
> > +of TX timestamps from PTP PHYs, and the required placement of this call is the
> > +same as for software TX timestamping.
> > +Additionally, since PTP is broken on ports with timestamping PHYs and unmet
> > +requirements, the consequence is that any driver which may be ever coupled to
> > +a timestamping-capable PHY in ``netdev->phydev`` should call at least
> > +``skb_clone_tx_timestamp()``. However, calling the higher-level
> > +``skb_tx_timestamp()`` instead achieves the same purpose, but also offers
> > +additional compliance to ``SOF_TIMESTAMPING_TX_SOFTWARE``.
> > 
> 
> This makes sense.
> 
> Thanks,
> Jake

Thanks,
-Vladimir
