Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CD715C2C2
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgBMPaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:30:17 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35818 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387911AbgBMPaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:30:15 -0500
Received: by mail-pj1-f66.google.com with SMTP id q39so2575264pjc.0
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h4tXxCDqUAeynBn8YfdI4d7ZTww8jr1pxW2BfTAecOw=;
        b=JBecrczYg/FyZDYE2AD6DZpQw8AIB6CSVaDIj1K/dFnFrEr2zRO+zLKtyzp0Z39Xnq
         IuzUCdw9nwffWRWpajJpZT4OwMlCOpi+ovKz39fufc6rkztLeurDSzyNe3kRmokyBG5a
         +gmLrP5OOJcRjRxe3NO22f1QhCsls+vFKA2xeDyT0LwwB82JrEWA0p0tk+R0gX0c2r7S
         JAlpTr7pQJSmAat59NdTtv1EOte41xirVsrnmS7VmioGXwX+f6Xb7ZDenCH+XGQZrBMm
         8W02xkMZue137NK7rZCbMlPlIIdZLugk5OSsohCHVUeZa3qxGN2q42ZhcsH2tzSRajoX
         wjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h4tXxCDqUAeynBn8YfdI4d7ZTww8jr1pxW2BfTAecOw=;
        b=Xs+qrpqmiPrmsKkRBBex/+xons/Rn4jfSS6CfeuUIvp/X2ambAd7bga3OIlwQ/hhI3
         zwgS9v1ZUFBty5+0ny8I9b390G1rkrEaz2an9Pwb7hzB+suaXIPaMtL9pAcBUabigC4c
         178PjfCPpKyg8Idcs/+/Flqe5xZcrXwRPjvkwoRE1fi7bad0V/BvkRsQBjaFTniFE54C
         6MizSOvltRsTGgBkcUSdjZQre5DvbKLdIBXb8G+/MnqYHIajzEfYmO8LuJen3WYijJqs
         ut9NE3L4+MY7S5EO3+z3ukdFpp9wksx2iKdHxDji5OOd1jicrdD6v1TUa7iEr2QgjdKS
         yt1A==
X-Gm-Message-State: APjAAAU+8h3DD+bBcjjKBbH2qSxkZdv2vQ1Lx/B8lVKrHBPl5GeRvWRN
        tKuf4lh4bNGs2LnRlzuZgBu9VF+WCQ==
X-Google-Smtp-Source: APXvYqz4gm0XDqU07OdTiTdJXfSfampqcbHQpGnuG26etIIxJDg/VSwU6SBMHKkVPXZ7r6GHgiSJqg==
X-Received: by 2002:a17:90b:97:: with SMTP id bb23mr5485019pjb.53.1581607815090;
        Thu, 13 Feb 2020 07:30:15 -0800 (PST)
Received: from mani ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id x6sm3506464pfi.83.2020.02.13.07.30.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Feb 2020 07:30:14 -0800 (PST)
Date:   Thu, 13 Feb 2020 21:00:08 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Dan Williams <dcbw@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate QRTR Nameservice to Kernel
Message-ID: <20200213153007.GA26254@mani>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
 <34daecbeb05d31e30ef11574f873553290c29d16.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34daecbeb05d31e30ef11574f873553290c29d16.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Thu, Feb 13, 2020 at 09:22:39AM -0600, Dan Williams wrote:
> On Thu, 2020-02-13 at 14:44 +0530, Manivannan Sadhasivam wrote:
> > Hello,
> > 
> > This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice
> > from userspace
> > to kernel under net/qrtr.
> > 
> > The userspace implementation of it can be found here:
> > https://github.com/andersson/qrtr/blob/master/src/ns.c
> > 
> > This change is required for enabling the WiFi functionality of some
> > Qualcomm
> > WLAN devices using ATH11K without any dependency on a userspace
> > daemon.
> 
> Just out of curiousity, what's the motivation for not requiring a
> userspace daemon? What are the downsides of the current userspace
> daemon implementation?
>

The primary motivation is to eliminate the need for installing and starting
a userspace tool for the basic WiFi usage. This will be critical for the
Qualcomm WLAN devices deployed in x86 laptops.

Also, there are some plans to implement QRTR link negotiation based on this
in future.

Thanks,
Mani
 
> Dan
> 
> > The original userspace code is published under BSD3 license. For
> > migrating it
> > to Linux kernel, I have adapted Dual BSD/GPL license.
> > 
> > This patchset has been verified on Dragonboard410c and Intel NUC with
> > QCA6390
> > WLAN device.
> > 
> > Thanks,
> > Mani
> > 
> > Manivannan Sadhasivam (2):
> >   net: qrtr: Migrate nameservice to kernel from userspace
> >   net: qrtr: Fix the local node ID as 1
> > 
> >  net/qrtr/Makefile |   2 +-
> >  net/qrtr/ns.c     | 730
> > ++++++++++++++++++++++++++++++++++++++++++++++
> >  net/qrtr/qrtr.c   |  51 +---
> >  net/qrtr/qrtr.h   |   4 +
> >  4 files changed, 746 insertions(+), 41 deletions(-)
> >  create mode 100644 net/qrtr/ns.c
> > 
> 
