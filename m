Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC023115E60
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfLGUBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 15:01:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfLGUBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 15:01:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C16C8153C7B25;
        Sat,  7 Dec 2019 12:01:31 -0800 (PST)
Date:   Sat, 07 Dec 2019 12:01:31 -0800 (PST)
Message-Id: <20191207.120131.1111830958409064329.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix rtl_hw_jumbo_disable for RTL8168evl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8aa55fa1-5ba6-2f65-e651-463fe3bed303@gmail.com>
References: <8aa55fa1-5ba6-2f65-e651-463fe3bed303@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 12:01:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 6 Dec 2019 22:55:00 +0100

> Fixes: c07fd3caadc3 ("r8169: fix jumbo configuration for RTL8168evl")

[davem@localhost net]$ git describe c07fd3caadc3
fatal: Not a valid object name c07fd3caadc3
[davem@localhost net]$
