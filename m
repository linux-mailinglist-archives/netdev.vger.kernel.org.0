Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16445270373
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgIRRh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRRhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:37:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B33421707;
        Fri, 18 Sep 2020 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450645;
        bh=5Ehvg/Gv0LR6FDHLO8L6NK44NmRjTMJyPVlVhhnmQtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ywOSG9a2LQgtrgQ6y3trygbs6E0qyfIqvuxZybHlDPDjL2QiFqC0iQ5IzdcX6V1Qc
         sENm7zSilrJOyFCKvDfynRC7QX0fJhZtH+tHHw7kj4fAqd8AMJ8J5nnmtt0La+QoAi
         5w7KvoeL2lutca9rZTTSEIxgchZAOcVr8ylnfavQ=
Date:   Fri, 18 Sep 2020 10:37:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Message-ID: <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
        <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 17:08:15 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, September 18, 2020 10:22 PM
> > 
> > On Thu, 17 Sep 2020 20:20:12 +0300 Parav Pandit wrote:  
> > > Hi Dave, Jakub,
> > >
> > > Similar to PCI VF, PCI SF represents portion of the device.
> > > PCI SF is represented using a new devlink port flavour.
> > >
> > > This short series implements small part of the RFC described in detail at [1]  
> > and [2].  
> > >
> > > It extends
> > > (a) devlink core to expose new devlink port flavour 'pcisf'.
> > > (b) Expose new user interface to add/delete devlink port.
> > > (c) Extends netdevsim driver to simulate PCI PF and SF ports
> > > (d) Add port function state attribute  
> > 
> > Is this an RFC? It doesn't add any in-tree users.  
> It is not an RFC.
> devlink + mlx5 + netdevsim is crossing 25+ patches on eswitch side.
> So splitting it to logical piece as devlink + netdevsim.
> After which mlx5 eswitch side come close to 15 + 4 patches which can
> run as two separate patchset.
> 
> What do you suggest?

Start with real patches, not netdevsim.
