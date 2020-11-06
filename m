Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524A32A9D8B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgKFTIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgKFTIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 14:08:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C3B9208C7;
        Fri,  6 Nov 2020 19:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604689732;
        bh=7sSY9kAdbqrmi1M8SMkcEMDihClhK4d0ljNbvb7lMOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2gtZex0DMFjmhwz1mXhIn4s5elNT/h70ZsMUcM8olSeLoyMIIPtvJIHqnik00HyK
         dDqhwCFTtg5xPRQREKS5W9IGxPPRzATSzKzMOTGYrGRPZ1HOvnQxdIY1hvlZrtIxZK
         inm5aVocGf9SxRMAykTWjvdgNSkfxt/l+XcB4VNk=
Date:   Fri, 6 Nov 2020 11:08:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 03/18] nexthop: Prepare new notification info
Message-ID: <20201106110851.1467a90f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104133040.1125369-4-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
        <20201104133040.1125369-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 15:30:25 +0200 Ido Schimmel wrote:
> +	if (info->is_grp)
> +		return nh_notifier_grp_info_init(info, nh);
> +	else
> +		return nh_notifier_single_info_init(info, nh);

nit: please try to avoid unnecessary else branches, it obviously
     doesn't matter but people send patches to refactor this :(
