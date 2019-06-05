Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6563554D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfFECfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:35:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFECfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:35:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7AC121504566D;
        Tue,  4 Jun 2019 19:35:54 -0700 (PDT)
Date:   Tue, 04 Jun 2019 19:35:53 -0700 (PDT)
Message-Id: <20190604.193553.2005995029161038338.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: factor out firmware handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
References: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 19:35:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 4 Jun 2019 07:44:53 +0200

> Let's factor out firmware handling into a separate source code file.
> This simplifies reading the code and makes clearer what the interface
> between driver and firmware handling is.

This doesn't apply cleanly to net-next, specifically the hunks that move code
out of r8169_main.c
