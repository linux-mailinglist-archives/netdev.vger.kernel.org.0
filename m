Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041201B8BB9
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgDZDnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgDZDnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:43:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0BFC061A0C;
        Sat, 25 Apr 2020 20:43:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B29E6159FDCF8;
        Sat, 25 Apr 2020 20:43:14 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:43:14 -0700 (PDT)
Message-Id: <20200425.204314.1405945545691473873.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gustavo@embeddedor.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] qlcnic: remove unused inline function
 qlcnic_hw_write_wx_2M
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424131256.10400-1-yuehaibing@huawei.com>
References: <20200424131256.10400-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:43:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 24 Apr 2020 21:12:56 +0800

> There's no callers in-tree anymore.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
