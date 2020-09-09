Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99C2630A2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIIPfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbgIIPfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:35:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12A06218AC;
        Wed,  9 Sep 2020 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599665684;
        bh=WQLDyZhm9XhP4KbvcVOVStT0zHi1Uxoye3gvg32iGRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQHy8yRMZ5GHABUO52gvBrXAZx3+SIozwH+2AmvbMN7i5XYHjq51nNDCJ9g3XUs/m
         hKXFhRlUFCAIQolyXz4mBC0jGT9GeaLTmjLml4rPGf4fS3wGOwwFkMiKRUNHUNaQDF
         3OQbY2xx7MHKQNVmw+Zi12cGxcIjLuTE5o0jH2ks=
Date:   Wed, 9 Sep 2020 08:34:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next v3 0/6] devlink show controller number
Message-ID: <20200909083442.5b820d72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909045038.63181-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200909045038.63181-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 07:50:32 +0300 Parav Pandit wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Hi Jakub, Dave,
> 
> Currently a devlink instance that supports an eswitch handles eswitch
> ports of two type of controllers.
> (1) controller discovered on same system where eswitch resides.
> This is the case where PCI PF/VF of a controller and devlink eswitch
> instance both are located on a single system.
> (2) controller located on external system.
> This is the case where a controller is plugged in one system and its
> devlink eswitch ports are located in a different system. In this case
> devlink instance of the eswitch only have access to ports of the
> controller.
> However, there is no way to describe that a eswitch devlink port
> belongs to which controller (mainly which external host controller).
> This problem is more prevalent when port attribute such as PF and VF
> numbers are overlapping between multiple controllers of same eswitch.
> Due to this, for a specific switch_id, unique phys_port_name cannot
> be constructed for such devlink ports.

Acked-by: Jakub Kicinski <kuba@kernel.org>
