Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DDE6246A8
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKJQM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKJQM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:12:28 -0500
X-Greylist: delayed 478 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Nov 2022 08:12:25 PST
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 828007642;
        Thu, 10 Nov 2022 08:12:25 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 9C730FFA84;
        Thu, 10 Nov 2022 16:04:22 +0000 (UTC)
Date:   Fri, 11 Nov 2022 01:04:12 +0900
From:   Max Staudt <max@enpas.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH] can: can327: fix potential skb leak when netdev is down
Message-ID: <20221111010412.6ca0ff1c.max@enpas.org>
In-Reply-To: <20221110061437.411525-1-william.xuanziyang@huawei.com>
References: <20221110061437.411525-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(CC Vincent, he may be interested)


On Thu, 10 Nov 2022 14:14:37 +0800
Ziyang Xuan <william.xuanziyang@huawei.com> wrote:

> Fix it by adding kfree_skb() in can327_feed_frame_to_netdev() when netdev
> is down. Not tested, just compiled.

Looks correct to me, so:

Reviewed-by: Max Staudt <max@enpas.org>


Thank you very much for finding and fixing this!

Max
