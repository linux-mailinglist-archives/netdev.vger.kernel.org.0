Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D1D77C02
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfG0VXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:23:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfG0VXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:23:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 08CA21534E467;
        Sat, 27 Jul 2019 14:23:30 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:23:29 -0700 (PDT)
Message-Id: <20190727.142329.1612622452430349185.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: align setting PME with vendor driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dfc84691-5643-63be-6338-55fe56df18b9@gmail.com>
References: <dfc84691-5643-63be-6338-55fe56df18b9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:23:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 26 Jul 2019 20:56:20 +0200

> Align setting PME with the vendor driver. PMEnable is writable on
> RTL8169 only, on later chip versions it's read-only. PME_SIGNAL is
> used on chip versions from RTL8168evl with the exception of the
> RTL8168f family.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
