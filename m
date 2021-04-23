Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124FF369D31
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhDWXPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235280AbhDWXOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 19:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD0F2613BE;
        Fri, 23 Apr 2021 23:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619219656;
        bh=rgFbm4rSeZo7SNUA5vojLwUrtdE0OJSl7zDHjIXUgRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SXxzyfJHubDdXLaTyI3RBY9fEv+2X0c752JhyMDUtaGBJppDHeAfmIvDpToeFqM6I
         5OgfcHTQ7tFWhkAgzytzzbinMDRe1mpQJ2V/Qy3udhxgeI3hZ1fpTeP/3VDqw345fd
         sAZcugGF47FWCrNa6HZKB5JuahWV0nwR2ME8FCnCV7Gso9k5oNTApPFAIqZO0F0t+9
         /I+HjHibFYLpvDbLHIZ2olQf36TCBzEC0f9iN2Xf/ZQGg5SUlkFdj49VGu3xJgDNBD
         2Ltf6LjRueuQspGV46r1KVuQJ8sOKTSMoAEoRwjCl2IxNL1L3wqTdxy2pb/2J9hVsz
         islAMN0NFdTrw==
Date:   Fri, 23 Apr 2021 16:14:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Message-ID: <20210423161414.5ac326e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB432267E19D8EB0F0760E1D76DC459@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210421174723.159428-1-saeed@kernel.org>
        <20210421174723.159428-7-saeed@kernel.org>
        <20210421122008.2877c21f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0D056D310687E3CEA58DC469@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20210422093642.20c9e89e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432267E19D8EB0F0760E1D76DC459@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Apr 2021 06:53:29 +0000 Parav Pandit wrote:
> > > Your memory is correct.
> > > In past external flag was present but it was always set to false.
> > > So you asked to move out until we set it to true, which we did.
> > > This series uses it as true similar to existing PF and VF eswitch ports of an  
> > external controller.  
> > > Hence, it was removed from past series and done in this series that actually  
> > uses it.
> > 
> > Right. I still think it's a weird model to instantiate an SF from the controller
> > side, but if your HW is too limited to support nested switching that's fine.  
> 
> I can't locate the old email thread, but we discussed the use cases.
> Nested switch may be solution to some use case but not for the current one.
> In the use case of interest, multiple tenant applications are running in a bare-metal host.
> Such host should not have access to switching rate, policy, filter rules, encryption keys.
> Each such tenant is assigned one VF or SF running on the host system.

Bare metal, and multiple tenants do not compute for me but that's fine.

> Also, this model doesn't prevent nested switch implementation for mlx5 and other vendors.
> Each such nested switch in that case will do its own programming at its own level.
> Such model is already described by Jiri in the RFCv3 [1].

As I said, I'm okay with the changes, please repost if they were
dropped from PW already.
