Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E5C133530
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgAGVrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:47:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAGVrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:47:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D1F515A174D7;
        Tue,  7 Jan 2020 13:47:50 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:47:49 -0800 (PST)
Message-Id: <20200107.134749.796683665031595971.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] enetc: Fix inconsistent IS_ERR and PTR_ERR
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107141454.44420-1-yuehaibing@huawei.com>
References: <20200107141454.44420-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:47:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 7 Jan 2020 22:14:54 +0800

> The proper pointer to be passed as argument is hw
> Detected using Coccinelle.
> 
> Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
