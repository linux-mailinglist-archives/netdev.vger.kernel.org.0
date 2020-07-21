Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D1B2274A2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgGUBhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:37:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCB1C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:37:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FA7E11FFCC4A;
        Mon, 20 Jul 2020 18:20:28 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:37:12 -0700 (PDT)
Message-Id: <20200720.183712.2182734561863160683.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] net/sched: act_ct: fix restore the qdisc_skb_cb
 after defrag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595161837-25502-1-git-send-email-wenxu@ucloud.cn>
References: <1595161837-25502-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:20:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Sun, 19 Jul 2020 20:30:37 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> The fragment packets do defrag in tcf_ct_handle_fragments
> will clear the skb->cb which make the qdisc_skb_cb clear
> too. So the qdsic_skb_cb should be store before defrag and
> restore after that.
> It also update the pkt_len after all the
> fragments finish the defrag to one packet and make the
> following actions counter correct.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Applied and queued up for -stable, thanks.
