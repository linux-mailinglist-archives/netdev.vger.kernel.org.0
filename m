Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C722127368E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgIUXSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgIUXSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 19:18:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10125235FD;
        Mon, 21 Sep 2020 23:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600730303;
        bh=2r7uGUXlFNhIM8Qb6RlMFoiwvqjLWUOxVTCvRFt0hYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ItBZTujcx5BAzFf0kFJ0T3nC+ClTnoTxwZDgXcZOFP7PcDvfRmOJ6pFxj5JuGE6jI
         kg/OnctdQVB6J3Jj6j5XFHL75qgEbcy8U9X2Vqiu1ILxu50rOA5w8vpWUSttQHJHzZ
         BUw/W2XuJBs+TbpBYZ24cj0xuJJvfXpKY87x4tMI=
Date:   Mon, 21 Sep 2020 16:18:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [net-next v2 PATCH 1/2] octeontx2-af: Introduce tracepoints for
 mailbox
Message-ID: <20200921161821.60c16a30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600707762-24422-2-git-send-email-sundeep.lkml@gmail.com>
References: <1600707762-24422-1-git-send-email-sundeep.lkml@gmail.com>
        <1600707762-24422-2-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 22:32:41 +0530 sundeep.lkml@gmail.com wrote:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
> new file mode 100644
> index 0000000..f0b3f17
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Marvell OcteonTx2 RVU Admin Function driver tracepoints
> + *
> + * Copyright (C) 2020 Marvell International Ltd.
> + */
> +
> +#define CREATE_TRACE_POINTS
> +#include "rvu_trace.h"
> +
> +EXPORT_TRACEPOINT_SYMBOL(otx2_msg_alloc);
> +EXPORT_TRACEPOINT_SYMBOL(otx2_msg_send);
> +EXPORT_TRACEPOINT_SYMBOL(otx2_msg_check);

I don't think you need to export send and check.

They are only used in the mbox module where they are defined.

Otherwise looks acceptable to me.

Please make sure you CC everyone who gave you feedback.
