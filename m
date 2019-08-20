Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DF195307
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfHTBNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:13:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfHTBNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:13:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26CC914B74FD2;
        Mon, 19 Aug 2019 18:13:43 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:13:42 -0700 (PDT)
Message-Id: <20190819.181342.1487533301540666622.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: fix accessing skb after
 napi_gro_receive
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-302-Taiwan-albertk@realtek.com>
References: <1394712342-15778-299-albertk@realtek.com>
        <1394712342-15778-302-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:13:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 19 Aug 2019 11:15:19 +0800

> Fix accessing skb after napi_gro_receive which is caused by
> commit 47922fcde536 ("r8152: support skb_add_rx_frag").
> 
> Fixes: 47922fcde536 ("r8152: support skb_add_rx_frag")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
