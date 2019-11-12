Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5F3F84ED
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfKLALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:11:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLALi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:11:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDB8215400212;
        Mon, 11 Nov 2019 16:11:37 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:11:37 -0800 (PST)
Message-Id: <20191111.161137.701314195809277408.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: respect EEE user setting when
 restarting network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dbc0b252-4bbd-4f93-6cc1-1bdd64159f8f@gmail.com>
References: <dbc0b252-4bbd-4f93-6cc1-1bdd64159f8f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 16:11:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 10 Nov 2019 14:44:54 +0100

> Currently, if network is re-started, we advertise all supported EEE
> modes, thus potentially overriding a manual adjustment the user made
> e.g. via ethtool. Be friendly to the user and preserve a manual
> setting on network re-start.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
