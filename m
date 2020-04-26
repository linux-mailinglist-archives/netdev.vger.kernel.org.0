Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC751B8BB6
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgDZDnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgDZDnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:43:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26806C061A0C;
        Sat, 25 Apr 2020 20:43:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5C37159FDB7B;
        Sat, 25 Apr 2020 20:43:10 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:43:09 -0700 (PDT)
Message-Id: <20200425.204309.658937811646691667.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        leonro@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] liquidio: remove unused inline functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424131134.41928-1-yuehaibing@huawei.com>
References: <20200424131134.41928-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:43:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 24 Apr 2020 21:11:34 +0800

> commit b6334be64d6f ("net/liquidio: Delete driver version assignment")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
