Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FA42EA29D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbhAEBEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbhAEBEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 20:04:10 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7DEC061798
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 17:03:30 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r5so29298825eda.12
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 17:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bPpKRaYQm5Tk3ohKFOxc2XPf/i6yjXVwq2eecieZ0go=;
        b=hTqtbsFKKUacqE/4gKo3zZ8lzCveHlp6fAE4AE8L544fFbVl6koJ4lrgrDlRIMCH4A
         zkwXtD10Oxt1GSBNOY3MjyOcD6dqkuigwD2SlXNP0lYMmLvjC2cN5D09EO17e+GIkLeA
         LOnbpE45nq8IRPKomM/6yKQS282NkZCzILzCubvOwP+w0g87Hqy4dLNYSNQgjm3FaR/h
         xjqoACeCcPsQw3XtM0/bbTQlE092Yats+q55u0nGdyYLv3u+iPCxSS6BOnyCu1DNI3u2
         4qlmorXebJAATOqxjoOoWA4bw/LpCYucsDFYCJzMs50QpUwIdW1NlRZAxZ8cUj25KPdj
         he1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bPpKRaYQm5Tk3ohKFOxc2XPf/i6yjXVwq2eecieZ0go=;
        b=FtvpPAZ08D254KZENgrg5UghgsjHgzyVGWcDHk5Y/r0TW7YUjhstnd2lrkS0udDce/
         RsFtgX7BCZ0WVdorJpAghECU5/OQ+lLwpr58C02Ck7QXP+Ltqjb4ZeSAzAs8jdnWFYJ/
         8WM4CTbEoosMErpvGJnpj1LZrDGFW04AGjr52BtC628a0F/bhhFLKy34I4qsQqXOcY+Q
         JxUSEAQopQSBkGQO5WJ2eahIkfY1YQRgC7xfJiEsLealMhfDfRz8Jr+ynipO6OwJ5fhn
         x5U8NZg9fhKstzmQ5KGSlhrkIETeZne3jJtzLXTwGPlI0cA54cCm2O58bijccdZMqgDx
         eYZA==
X-Gm-Message-State: AOAM533qc1+EM6+BKs0hgi05uhTDav1OZEplkG4OCCcjw8teX2I+Lq+y
        KArMb36F+ve3Ye0EkcDNSg8qRwPF4XM=
X-Google-Smtp-Source: ABdhPJzJ24UsaaRpxmGmVnoKjYiYRWSvyvJ3Qi+hwLQcmvUV6VDek2b7JCJywVi/G6m+Pr9I172ZKw==
X-Received: by 2002:a05:6402:404:: with SMTP id q4mr75053170edv.295.1609808608937;
        Mon, 04 Jan 2021 17:03:28 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s12sm44780818edu.28.2021.01.04.17.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 17:03:28 -0800 (PST)
Date:   Tue, 5 Jan 2021 03:03:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] docs: net: fix documentation on .ndo_get_stats
Message-ID: <20210105010327.uc3zftj4sgkpjtwx@skbuf>
References: <20201231034524.1570729-1-kuba@kernel.org>
 <20210104104227.oqx6xt76k5snmhs6@skbuf>
 <20210104095309.28682a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104095309.28682a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 09:53:09AM -0800, Jakub Kicinski wrote:
> On Mon, 4 Jan 2021 12:42:27 +0200 Vladimir Oltean wrote:
> > On Wed, Dec 30, 2020 at 07:45:24PM -0800, Jakub Kicinski wrote:
> > > Fix calling context.
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > >  Documentation/networking/netdevices.rst | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
> > > index 5a85fcc80c76..a80676f5477d 100644
> > > --- a/Documentation/networking/netdevices.rst
> > > +++ b/Documentation/networking/netdevices.rst
> > > @@ -64,8 +64,8 @@ struct net_device synchronization rules
> > >  	Context: process
> > >
> > >  ndo_get_stats:
> > > -	Synchronization: dev_base_lock rwlock.
> > > -	Context: nominally process, but don't sleep inside an rwlock
> > > +	Synchronization: rtnl_lock() semaphore, or RCU.
> > > +	Context: atomic
> > >
> > >  ndo_start_xmit:
> > >  	Synchronization: __netif_tx_lock spinlock.
> >
> > And what happened to dev_base_lock? Did it suddenly go away?
>
> I thought all callers switched to RCU. You investigated this in depth,
> did I miss something? I'm sending this correction because I have a
> series which adds to other sections of this file and this jumped out
> to me as incorrect.

Well, there's netstat_show from net/core/net-sysfs.c still. I couldn't
figure why that lock exists, it doesn't seem to protect something in
particular.
