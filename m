Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01D1D3E59
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgENUCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgENUCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 16:02:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8262065C;
        Thu, 14 May 2020 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589486563;
        bh=WHcambScRN7gZL/Z1NiKiNi+PhC7lpNI9WGQ2mHNL8c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eUVHXHE+B0+1VmPGvMH5ZRMO1zvjTwnpOl0hCAmCAGPZYzed/ONdveiTxdWTKZjQV
         vG4DuLiZA6dq4y32Dhq/7xVHLEcW/o0dHAASwo6mgZ0KM8F6bXNy1MqzQMRP9TweZx
         ULfZvKud4wINCZcW0kpz4WNDiRQgSu8DGvIYI27A=
Date:   Thu, 14 May 2020 13:02:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Denis Bolotin" <dbolotin@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw
 error handling
Message-ID: <20200514130241.177c3e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2a29996c-21a6-7566-c27e-7b8fb280e18c@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
        <20200514120659.6f64f6e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2a29996c-21a6-7566-c27e-7b8fb280e18c@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 22:40:12 +0300 Igor Russkikh wrote:
> > I'm not 100% happy that the debug data gets reported to the management
> > FW before the devlink health code is in place. For the Linux community,
> > I think, having standard Linux interfaces implemented first is the
> > priority.  
> 
> Hi Jakub,
> 
> Thanks for the comment. I feel these two are a bit separate. We try to push
> important messages to MFW, not debug data. And all these messages are as well
> perfectly being reported on device level error printouts, they are not kind of
> lost.
> 
> And for devlink, we anyway will need all the above infrastructure, to
> eventually implement devlink dumps and other features.
> 
> Or, may be I didn't get your point?

That's fine, I'm just saying - I hope the devlink part doesn't take too
long to implement :)
