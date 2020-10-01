Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293AD280948
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387402AbgJAVPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgJAVPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:15:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE72A206A5;
        Thu,  1 Oct 2020 21:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601586945;
        bh=zx8F/VOM0tUBDM9N9QcngV1RTlBNa1szmVrcEdWv5SY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LL5/e8TAQqGM2I8qJnIfh/eLc8pPbL2jgJ5VT4DsO4LHKbuxDO+qUZo0ccPr7e5sL
         JvhiSijf+QegSker7+aVU/7QoBMzD2Dkooo+XaY6ieG329a9Grg+YbpV179nzg8JOQ
         ahgGHCycOziH4ho+6o8IbesUiYUrPoBCW/bj5PXw=
Date:   Thu, 1 Oct 2020 14:15:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
Message-ID: <20201001141543.24125b7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601560759-11030-4-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 16:59:06 +0300 Moshe Shemesh wrote:
> Add reload limit to demand restrictions on reload actions.
> Reload limits supported:
> no_reset: No reset allowed, no down time allowed, no link flap and no
>           configuration is lost.
> 
> By default reload limit is unspecified and so no constrains on reload
> actions are required.
> 
> Some combinations of action and limit are invalid. For example, driver
> can not reinitialize its entities without any downtime.
> 
> The no_reset reload limit will have usecase in this patchset to
> implement restricted fw_activate on mlx5.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Other than the nit:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
