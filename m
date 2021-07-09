Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0AA3C20A1
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhGIITQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhGIITP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 04:19:15 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63FDC0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 01:16:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6755C4D310810;
        Fri,  9 Jul 2021 01:16:29 -0700 (PDT)
Date:   Fri, 09 Jul 2021 01:16:25 -0700 (PDT)
Message-Id: <20210709.011625.1604833283174788576.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, qitao.xu@bytedance.com,
        cong.wang@bytedance.com
Subject: Re: [Patch net-next] net: use %px to print skb address in
 trace_netif_receive_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
References: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 09 Jul 2021 01:16:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu,  8 Jul 2021 22:17:08 -0700

> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> The print format of skb adress in tracepoint class net_dev_template
> is changed to %px from %p, because we want to use skb address
> as a quick way to identify a packet.
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>

Aren't we not supposed to leak kernel addresses to userspace?
