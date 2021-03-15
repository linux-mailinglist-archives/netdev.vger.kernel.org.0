Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD8233C35C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhCORGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhCORGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D12D264DE0;
        Mon, 15 Mar 2021 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615827974;
        bh=4nCEJrkgjEg8ZCFpz+KcQOCOEOEkh8qMRKuu0yhXpwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TMggV8YtLHiitnwx7luWYP+j7uU4hRbguD1TXpuBZK+BP6IiGoWhLuOoydWg5j1As
         Jfj7SYQKYhA9gnFzBmVrBGuTtG3Fum/9Da6NYdWhVfPeHcFAE5V47vzILgPee9mW6M
         ZAdnbTMJ57McZ8WsP0wKqKL80K9VT5SD9VaBEu8KFbgUHNj/RK7V25DD++nbgI8CJ8
         iaie0jE9k+ELUUZnfsQ5fV7wNgX3gpGGn6JXLQYjukE+qUpSbtr97AVMWsJ2BEo7ON
         9o3zr279O/SrAT0g0gCOYX3mALquz/5z8BDY/rAVjGQcw3qx1tK4Ac+pGZgm3h603i
         Dd+XSeX4TRi4A==
Date:   Mon, 15 Mar 2021 10:06:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [RFC net-next v2 3/3] devlink: add more failure modes
Message-ID: <20210315100612.5e98ec90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8db7b4e5-bca2-715e-9cf0-948ca674b8a1@nvidia.com>
References: <20210311032613.1533100-1-kuba@kernel.org>
        <20210311032613.1533100-3-kuba@kernel.org>
        <8d61628c-9ca7-13ac-2dcd-97ecc9378a9e@nvidia.com>
        <20210311084922.12bc884b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8db7b4e5-bca2-715e-9cf0-948ca674b8a1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Mar 2021 14:33:10 +0200 Eran Ben Elisha wrote:
> On 3/11/2021 6:49 PM, Jakub Kicinski wrote:
> > On Thu, 11 Mar 2021 16:23:09 +0200 Eran Ben Elisha wrote:  
> >> Would you like Nvidia to reply with the remedy per reporter or to
> >> actually prepare the patch?  
> > You mean the patch adding .remedy? If you can that'd be helpful.
> > 
> > Or do you have HW error reporters to add?
> 
> I meant a patch to add .remedy to existing mlx5* reporters to be part of 
> your series.

After talking some more with the HW health team the series appears less
necessary than I thought. I'm putting it on hold for now, sorry.
