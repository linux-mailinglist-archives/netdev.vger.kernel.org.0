Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A41E8C6E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgE3AFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3AFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:05:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E71C03E969;
        Fri, 29 May 2020 17:05:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 587CA12873741;
        Fri, 29 May 2020 17:05:01 -0700 (PDT)
Date:   Fri, 29 May 2020 17:05:00 -0700 (PDT)
Message-Id: <20200529.170500.2188388468757794688.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     gustavo@embeddedor.com, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        sameo@linux.intel.com, christophe.ricard@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca: add missed kfree_skb() in an error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528102037.911766-1-hslester96@gmail.com>
References: <20200528102037.911766-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:05:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 28 May 2020 18:20:37 +0800

> st21nfca_tm_send_atr_res() misses to call kfree_skb() in an error path.
> Add the missed function call to fix it.
> 
> Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied and queued up for -stable, thank you.
