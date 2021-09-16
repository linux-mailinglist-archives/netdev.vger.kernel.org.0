Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4C40DC7D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbhIPOMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238063AbhIPOMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D8F361056;
        Thu, 16 Sep 2021 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631801476;
        bh=zRKM9ywgNPfShQPgTqpbqd7+yg4RwBKPi0Wl+h62Wsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aUk3hETcCCNBuwI9m8JCpw5R+ZEcEwCk4ihMMajLHCccmwpXzpj/9O0RkW0TxnF2J
         Q3ENSDNsHEpfqE4pGy8lEmiGAs32rm1w+DGOWxWGDHNzrS6dRMEKz6/GOJ/2mbv/yg
         yco8whsKWIKc1LNEdquLtI6H5r9geLJ6ned10Tv0yQujWTKMauWdeZT3xyJmEmdRst
         6/8Zhq/eWxkdMdZEaOTkuETZil83P7RKGEjGwJDmZRLrlv2n2uqx8Z+TXzJRR8FRYM
         uHWU+nRoDvXKl4NGc6//q8E+pNFMrKpNGiAJ7Qu34SnVJJwds7aDVa5HUAOukk2K3m
         HcTUjt4kCJsFg==
Date:   Thu, 16 Sep 2021 07:11:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Delete not-used devlink APIs
Message-ID: <20210916071115.09cfc02a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YUNMAi0Qjj5Dxiiw@unreal>
References: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
        <20210916063318.7275cadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YUNMAi0Qjj5Dxiiw@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 16:52:02 +0300 Leon Romanovsky wrote:
> > The port_param functions are "symmetric" with the global param 
> > ones. Removing them makes the API look somewhat incomplete.  
> 
> There is no value in having "complete" API that no one uses.

Well, for an API which we are hoping to attract vendors to, the
"completeness" could be useful. If kernel needs to be extended
some will fall back to their out of tree tools.

> > Obviously the general guidance is that we shouldn't export 
> > functions which have no upstream users but that applies to 
> > meaningful APIs. For all practical purposes this is just a 
> > sliver of an API, completeness gives nice warm feelings.  
> 
> It is misleading, I have much more warm feeling when I see API that is
> used. Once it will be needed, the next developer will copy/paste it
> pretty fast.
> 
> > Anyway, just curious what made you do this. I wouldn't do it 
> > myself but neither am I substantially opposed.  
> 
> Move of devlink_register() to be last command in the devlink init flow
> and removal of devlink_*_publish() calls as an outcome of that.

Alrighty:

Acked-by: Jakub Kicinski <kuba@kernel.org>
