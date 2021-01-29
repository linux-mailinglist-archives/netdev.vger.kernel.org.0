Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDFC308EA1
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhA2Upw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232344AbhA2Upk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:45:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 094E964DE3;
        Fri, 29 Jan 2021 20:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611953100;
        bh=ZncorxXHn28fL7d1hBAx9orGx4QJNqYWq409xwhjsj8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u0SkqGoRpSe7SW5E2uPOB1/0xgCx7+M6gWDTzC1LlEQAlK5CFuHhfJp9oYzuuly7m
         qSvd9I8IEP8ARqJgiqCAsDiQS2mCKoDf0mjvEGFqFYaHzz5ak563NkPCBSoHWmrRqC
         2ZUih4mMZ5TPYI78n5R70747blyxwGxE1BitKo2FB1kkWQfclDiCN5CKtbg7NNnxAs
         RxE/8XavJDK0H3PpQwb9qXxvPyqJODeGNDHNxeDMcMKS+VB1O0P5LohamnfqC85T/W
         W0yi2vs36Lge46aKSW15DW6VEfIMS61xs/0+w+V79tSmd27i0DxXMyTpub+w0XAOHy
         6vgmaZ03xylzQ==
Message-ID: <c3eab4cb5c401a0273bf3b391d1b72dd46ee9921.camel@kernel.org>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Chris Mi <cmi@nvidia.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, kernel test robot <lkp@intel.com>
Date:   Fri, 29 Jan 2021 12:44:59 -0800
In-Reply-To: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210128014543.521151-1-cmi@nvidia.com>
         <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
         <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
         <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-29 at 12:30 -0800, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > Instead of discussing it several days, maybe it's better to review 
> > current patch, so that we can move forward :)
> 
> It took you 4 revisions to post a patch which builds cleanly and now
> you want to hasten the review? My favorite kind of submission.
> 
> The mlxsw core + spectrum drivers are 65 times the size of psample 
> on my system. Why is the dependency a problem?
> 
> What's going to make sure the module gets loaded when it's needed?

The issue is with distros who ship modules independently.. having a
hard dependency will make it impossible for basic mlx5_core.ko users to
load the driver when psample is not installed/loaded.

I prefer to have 0 dependency on external modules in a HW driver.

Thanks,
Saeed.

