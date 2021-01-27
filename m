Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76302305177
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbhA0EaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403783AbhA0Bno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:43:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD702065D;
        Wed, 27 Jan 2021 01:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611711260;
        bh=tMkdDofcNTQHINo5Xp0tF9+KiFMivGI4hh5foOUZTEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GWcrIjeiz1c8FvM/F42NY9xd3RKakctBex8ElgnL/yq4CLCurC0uLcaEhrzdjOyVz
         3XpubZ7cSCgYurD6HP+dP09xKtGgTLkBUzgeoMDzy5ejynimb0k4P4XS1Nrr7WX/t8
         9h9zkqSuwvwomLG89DW60tVupYU8puPZgDE4DAdfuf6C70i5w54LZVNKRzZ4X6KfEz
         Mi7zxByqGh8ho4CTT3FLt/akb6+nX+Mv4kym+u1gOAUJJKV4v2YbjiZNyStYbukPhj
         OwsiZdwp9h8rB5rNtQz3ByI0QeJKLQmG+hcXEuEeLc2TR80+YXKscqe59JlRvbM/dV
         jqqnbA1Iy1Jbg==
Date:   Tue, 26 Jan 2021 17:34:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, jacob.e.keller@intel.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, alexander.duyck@gmail.com,
        dsahern@kernel.org, kiran.patil@intel.com,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Message-ID: <20210126173417.3123c8ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122193658.282884-1-saeed@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 11:36:44 -0800 Saeed Mahameed wrote:
> This series form Parav was the theme of this mlx5 release cycle,
> we've been waiting anxiously for the auxbus infrastructure to make it into
> the kernel, and now as the auxbus is in and all the stars are aligned, I
> can finally submit this patchset of the devlink and mlx5 subfunction support.
> 
> For more detailed information about subfunctions please see detailed tag
> log below.

Are there any further comments, objections or actions that need to be
taken on this series, anyone?

Looks like the discussion has ended. Not knowing any users who would
need this I'd like to at least make sure we have reasonable consensus
among vendors.
