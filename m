Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9735C280946
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgJAVO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgJAVO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:14:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C1B8206A5;
        Thu,  1 Oct 2020 21:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601586866;
        bh=vu6SXGyCcpXD4ROfypEPOatXab860Q3TG4HTtkBT8Uw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9kRdemIE3opm8QGUo9P2ftFhenK6G1py3YmbwGvKx8vgh2lPa4N28QARiV+TYh6W
         IO0gI6DXGTMq8f2HOwFHJbSOS47XFiIYkZqlFGwad4eqSVkMY1bZZH63TkpaKuRrZW
         4Bs3pog8gjdYWTOfSNdCxIYQRCFNj714FVDVP0Rs=
Date:   Thu, 1 Oct 2020 14:14:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
Message-ID: <20201001141425.68f7eeb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> @@ -3032,6 +3064,7 @@ devlink_nl_reload_actions_performed_snd(struct devlink *devlink,
>  
>  static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  {
> +	enum devlink_reload_limit limit;
>  	struct devlink *devlink = info->user_ptr[0];
>  	enum devlink_reload_action action;
>  	unsigned long actions_performed;

reverse xmas tree
