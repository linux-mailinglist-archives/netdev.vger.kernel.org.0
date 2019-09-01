Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F08BCA4B2C
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 20:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfIASh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 14:37:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfIASh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 14:37:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8542115166526;
        Sun,  1 Sep 2019 11:37:57 -0700 (PDT)
Date:   Sun, 01 Sep 2019 11:37:54 -0700 (PDT)
Message-Id: <20190901.113754.448669965532031361.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: don't set bit RxVlan on RTL8125
From:   David Miller <davem@davemloft.net>
In-Reply-To: <84b91849-0ea6-5f76-150e-bee20a2a4d5c@gmail.com>
References: <84b91849-0ea6-5f76-150e-bee20a2a4d5c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Sep 2019 11:37:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 1 Sep 2019 10:42:44 +0200

> RTL8125 uses a different register for VLAN offloading config,
> therefore don't set bit RxVlan.
> 
> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
