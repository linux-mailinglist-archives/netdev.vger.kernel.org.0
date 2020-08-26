Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182FD253A53
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgHZWmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZWmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:42:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED3FC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:42:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 597D5128FDC70;
        Wed, 26 Aug 2020 15:25:23 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:42:06 -0700 (PDT)
Message-Id: <20200826.154206.664407399534642445.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: add act_ct_output support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
References: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:25:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Tue, 25 Aug 2020 14:07:43 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> The fragment packets do defrag in act_ct module. If the reassembled
> packet should send out to another net device. This over mtu big packet
> should be fragmented to send out. This patch add the act ct_output to
> archive this.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Like others, I really don't see the conntract dependency.

Please move ip6_fragment into ipv6_stub and rename this new module
more generically.

Thank you.
