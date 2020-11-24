Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399472C31DA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbgKXUTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbgKXUTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 15:19:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F2BC2086A;
        Tue, 24 Nov 2020 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606249175;
        bh=iyUABk+Kftit0om6BCrmfYWf1wo25QMwHwc7jF9Urhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YiW+P/KMpffCfo6pdA540NhTzywPQuPb8pYD94zzwKGD9BHCfFPod6nWdoCJF9pPD
         tvhosB8tfeBlS0oi/i66M6NUQ0Oorj119TSkasO7iM0R6eYhFfAfVU6ArQ2g+uqOy9
         xHSH/ne4kJzwCPZ4pN9iGkV9iw7Pskw2D69lf2OU=
Date:   Tue, 24 Nov 2020 12:19:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 00/10] mlxsw: Add support for blackhole
 nexthops
Message-ID: <20201124121933.568323a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 09:12:20 +0200 Ido Schimmel wrote:
> This patch set adds support for blackhole nexthops in mlxsw. These
> nexthops are exactly the same as other nexthops, but instead of
> forwarding packets to an egress router interface (RIF), they are
> programmed to silently drop them.
> 
> Patches #1-#4 are preparations.
> 
> Patch #5 adds support for blackhole nexthops and removes the check that
> prevented them from being programmed.
> 
> Patch #6 adds a selftests over mlxsw which tests that blackhole nexthops
> can be programmed and are marked as offloaded.
> 
> Patch #7 extends the existing nexthop forwarding test to also test
> blackhole functionality.
> 
> Patches #8-#10 add support for a new packet trap ('blackhole_nexthop')
> which should be triggered whenever packets are dropped by a blackhole
> nexthop. Obviously, by default, the trap action is set to 'drop' so that
> dropped packets will not be reported.

Applied, thanks!
