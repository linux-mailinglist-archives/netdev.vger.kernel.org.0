Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F594291E14
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgJRTt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388099AbgJRTty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:49:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCFBF22268;
        Sun, 18 Oct 2020 19:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603050594;
        bh=bLw07dJRWdHmGQ8475sWiGWl/5BQNMQpuCr3U8FR+cw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQbOdjUpM7RuzgdU15a6NKRkIxinBuJVJ9LbXRAxr25Qpo69J0/XUEAxxOatOWEJ+
         RjL7E67IUjsC6fty9JI/J3fMfsSN7LPtVvTmtUesOSXSrrrWQkbztuW7C6crU58k8E
         kztJMgrB1seGy1hTIlpZYlsg546qLVWmt7c+zqn4=
Date:   Sun, 18 Oct 2020 12:49:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, liuhangbin@gmail.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] selftests: forwarding: Add missing 'rp_filter'
 configuration
Message-ID: <20201018124952.25b3e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015084525.135121-1-idosch@idosch.org>
References: <20201015084525.135121-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 11:45:25 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When 'rp_filter' is configured in strict mode (1) the tests fail because
> packets received from the macvlan netdevs would not be forwarded through
> them on the reverse path.
> 
> Fix this by disabling the 'rp_filter', meaning no source validation is
> performed.
> 
> Fixes: 1538812e0880 ("selftests: forwarding: Add a test for VXLAN asymmetric routing")
> Fixes: 438a4f5665b2 ("selftests: forwarding: Add a test for VXLAN symmetric routing")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Tested-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thanks!
