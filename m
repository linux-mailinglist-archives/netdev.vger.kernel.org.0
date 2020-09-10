Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9700B264DA0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgIJSrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgIJSqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 14:46:38 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5822220855;
        Thu, 10 Sep 2020 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599763597;
        bh=SWNGqWijdR8em/8AiFsYsX8TxgqfsnS8CcMHhK9zfPc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tKdGRYXiW7oXQ1+0KDRE0csTftOJglN79bwl6wl7BeKTYOjIBIGuoTGnBOSFb0u3v
         JeM4IgIpGkRB4VAF5bwNN8+JEY/3oXS9jmO3933yaVNGd1EpZCCmRD1VuKK3T402gY
         CdNMW4f4wv1ru4k3Zg/KLOBDFip506n22AGurQic=
Message-ID: <fc4effe1bbe6e9c68f4bdd863e3d38cbab52a285.camel@kernel.org>
Subject: Re: [PATCH 4.19] net/mlx5e: Don't support phys switch id if not in
 switchdev mode
From:   Saeed Mahameed <saeed@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>
Date:   Thu, 10 Sep 2020 11:46:36 -0700
In-Reply-To: <20200807131323.GA664450@kroah.com>
References: <20200807020542.636290-1-saeedm@mellanox.com>
         <20200807131323.GA664450@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-08-07 at 15:13 +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 06, 2020 at 07:05:42PM -0700, Saeed Mahameed wrote:
> > From: Roi Dayan <roid@mellanox.com>
> > 
> > Support for phys switch id ndo added for representors and if
> > we do not have representors there is no need to support it.
> > Since each port return different switch id supporting this
> > block support for creating bond over PFs and attaching to bridge
> > in legacy mode.
> > 
> > This bug doesn't exist upstream as the code got refactored and the
> > netdev api is totally different.
> > 
> > Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
> > Signed-off-by: Roi Dayan <roid@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> > Hi Greg,
> > 
> > Sorry for submitting a non upstream patch, but this bug is
> > bothering some users on 4.19-stable kernels and it doesn't exist
> > upstream, so i hope you are ok with backporting this one liner
> > patch.
> 
> Also queued up to 4.9.y and 4.14.y.
> 

Hi Greg, the request was originally made for 4.19.y kernel,
I see the patch in 4.9 and 4.14 but not in 4.19 can we push it to 4.19
as well ? 

Thanks,
Saeed.



