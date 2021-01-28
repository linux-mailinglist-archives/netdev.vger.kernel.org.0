Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA86307154
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhA1IUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231699AbhA1IUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 03:20:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3859D6146D;
        Thu, 28 Jan 2021 08:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611821989;
        bh=OWt9aSJrEhxFZwv/GTOowsCUwTQkW2yI0qqntEPqt+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ujvX1DuY2bt0MDImdi8UEYiDWm4T3EGMqlNEHu3x1myJ58uT6idEuPSGQxr1bX/Rf
         v+QU/ipIqGeJWblfreSmcGLRlgQlzX8yw+zQRQoxYajntNOs14IwZdqsg14eYw52zE
         0YsZpm7EAzdew3QhU261j8vZFPKnwzh1/8Q17kS0vgjjcYYzFogcDRnMvRSxVggPXA
         iCzNWSxeP/+V7p20YfLUgnO+Z5k28HB5W8qbpdsAmWGYd9958VLtr44/NvwGTQ8ehM
         NKi5TgBATPGD1ywd0kARj9itgskWOR3FOgdkbRC2OrkIO6sHCHXHnfJMRXN5QBOHrB
         W3kZBlANKzdcg==
Message-ID: <00a20e1146cf7c0e2a5a114781d1b1b6d369cdde.camel@kernel.org>
Subject: Re: [net-next 01/14] devlink: Add DMAC filter generic packet trap
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Thu, 28 Jan 2021 00:19:48 -0800
In-Reply-To: <20210127195408.3c3a5788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
         <20210126232419.175836-2-saeedm@nvidia.com>
         <20210127195408.3c3a5788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-27 at 19:54 -0800, Jakub Kicinski wrote:
> On Tue, 26 Jan 2021 15:24:06 -0800 Saeed Mahameed wrote:
> > From: Aya Levin <ayal@nvidia.com>
> > 
> > Add packet trap that can report packets that were dropped due to
> > destination MAC filtering.
> > 
> > Signed-off-by: Aya Levin <ayal@nvidia.com>
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> >  Documentation/networking/devlink/devlink-trap.rst | 5 +++++
> >  include/net/devlink.h                             | 3 +++
> >  net/core/devlink.c                                | 1 +
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/Documentation/networking/devlink/devlink-trap.rst
> > b/Documentation/networking/devlink/devlink-trap.rst
> > index d875f3e1e9cf..1dd86976ecf8 100644
> > --- a/Documentation/networking/devlink/devlink-trap.rst
> > +++ b/Documentation/networking/devlink/devlink-trap.rst
> > @@ -480,6 +480,11 @@ be added to the following table:
> >       - ``drop``
> >       - Traps packets that the device decided to drop in case they
> > hit a
> >         blackhole nexthop
> > +   * - ``dmac_filter``
> > +     - ``drop``
> > +     - Traps incoming packets that the device decided to drop in
> > case
> 
> s/in case/because/
> 
> > +       the destination MAC is not configured in the MAC table
> 
> ... and the interface is not in promiscuous mode
> 

Makes sense ! 

> > +
> 
> Double new line
> 
> >  Driver-specific Packet Traps
> >  ============================
> 
> Fix that up and applied from the list.

Thanks,
I can stop sending pull requests and siwtch to normal patchsets 
if this will be more convenient to you/

to me is just converting the cover letter :).. 



