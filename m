Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D31F271C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfKGFZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:25:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfKGFZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:25:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CA6515110092;
        Wed,  6 Nov 2019 21:25:49 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:25:48 -0800 (PST)
Message-Id: <20191106.212548.688585218197778448.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     ee07b291@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v2] net: openvswitch: select vport upcall
 portid directly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573058068-7073-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1573058068-7073-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:25:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Thu,  7 Nov 2019 00:34:28 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The commit 69c51582ff786 ("dpif-netlink: don't allocate per
> thread netlink sockets"), in Open vSwitch ovs-vswitchd, has
> changed the number of allocated sockets to just one per port
> by moving the socket array from a per handler structure to
> a per datapath one. In the kernel datapath, a vport will have
> only one socket in most case, if so select it directly in
> fast-path.
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v2: drectly -> directly in the commit title

Applied.
