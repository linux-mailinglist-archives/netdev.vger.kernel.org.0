Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5568F26D35A
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIQGBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgIQGBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 02:01:42 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCB9208A9;
        Thu, 17 Sep 2020 06:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600322502;
        bh=ELy6trNzHSCf3/TFAqA2775MveG1cBL4OOfQvEqDIQo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vB2hwXfVZBqfdPB2tR9kNLsRddwoCtmk2XWl9X5jRUtE5SIDMVYPjBL2HYXRA1gBB
         M+SebP03BkhKM3Jgo9rDRbYwbB82D2wI9dftz3CDRUE/oDv9pguk2AjPmctD3VuU7E
         10M5ymjZco5OCWzev0y35oyC1l7HHxgO8kip6/cI=
Message-ID: <5e19e0ab2cdb0c0c71b50e55baaf59437aba81d2.camel@kernel.org>
Subject: Re: [pull request][net-next 00/16] mlx5 updates 2020-09-15
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 16 Sep 2020 23:01:40 -0700
In-Reply-To: <20200916095654.558c031f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200915202533.64389-1-saeed@kernel.org>
         <20200916095654.558c031f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-16 at 09:56 -0700, Jakub Kicinski wrote:
> On Tue, 15 Sep 2020 13:25:17 -0700 saeed@kernel.org wrote:
> > From: Saeed Mahameed <saeedm@nvidia.com>
> > 
> > Hi Dave & Jakub,
> > 
> > This series adds some misc updates to mlx5 driver.
> > 
> > For more information please see tag log below.
> > 
> > Please pull and let me know if there is any problem.
> 
> I don't really know what the metadata stuff is for but nothing looks
> alarming so:

In simple words: the NIC steering pipeline knows to look into the
packet fields in addition to that it can also provide and match on
"metadata" such as, origin function, dest function/port if already
determined, and some other well known hw registers..

> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> That said some of the patches look like they should rather go to net.
> e.g. 4, 6, 11.. why not?

nothing critical really.

