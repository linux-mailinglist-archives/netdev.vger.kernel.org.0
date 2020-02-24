Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACAA169BB8
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 02:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBXBSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 20:18:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbgBXBSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 20:18:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFA061340EBEE;
        Sun, 23 Feb 2020 17:18:33 -0800 (PST)
Date:   Sun, 23 Feb 2020 17:18:27 -0800 (PST)
Message-Id: <20200223.171827.2141429164453619391.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve rtl8169_start_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ee5d5f3a-aaf8-a33d-da45-05843e990140@gmail.com>
References: <ee5d5f3a-aaf8-a33d-da45-05843e990140@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 17:18:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 22 Feb 2020 17:02:51 +0100

> Only call rtl8169_xmit_frags() if the skb is actually fragmented.
> This avoid a small overhead for non-fragmented skb's, and it allows
> to simplify rtl8169_xmit_frags() a little.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
