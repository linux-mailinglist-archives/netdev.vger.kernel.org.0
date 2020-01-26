Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07960149CFD
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAZVY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAZVY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 16:24:27 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D220206F0;
        Sun, 26 Jan 2020 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580073867;
        bh=FQHFnuDCGGupzOwX7cb7VwWPs2vMMrQU80tsjo4Rk3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ELRFleaDP3+lulv8lONqRcX+Wq/Oh7maKpVnkisBJh+Jx9+hUczF32K5rxaublStJ
         2qU4ZQYdRVq3BM4phq0Sb6Ia31+849ZSPS7df32vH9zGQk+HkaPiXxA5+yDXg7B5LK
         75Jsj7704oUCr5afPUAX6HrH07kvSYyKf1DGl99I=
Date:   Sun, 26 Jan 2020 23:24:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126212424.GD3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 01:17:52PM -0800, Shannon Nelson wrote:
> On 1/26/20 1:08 PM, Leon Romanovsky wrote:
> > The long-standing policy in kernel that we don't really care about
> > out-of-tree code.
>
> That doesn't mean we need to be aggressively against out-of-tree code.  One
> of the positive points about Linux and loadable modules has always been the
> flexibility that allows and encourages innovation, and helps enable more
> work and testing before a driver can become a fully-fledged part of the
> kernel.  This move actively discourages part of that flexibility and I think
> it is breaking part of the usefulness of modules.

You are mixing definitions, nothing stops those people to innovate and
develop their code inside kernel and as standalone modules too.

It just stops them to put useless driver version string inside ethtool.
If they feel that their life can't be without something from 90s, they
have venerable MODULE_VERSION() macro to print anything they want.

Thanks

>
> sln
>
