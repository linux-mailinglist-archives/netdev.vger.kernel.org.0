Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFAD2A9E0C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgKFTcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgKFTcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 14:32:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F2C20867;
        Fri,  6 Nov 2020 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604691121;
        bh=GwSLGTvgewiAm9sG+9JDCp+TyLaZNpwOsa523l5SuCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2qngH4kJTekV7b9A/ZG+R74vyBFWzEcYecFIwOfdDd1Lhbftm4SQpfl9X+aYCZFxo
         6x/VZMnCqYwZ95CGvNRpXlu9O7Qw3MJs4UBW+VNCyEp12Nwfsg253iDqioEEyCfSSH
         eeQ/wtgu0TV5h7WRWpSYSP/UfTn5z2gI4Z3aSHtU=
Date:   Fri, 6 Nov 2020 11:31:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 00/18] nexthop: Add support for nexthop objects
 offload
Message-ID: <20201106113159.6c324275@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 15:30:22 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set adds support for nexthop objects offload with a dummy
> implementation over netdevsim. mlxsw support will be added later.
> 
> The general idea is very similar to route offload in that notifications
> are sent whenever nexthop objects are changed. A listener can veto the
> change and the error will be communicated to user space with extack.
> 
> To keep listeners as simple as possible, they not only receive
> notifications for the nexthop object that is changed, but also for all
> the other objects affected by this change. For example, when a single
> nexthop is replaced, a replace notification is sent for the single
> nexthop, but also for all the nexthop groups this nexthop is member in.
> This relieves listeners from the need to track such dependencies.
> 
> To simplify things further for listeners, the notification info does not
> contain the raw nexthop data structures (e.g., 'struct nexthop'), but
> less complex data structures into which the raw data structures are
> parsed into.

Applied, thank you!

BTW no need to follow up on my else-after-return comment, 
just something to keep in mind.
