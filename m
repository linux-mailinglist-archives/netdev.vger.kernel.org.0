Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC431C34F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBOU6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:58:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45970 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBOU6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:58:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1D2924D2DE594;
        Mon, 15 Feb 2021 12:57:38 -0800 (PST)
Date:   Mon, 15 Feb 2021 12:57:33 -0800 (PST)
Message-Id: <20210215.125733.311587463365048945.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     sgoutham@marvell.com, cjacob@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, kuba@kernel.org,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-pf: fix an off by one bug in
 otx2_get_fecparam()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YCqZvjAzSmJk5Ftb@mwanda>
References: <YCqZvjAzSmJk5Ftb@mwanda>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 15 Feb 2021 12:57:38 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 15 Feb 2021 18:56:46 +0300

> The "<= FEC_MAX_INDEX" comparison should be "< FEC_MAX_INDEX".
> 
> I did some cleanup in this function to hopefully make the code a bit
> clearer.  There was no blank line after the declaration block.  The
> closing curly brace on the fec[] declaration normally goes on a line
> by itself.  And I removed the FEC_MAX_INDEX define and used
> ARRAY_SIZE(fec) instead.
> 
> Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This doesn't apply to net-next.
