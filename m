Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8709619047F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgCXEa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:30:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:30:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0169A1573FF1C;
        Mon, 23 Mar 2020 21:30:28 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:30:27 -0700 (PDT)
Message-Id: <20200323.213027.1472886387200410951.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add new helper rtl8168g_enable_gphy_10m
From:   David Miller <davem@davemloft.net>
In-Reply-To: <743a1fd7-e1b2-d548-1c22-7c1a2e3b268e@gmail.com>
References: <743a1fd7-e1b2-d548-1c22-7c1a2e3b268e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:30:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 21 Mar 2020 19:08:09 +0100

> Factor out setting GPHY 10M to new helper rtl8168g_enable_gphy_10m.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
