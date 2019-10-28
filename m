Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1E9E7CC9
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfJ1XTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:19:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfJ1XTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:19:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32E8B14BE91CC;
        Mon, 28 Oct 2019 16:19:41 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:19:40 -0700 (PDT)
Message-Id: <20191028.161940.450461528795779212.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: use helper rtl_hw_aspm_clkreq_enable
 also in rtl_hw_start_8168g_2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d561a7a9-e50f-6be5-b574-38833e29334d@gmail.com>
References: <d561a7a9-e50f-6be5-b574-38833e29334d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:19:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 25 Oct 2019 00:30:38 +0200

> One place in the driver was left where the open-coded functionality
> hasn't been replaced with helper rtl_hw_aspm_clkreq_enable yet.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
