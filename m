Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC5B12A663
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 07:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLYG1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 01:27:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLYG1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 01:27:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26D23154E7064;
        Tue, 24 Dec 2019 22:27:07 -0800 (PST)
Date:   Tue, 24 Dec 2019 22:27:06 -0800 (PST)
Message-Id: <20191224.222706.288819677291253638.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: factor out
 rtl8168h_2_get_adc_bias_ioffset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eef6a148-da23-7561-69bf-0d10aea04b60@gmail.com>
References: <eef6a148-da23-7561-69bf-0d10aea04b60@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 22:27:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 21 Dec 2019 14:03:38 +0100

> Simplify and factor out this magic from rtl8168h_2_hw_phy_config()
> and name it based on the vendor driver.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
