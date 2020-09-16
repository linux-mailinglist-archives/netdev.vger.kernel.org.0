Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9C426CC32
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgIPUka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgIPRFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 13:05:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10456221F1;
        Wed, 16 Sep 2020 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600275416;
        bh=VO0hPaGQZW+C47F4+vyK69LAfjiBgcb7dAoHOIglIJw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L74JHRD7FHXmOL8Ms05r6cMI7/sF2Vf1aPY4dwRhAofy8JxC5sVNvgslRnHZKLw9G
         Hv0eWs3KDd+/A9Eb9C4UOzahl6q3eVjdlw8djG6fYm3Ah3ZiKEA/WHBGVfEicUP7T3
         SYkARIZDZOckRPu+XIJm/H+4iOafhGqwpKOr3rIU=
Date:   Wed, 16 Sep 2020 09:56:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next 00/16] mlx5 updates 2020-09-15
Message-ID: <20200916095654.558c031f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 13:25:17 -0700 saeed@kernel.org wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave & Jakub,
> 
> This series adds some misc updates to mlx5 driver.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

I don't really know what the metadata stuff is for but nothing looks
alarming so:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

That said some of the patches look like they should rather go to net.
e.g. 4, 6, 11.. why not?
