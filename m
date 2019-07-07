Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E55D61763
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 22:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGGUGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 16:06:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfGGUGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 16:06:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE1111527D7ED;
        Sun,  7 Jul 2019 13:06:05 -0700 (PDT)
Date:   Sun, 07 Jul 2019 13:06:05 -0700 (PDT)
Message-Id: <20190707.130605.1362547824827296743.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: sync few chip names with vendor driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <491cc371-bdaa-a41e-52eb-10ebb3aa4539@gmail.com>
References: <491cc371-bdaa-a41e-52eb-10ebb3aa4539@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 13:06:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 7 Jul 2019 13:59:54 +0200

> This patch syncs the name of few chip versions with the latest vendor
> driver version.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
