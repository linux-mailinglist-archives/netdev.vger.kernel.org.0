Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09F1C6048
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgEESlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgEESlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:41:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E8EC061A0F;
        Tue,  5 May 2020 11:41:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE305127F93E1;
        Tue,  5 May 2020 11:41:02 -0700 (PDT)
Date:   Tue, 05 May 2020 11:41:02 -0700 (PDT)
Message-Id: <20200505.114102.2092079806516311665.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     mark.einon@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: agere: use true,false for bool variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505074556.22331-1-yanaijie@huawei.com>
References: <20200505074556.22331-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:41:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Tue, 5 May 2020 15:45:56 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/agere/et131x.c:717:3-22: WARNING: Assignment of
> 0/1 to bool variable
> drivers/net/ethernet/agere/et131x.c:721:1-20: WARNING: Assignment of
> 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
