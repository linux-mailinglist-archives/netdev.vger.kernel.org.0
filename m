Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CDE2DD8C6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgLQSxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729996AbgLQSxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:53:39 -0500
Date:   Thu, 17 Dec 2020 10:52:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231179;
        bh=xsJoDeUcQZzq48W/fZX43kPP6cvgRCMBqzqMCfzacl8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=AqF2FFBsOTutMAv5ZcFLLmZgboWKNY122YhLvqxejIn7hkPtlTdJnIaVrhHV3KWmQ
         rs0+ZUBprjV5LvzK5E3n220giDSs09PTaLnJsu/83C3ijbdW7Qt8zmB2/wCtlSNiGB
         nelguBb7UES1YRe/6tHjd/vGMnARL/8EuIc1RW/eoiFWuyAS9uFP/sxxOUVxrm/7pa
         LpIewJQ1OwFt42IRj4RuiIdYz39HQOqqDebDSN5IhH3pUAyU+ljC8IFiFd1kymbfuc
         Qy8fu5toZlXQoX2u6XBS6ZCYAy64XFBxG/pzGLaaAuUOr7zs0gMr44cCNJGNOdMCKf
         eyTyAwmbxV1WQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Fix compilation warning for 32-bit
 platform
Message-ID: <20201217105257.6efd99c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216161445.512f2b68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201213120641.216032-1-leon@kernel.org>
        <20201213123620.GC5005@unreal>
        <565c26195b79ca998280d83aca0a193bd1a8c23e.camel@kernel.org>
        <20201216161445.512f2b68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 16:14:45 -0800 Jakub Kicinski wrote:
> On Mon, 14 Dec 2020 12:08:46 -0800 Saeed Mahameed wrote:
> > I will change this and attach this patch to my PR of the SF support.  
> 
> Looks like the SF discussion will not wind down in time to make this
> merge window, so I think I'm going to take this in after all. Okay?

Done.
