Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF9D74195
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbfGXWlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:41:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfGXWlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:41:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 333491543C8B6;
        Wed, 24 Jul 2019 15:41:09 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:41:08 -0700 (PDT)
Message-Id: <20190724.154108.1903253308001256446.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] r8169: improve rtl_set_rx_mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2f0e6d3c-aa44-3334-aab0-f158f46e4aa9@gmail.com>
References: <2f0e6d3c-aa44-3334-aab0-f158f46e4aa9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:41:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 24 Jul 2019 23:34:45 +0200

> This patch improves and simplifies rtl_set_rx_mode a little.
> No functional change intended.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2:
> - change variable declarations to reverse xmas tree

Applied.
