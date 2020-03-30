Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C5B1983BE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgC3Sul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:50:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3Sul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:50:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0143D15C7052D;
        Mon, 30 Mar 2020 11:50:40 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:50:40 -0700 (PDT)
Message-Id: <20200330.115040.655866636648777318.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: factor out rtl8169_tx_map
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d9511cb2-42a7-eaec-7594-0f326f08efcd@gmail.com>
References: <d9511cb2-42a7-eaec-7594-0f326f08efcd@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:50:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 30 Mar 2020 01:53:39 +0200

> Factor out mapping the tx skb to a new function rtl8169_tx_map(). This
> allows to remove redundancies, and rtl8169_get_txd_opts1() has only
> one user left, so it can be inlined.
> As a result rtl8169_xmit_frags() is significantly simplified, and in
> rtl8169_start_xmit() the code is simplified and better readable.
> No functional change intended.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
