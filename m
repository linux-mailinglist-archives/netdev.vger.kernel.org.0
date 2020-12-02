Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEEC2CC7EF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgLBUie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgLBUie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:38:34 -0500
Date:   Wed, 2 Dec 2020 12:37:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606941473;
        bh=pbpkZdD35o9UDYkf4M/CKkGMhyw21mknDYPTAI8ySHw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=sQaVNqNX1bWaRARq0KWkPgmE2rxgn/1wHfYDmZN9hV+UFYYaO7RKCaTH+eOxTzsHd
         DaLXOberx3xMjVWb44w9FbDGv/fSMf46khSIpFIxNBRE56kDQ36+DtQrRSy1yGUJSH
         ETC+kDveQP3ec9eJt0GmXodmH0nUzqfQngUCj+uM+Pp/tLWbRE14x0X/zHE9bq0O5x
         Q973wwtyHvxrnlgYj/mNBorHx8iJ1nPifdf9cnPBcbvjWL4f9SD6DWMYDeHWL4o3Tw
         NxVI54uVS4cMjWWztuTFoMhU6nOmN9NS/gR0MOCrU7hNS9Pu/dVLVJa7KEsRGmkmF2
         ikUrboF3FbMFQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2020-12-01
Message-ID: <20201202123752.205be1c7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <5fde80a4326c45950615918e6e51b5d28d4b9e96.camel@kernel.org>
References: <20201201224208.73295-1-saeedm@nvidia.com>
        <20201202104859.71a35d1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <0d6433ee05290e5fe109ca9fd379f5d1c7f797c8.camel@kernel.org>
        <20201202112059.0f9f7475@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <5fde80a4326c45950615918e6e51b5d28d4b9e96.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Dec 2020 12:15:15 -0800 Saeed Mahameed wrote:
> On Wed, 2020-12-02 at 11:20 -0800, Jakub Kicinski wrote:
> > To be clear - I'm asking you to send a PR for the pre-reqs and then
> > send the ethernet patches. So that the pre-reqs are in the tree
> > already
> > by the time the ethernet patches hit the ML. I thought that's what
> > you
> > did in the past, but either way it'd make my life easier.  
> 
> Ok, Done, will submit two separate pull requests.
> 
> But to avoid any wait and to create full visibility, is there a way to
> let the CI bot understand dependency between two separate pull requests
> ? or the base-commit of a pull request ?

Possibly it's just a python script (available on GH). 

Although we don't allow people to queue up multiple series which 
are co-dependent, I'm not sure if using PRs changes that much.
There still needs to be a reasonable rate control on number of patches
for example.

> I would like to send everything in one shot for full visibility.

Hm, not sure what you mean by visibility.
