Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86698325F0
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFCBNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:13:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCBNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:13:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E4D3134116CD;
        Sun,  2 Jun 2019 18:13:49 -0700 (PDT)
Date:   Sun, 02 Jun 2019 18:13:48 -0700 (PDT)
Message-Id: <20190602.181348.203215510067293821.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve r8169_csum_workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5cf7212e-fccd-9d2d-3c7a-2c6f76abbc13@gmail.com>
References: <5cf7212e-fccd-9d2d-3c7a-2c6f76abbc13@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 18:13:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 31 May 2019 19:17:15 +0200

> Use helper skb_is_gso() and simplify access to tx_dropped.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
