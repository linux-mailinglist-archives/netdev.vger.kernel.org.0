Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FC180C47
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgCJXYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:24:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCJXYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:24:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE39714D7CE94;
        Tue, 10 Mar 2020 16:24:34 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:24:34 -0700 (PDT)
Message-Id: <20200310.162434.1896838611615949338.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: let rtl8169_mark_to_asic clear rx
 descriptor field opts2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bc8a1ecc-4b94-e0b9-ba05-acf674c1b5e6@gmail.com>
References: <bc8a1ecc-4b94-e0b9-ba05-acf674c1b5e6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:24:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 10 Mar 2020 23:14:41 +0100

> Clearing opts2 belongs to preparing the descriptor for DMA engine use.
> Therefore move it into rtl8169_mark_to_asic().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
