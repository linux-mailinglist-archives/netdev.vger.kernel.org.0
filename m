Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDAB1442E
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfEFEyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:54:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfEFEyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:54:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C4A1912DAD8C5;
        Sun,  5 May 2019 21:54:44 -0700 (PDT)
Date:   Sun, 05 May 2019 21:54:44 -0700 (PDT)
Message-Id: <20190505.215444.464564988842346590.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: simplify rtl_writephy_batch and
 rtl_ephy_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2ffb7419-03d5-5d5a-44e6-6b070fd5c2bb@gmail.com>
References: <2ffb7419-03d5-5d5a-44e6-6b070fd5c2bb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:54:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 4 May 2019 16:57:49 +0200

> Make both functions macros to allow omitting the ARRAY_SIZE(x) argument.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
