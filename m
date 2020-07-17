Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A2224484
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgGQTrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgGQTrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:47:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A68C0619D2;
        Fri, 17 Jul 2020 12:47:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E01CE11E45928;
        Fri, 17 Jul 2020 12:47:51 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:47:51 -0700 (PDT)
Message-Id: <20200717.124751.1661646022999131740.davem@davemloft.net>
To:     miaoqinglang@huawei.com
Cc:     gregkh@linuxfoundation.org, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716085859.11635-1-miaoqinglang@huawei.com>
References: <20200716085859.11635-1-miaoqinglang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:47:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Thu, 16 Jul 2020 16:58:59 +0800

> From: Yongqiang Liu <liuyongqiang13@huawei.com>
> 
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>

This also does not apply cleanly to the net-next tree.
