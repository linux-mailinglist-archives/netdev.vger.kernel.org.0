Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E191AD0DB
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgDPUIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbgDPUIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 16:08:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2FBD21744;
        Thu, 16 Apr 2020 20:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587067711;
        bh=SzKodbRQEKR5iJVQV169c24h77aFSt1RUuxVEcEC/no=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hpY+8rCU6SYhA0uqjLwq2w3LdOJjQaBX/MXO+hi+i/eYNIkWl53nEiLZx6h/ZkK+J
         8mpRaT+3S1673MFx1YbdcDLdWTKt2OWNG3EPlVe0svDFAw+BguCTMU3gIeVvyUwuI6
         5Ds8h1Gp4aWildXyE1bUMaHgE2cp47BSN16zWuA8=
Date:   Thu, 16 Apr 2020 13:08:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416130828.1f35b6cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
References: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200414015627.GA1068@sasha-vm>
        <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
        <20200414110911.GA341846@kroah.com>
        <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
        <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
        <20200414205755.GF1068@sasha-vm>
        <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
        <20200416000009.GL1068@sasha-vm>
        <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
        <20200416172001.GC1388618@kroah.com>
        <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020 19:31:25 +0000 Saeed Mahameed wrote:
> > > IMHO it doesn't make any sense to take into stable automatically
> > > any patch that doesn't have fixes line. Do you have 1/2/3/4/5
> > > concrete
> > > examples from your (referring to your Microsoft employee hat
> > > comment
> > > below) or other's people production environment where patches
> > > proved to
> > > be necessary but they lacked the fixes tag - would love to see
> > > them.  
> > 
> > Oh wow, where do you want me to start.  I have zillions of these.
> > 
> > But wait, don't trust me, trust a 3rd party.  Here's what Google's
> > security team said about the last 9 months of 2019:
> > 	- 209 known vulnerabilities patched in LTS kernels, most
> > without
> > 	  CVEs
> > 	- 950+ criticial non-security bugs fixes for device XXXX alone
> > 	  with LTS releases
> 
> So opt-in for these critical or _always_ in use basic kernel sections.
> but make the default opt-out.. 

But the less attentive/weaker the maintainers the more benefit from
autosel they get. The default has to be correct for the group which 
is more likely to take no action.
