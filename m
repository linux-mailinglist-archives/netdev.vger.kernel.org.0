Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A38F0BDB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfKFCBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:01:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbfKFCBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:01:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE5E415024076;
        Tue,  5 Nov 2019 18:01:13 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:01:13 -0800 (PST)
Message-Id: <20191105.180113.1002103167443203723.davem@davemloft.net>
To:     yuval.shaia@oracle.com
Cc:     tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, dotanb@dev.mellanox.co.il,
        eli@mellanox.co.il, vlad@mellanox.com
Subject: Re: [PATCH v1] mlx4_core: fix wrong comment about the reason of
 subtract one from the max_cqes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191103091135.1891-1-yuval.shaia@oracle.com>
References: <20191103091135.1891-1-yuval.shaia@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:01:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Shaia <yuval.shaia@oracle.com>
Date: Sun,  3 Nov 2019 11:11:35 +0200

> From: Dotan Barak <dotanb@dev.mellanox.co.il>
> 
> The reason for the pre-allocation of one CQE is to enable resizing of
> the CQ.
> Fix comment accordingly.
> 
> Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
> Signed-off-by: Eli Cohen <eli@mellanox.co.il>
> Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.com>
> Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>

Applied.
