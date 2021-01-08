Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1EF2EEB79
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAHCur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbhAHCur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A63E23603;
        Fri,  8 Jan 2021 02:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610074206;
        bh=emKJ/rhIAjxby6qq9Yqg9lT4VjkphyM5nDrHHnyhMWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dn7oNtkShbVkDXazz2I/2qRNjpYCfFZmId4S96qCvE16rxQPrvl74P8npR1Gpyka5
         ZUm4NpckPYUyJXOt3AcSlF5lNi7TYlHBecJJe6kq3sjdC4TOTcReo7QLec4si0/6F1
         wTPqFXHlb6atdfHKitJK48Iqvpf70Lq4YqVSEk229lsXOnC5SdOiT6hpDkZkPVi+Rf
         HqNesx/4Cof70AbFv/6XQffJN8ovUOtcVdTYZfqNu7SInEjYLzLJ9ZNYDr70nijetc
         RiyZRaqUm1RHcFWtZpc9gpYJHjunM7U8AOvfj1v9f/A9sYkqMjORvr1hvx5Bx3TotH
         0jgdj8YSJCCJg==
Date:   Thu, 7 Jan 2021 18:50:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>, petrm@nvidia.com,
        dsahern@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roopa@nvidia.com,
        nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 0/4] nexthop: Various fixes
Message-ID: <20210107185005.17fc1486@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107144824.1135691-1-idosch@idosch.org>
References: <20210107144824.1135691-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 16:48:20 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This series contains various fixes for the nexthop code. The bugs were
> uncovered during the development of resilient nexthop groups.
> 
> Patches #1-#2 fix the error path of nexthop_create_group(). I was not
> able to trigger these bugs with current code, but it is possible with
> the upcoming resilient nexthop groups code which adds a user
> controllable memory allocation further in the function.
> 
> Patch #3 fixes wrong validation of netlink attributes.
> 
> Patch #4 fixes wrong invocation of mausezahn in a selftest.

Applied, thanks!
