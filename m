Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF91B529B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgDWCiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgDWCiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:38:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174A7C03C1AB;
        Wed, 22 Apr 2020 19:38:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE555127AD645;
        Wed, 22 Apr 2020 19:38:04 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:38:03 -0700 (PDT)
Message-Id: <20200422.193803.75918530614650159.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: caif: use true,false for bool variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422071636.48356-1-yanaijie@huawei.com>
References: <20200422071636.48356-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:38:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Wed, 22 Apr 2020 15:16:36 +0800

> Fix the following coccicheck warning:
> 
> net/caif/caif_dev.c:410:2-13: WARNING: Assignment of 0/1 to bool
> variable
> net/caif/caif_dev.c:445:2-13: WARNING: Assignment of 0/1 to bool
> variable
> net/caif/caif_dev.c:145:1-12: WARNING: Assignment of 0/1 to bool
> variable
> net/caif/caif_dev.c:223:1-12: WARNING: Assignment of 0/1 to bool
> variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied to net-next, thanks.
