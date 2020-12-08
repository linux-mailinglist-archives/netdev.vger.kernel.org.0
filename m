Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F482D3709
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgLHXlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLHXlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:41:07 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB156C06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 15:40:27 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3BCC24D248DB2;
        Tue,  8 Dec 2020 15:40:27 -0800 (PST)
Date:   Tue, 08 Dec 2020 15:40:23 -0800 (PST)
Message-Id: <20201208.154023.1120823090390239948.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next V3 00/15] mlx5 updates 2020-12-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 15:40:27 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Tue,  8 Dec 2020 11:35:40 -0800

> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Jakub,
> 
> v1->v2: Removed merge commit of mlx5-next.
> 
> v2->v3: 
>   - Add accuracy improvement measurements.
>   - Apply the accurate stamping only on PTP port and not all UDP.
> 
> This series adds port tx timestamping support and some misc updates.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks.
