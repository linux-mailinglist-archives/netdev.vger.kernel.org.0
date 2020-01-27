Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C92D14A1D2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgA0KQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:16:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgA0KQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:16:10 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FCE815128954;
        Mon, 27 Jan 2020 02:16:09 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:16:08 +0100 (CET)
Message-Id: <20200127.111608.325265803073380152.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: don't set min_mtu/max_mtu if not needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d3d3dbf8-03f1-f964-a937-18f7f48452c8@gmail.com>
References: <d3d3dbf8-03f1-f964-a937-18f7f48452c8@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:16:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 26 Jan 2020 10:40:44 +0100

> Defaults for min_mtu and max_mtu are set by ether_setup(), which is
> called from devm_alloc_etherdev(). Let rtl_jumbo_max() only return
> a positive value if actually jumbo packets are supported. This also
> allows to remove constant Jumbo_1K which is a little misleading anyway.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thank you.
