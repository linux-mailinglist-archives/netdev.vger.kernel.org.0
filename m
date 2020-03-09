Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC817D89F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgCIEjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:39:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgCIEjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:39:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9296158B682C;
        Sun,  8 Mar 2020 21:39:42 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:39:42 -0700 (PDT)
Message-Id: <20200308.213942.243791853809889906.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, subashab@codeaurora.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: rmnet: set NETIF_F_LLTX flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200308134706.18727-1-ap420073@gmail.com>
References: <20200308134706.18727-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:39:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sun,  8 Mar 2020 13:47:06 +0000

> The rmnet_vnd_setup(), which is the callback of ->ndo_start_xmit() is
> allowed to call concurrently because it uses RCU protected data.
> So, it doesn't need tx lock.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thanks.
