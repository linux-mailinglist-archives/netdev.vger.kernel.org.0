Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D04308230
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhA2ADr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:03:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2ADo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4881A64DFD;
        Fri, 29 Jan 2021 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611878583;
        bh=+B5GpeNuOPCCZbjHfo3AU73ykMRYQQwfmg452C8/+RI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kardqs2hpGzzxgvJnTF6UzULqmUaluYSkSpMCYqbXrSpOpToVbGegl24Fu0kjvkQK
         G/mT+R+6nubkqIBawxYv3z7AUcgx9+TmmDNSrD2m8BJv6JWGSiPRRqd89oqYdJ4T41
         kgUwR99dcqcZ3EdxHXyl6Mw03982Ae6P1c7x7rlpEnMW5ufYbuFccJlN0+YlCcLB0v
         vcIIvSZdOVGpLUsQilgN3EmKfWwQTP13ub/dP/iH2Hlm5OSIOjH12zQuyVxStAugec
         sxgaixE3sFvI96ZWFU7GDOZcEBYuY3tO8ocpq7ZuosCUas777TEGS4zQFcr00qjE41
         UCWt/tiZWur0A==
Message-ID: <d6fa72b34eb65e17847463bf7084f5a25c8ad492.camel@kernel.org>
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, jacob.e.keller@intel.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, alexander.duyck@gmail.com,
        dsahern@kernel.org, kiran.patil@intel.com,
        david.m.ertman@intel.com, dan.j.williams@intel.com
Date:   Thu, 28 Jan 2021 16:03:02 -0800
In-Reply-To: <20210126173417.3123c8ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210122193658.282884-1-saeed@kernel.org>
         <20210126173417.3123c8ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-26 at 17:34 -0800, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 11:36:44 -0800 Saeed Mahameed wrote:
> > This series form Parav was the theme of this mlx5 release cycle,
> > we've been waiting anxiously for the auxbus infrastructure to make
> > it into
> > the kernel, and now as the auxbus is in and all the stars are
> > aligned, I
> > can finally submit this patchset of the devlink and mlx5
> > subfunction support.
> > 
> > For more detailed information about subfunctions please see
> > detailed tag
> > log below.
> 
> Are there any further comments, objections or actions that need to be
> taken on this series, anyone?
> 
> Looks like the discussion has ended. Not knowing any users who would
> need this I'd like to at least make sure we have reasonable consensus
> among vendors.

Hey Jakub, sorry to nag, but I need to make some progress, can we move
on please ? my submission queue is about to explode :) !

Thanks,
Saeed.


