Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5737429CD0B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgJ1Biz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833084AbgJ1AMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 20:12:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82DB022281;
        Wed, 28 Oct 2020 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603843925;
        bh=DLGrk2eXb1L/cG31sLgldGEV4hE9DJM6OCdHn1VKf40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nrNoT/WpSjv5BMc57eOPIN4rVrNNLjVnxFSStqpozy0SxiWBSA0nImiMMQ5CSpOiz
         8SO/Sq0+xOzrmZlhQy3YcVvjcbBmrW7iRShuomsVqCpI3KJSAmOw7cvbdzfhf1PkKe
         kvHbPNh0L3G2nrQQuIbh8czZVsUjDph3zu4L6LoU=
Date:   Tue, 27 Oct 2020 17:12:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 net] devlink: Fix some error codes
Message-ID: <20201027171204.6235e1e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026080059.GA1628785@mwanda>
References: <20201026080059.GA1628785@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:00:59 +0300 Dan Carpenter wrote:
> devlink_nl_region_notify_build() where it leads to a NULL dereference in
> the caller.
> 
> Fixes: 544e7c33ec2f ("net: devlink: Add support for port regions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied both, thanks Dan!
