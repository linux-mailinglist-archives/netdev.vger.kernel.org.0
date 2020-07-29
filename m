Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40775231694
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgG2AD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730247AbgG2ADz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:03:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6216C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:03:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8455A128D3041;
        Tue, 28 Jul 2020 16:47:10 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:03:55 -0700 (PDT)
Message-Id: <20200728.170355.518667224424553274.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] openvswitch: fix drop over mtu packet after defrag
 in act_ct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595300992-18381-1-git-send-email-wenxu@ucloud.cn>
References: <1595300992-18381-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:47:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Tue, 21 Jul 2020 11:09:52 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> When openvswitch conntrack offload with act_ct action. Fragment packets
> defrag in the ingress tc act_ct action and miss the next chain. Then the
> packet pass to the openvswitch datapath without the mru. The defrag over
> mtu packet will be dropped in output of openvswitch for over mtu.
> 
> "kernel: net2: dropped over-mtu packet: 1508 > 1500"
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

After an entire week, nobody has reviewed this patch.

Therefore I am dropping it from my patchwork queue.
