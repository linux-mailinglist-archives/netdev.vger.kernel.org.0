Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C66245E47
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHQHpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgHQHpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 03:45:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9A8206C0;
        Mon, 17 Aug 2020 07:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597650353;
        bh=u5DYDu5q1V/sl3V5to8RjQAexxYgKPR8MJVvtaRA080=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iBQwHOpsVq/5etZaHUGoxJ/tBCJmGAYwOvgMkLHM5nktGY0Dy0rxoX92hUJYR2HVo
         IgqonURz23jhcTEgMqOHTfyB97ZQ0jArZmRkqfpzNExUNSwmlWleQhAj1qAaWZTbA4
         qRs//UBA1GoBtexGi80Dk+apzm6iOpTYYin+VX8c=
Date:   Mon, 17 Aug 2020 10:45:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v1 2/2] rdma: use print_type() rather than
 print_color_type(xx, COLOR_NONE)
Message-ID: <20200817074550.GJ7555@unreal>
References: <20200816230256.13839-1-stephen@networkplumber.org>
 <20200816230256.13839-2-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816230256.13839-2-stephen@networkplumber.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 04:02:56PM -0700, Stephen Hemminger wrote:
> There is helper function that already has no color mode.
> Use it so color is only used when needed
>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  rdma/dev.c      | 14 +++++++-------
>  rdma/link.c     | 24 ++++++++++++------------
>  rdma/res-cmid.c | 10 +++++-----
>  rdma/res-cq.c   |  2 +-
>  rdma/res-qp.c   | 10 +++++-----
>  rdma/res.c      | 22 +++++++++++-----------
>  rdma/stat.c     | 12 ++++++------
>  rdma/sys.c      |  2 +-
>  rdma/utils.c    | 18 +++++++++---------
>  9 files changed, 57 insertions(+), 57 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
