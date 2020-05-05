Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3391C6039
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgEESj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEESjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:39:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DB1C061A0F;
        Tue,  5 May 2020 11:39:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AEF3127F71E4;
        Tue,  5 May 2020 11:39:55 -0700 (PDT)
Date:   Tue, 05 May 2020 11:39:54 -0700 (PDT)
Message-Id: <20200505.113954.551352322623959874.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] qlcnic: use true,false for bool variable in
 qlcnic_sriov_common.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505074349.21578-1-yanaijie@huawei.com>
References: <20200505074349.21578-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:39:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Tue, 5 May 2020 15:43:49 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c:1585:3-25:
> WARNING: Assignment of 0/1 to bool variable
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c:1588:3-25:
> WARNING: Assignment of 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
