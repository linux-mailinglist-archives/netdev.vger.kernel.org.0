Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA51F356223
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 05:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348435AbhDGDuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 23:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348457AbhDGDuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 23:50:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED77A61245;
        Wed,  7 Apr 2021 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617767396;
        bh=3yPZvyfKsvop+5Gmiujbfk7NPCkDAXBYVU2vefEFYQo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ipYxTt0FiNQw05eYtHLNJgNAQuT7f/N2I9+GKUFdVSHtU+z6xO39CYuDewaIvfzJ6
         gSFHN40w7kvHZOYdYu4r6WAakXKxe8KSt4xQYBTwBh/crCtZ9Ibp9JQ+/+0pgZAaJo
         qxFqh4/JFPpU0qgrzwsI9rEOOOWCA7KuD3X5eYSB/0Zy8VGKfKR1chxSI6kQb9rrDo
         WYt5kz0JdZtqsi4qPx9Z7vA+XuuQMDqexwPMD6hv8V10rZgY8VqWgH5z8mTjq1XPL1
         BNGHrRHOP9TZEq1nU0/uXAuq297UfEDZPmt2FTTqTzmJmTaH/UELMnB6F1tGF2yAnj
         bz78sIBQr5gVw==
Message-ID: <6b7d173f940ecf02ba1f8c8d636b91329be4a5c1.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: fix kfree mismatch in indir_table.c
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, vladbu@nvidia.com,
        dlinkin@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        roid@nvidia.com, dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, xiaoqian9@huawei.com
Date:   Tue, 06 Apr 2021 20:49:55 -0700
In-Reply-To: <YGqYfcCMWTW8fN7U@unreal>
References: <20210405025339.86176-1-nixiaoming@huawei.com>
         <YGqYfcCMWTW8fN7U@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-05 at 07:56 +0300, Leon Romanovsky wrote:
> On Mon, Apr 05, 2021 at 10:53:39AM +0800, Xiaoming Ni wrote:
> > Memory allocated by kvzalloc() should be freed by kvfree().
> > 
> > Fixes: 34ca65352ddf2 ("net/mlx5: E-Switch, Indirect table
> > infrastructur")
> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +++++-
> > ----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Applied to net-mlx5.

Thanks,
Saeed.

