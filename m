Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387F62D1A58
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgLGUNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgLGUNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:13:20 -0500
Date:   Mon, 7 Dec 2020 12:12:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607371959;
        bh=7HkocT8h7IW/Bk+XkFdMingV/nYvdfBBv7Q2G1N8Nkg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=M+KjgT+eo+wOwE/QcU6vCXDJcgxF8wfHVlcNVUZEdmuaHh0G15odZ505HnXAyAsIQ
         uEn2/FFZZnxLmGkbimBElgKGYs/0r+J/DTkQfRmrKrVQowl9cq1nD3T4Ro9Td61RAz
         0Bnv5gCZ4Hgteag+1zUYIRvGk4jByPlQmu+Z1Harx2JEKwtYi+UiDgtWdRKYchoUBZ
         DD9XksXCkInKf930Ky6JMayiT8/EDVfY9JbPqKi6oix2CD6rPERi7B9rzmB5LZpiJu
         ec5r5knNrjNc8yt5nirtiMDkFvAmlM2JXr6yxxCKbj/Um3p+A6A5ixH7JKWaAZyRo9
         pYOxJSv5g9miA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v4] devlink: Add devlink port documentation
Message-ID: <20201207121238.76dd1304@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <BY5PR12MB4322D2D98913DE805F8B8CE5DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201203180255.5253-1-parav@nvidia.com>
        <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BY5PR12MB43227128D9DEDC9E41744017DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201207094012.5853ff07@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BY5PR12MB4322D2D98913DE805F8B8CE5DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 20:00:53 +0000 Parav Pandit wrote:
> > > > Each port is a logically separate ingress/egress point of the device.
> > > >
> > > > ?  
> > > This may not be true when both physical ports are under bond.  
> > 
> > Bonding changes forwarding logic, not what points of egress ASIC has.  
> Ok. Do CPU and DSA port also follow same?

Yes, DSA/CPU port types are points of egress to the devlink instance.
