Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E700F26973C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINU7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINU73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:59:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBBFC06174A;
        Mon, 14 Sep 2020 13:59:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A4AC127BBD58;
        Mon, 14 Sep 2020 13:42:41 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:59:27 -0700 (PDT)
Message-Id: <20200914.135927.1832434043027407452.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com,
        zengweiliang.zengweiliang@huawei.com
Subject: Re: [PATCH net-next] hinic: add vxlan segmentation and cs offload
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914134823.8243-1-luobin9@huawei.com>
References: <20200914134823.8243-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:42:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Mon, 14 Sep 2020 21:48:23 +0800

> Add NETIF_F_GSO_UDP_TUNNEL and NETIF_F_GSO_UDP_TUNNEL_CSUM features
> to support vxlan segmentation and checksum offload. Ipip and ipv6
> tunnel packets are regarded as non-tunnel pkt for hw and as for other
> type of tunnel pkts, checksum offload is disabled.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied, thank you.
