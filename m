Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22F0282DFC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 00:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgJDWM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 18:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJDWMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 18:12:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E6C0613CE;
        Sun,  4 Oct 2020 15:12:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D33E712782CCF;
        Sun,  4 Oct 2020 14:55:36 -0700 (PDT)
Date:   Sun, 04 Oct 2020 15:12:23 -0700 (PDT)
Message-Id: <20201004.151223.774106080631315758.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, khc@pm.waw.pl,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Improvements to the
 code of pvc_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003224105.74234-1-xie.he.0141@gmail.com>
References: <20201003224105.74234-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:55:37 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Sat,  3 Oct 2020 15:41:05 -0700

> 1. Keep the code for the normal (non-error) flow at the lowest
> indentation level. And use "goto drop" for all error handling.
> 
> 2. Replace code that pads short Ethernet frames with a "__skb_pad" call.
> 
> 3. Change "dev_kfree_skb" to "kfree_skb" in error handling code.
> "kfree_skb" is the correct function to call when dropping an skb due to
> an error. "dev_kfree_skb", which is an alias of "consume_skb", is for
> dropping skbs normally (not due to an error).
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
