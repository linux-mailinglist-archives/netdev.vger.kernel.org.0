Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D36B80B08
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfHDMwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 08:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbfHDMwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 08:52:53 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E70206C1;
        Sun,  4 Aug 2019 12:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564923172;
        bh=CUiOp/mIeBCbY/ngTZBhtLw3Og7NrQM1xMiLk8WCzZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rsE8Cs+eR48j5AKhlQbv+yGh7FBBQttX0No0RCfXq9MrsfUU4vb7Tq7xMk5Odoir7
         SUaaEbaqJxjcEklT4piX/1eXsI7Kor7FCcI8iI3Pgb3vtaevBihmLacRZ0riMKMpoF
         6/2VSuqAEtPyJT/sNi12M83G2zTuLUsSlY4MVEpY=
Date:   Sun, 4 Aug 2019 15:52:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Use refcount_t for refcount
Message-ID: <20190804125249.GI4832@mtr-leonro.mtl.com>
References: <20190802172334.8305-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802172334.8305-1-hslester96@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 03, 2019 at 01:23:34AM +0800, Chuhong Yuan wrote:
> Reference counters are preferred to use refcount_t instead of
> atomic_t.
> This is because the implementation of refcount_t can prevent
> overflows and detect possible use-after-free.
>
> First convert the refcount field to refcount_t in mlx5/driver.h.
> Then convert the uses to refcount_() APIs.
>
> Changelog:
>
> v1 -> v2:
>   - Add #include in include/linux/mlx5/driver.h.

The same NAK as for version v0.

Thanks
