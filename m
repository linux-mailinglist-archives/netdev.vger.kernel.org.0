Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04433180C49
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCJXZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:25:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCJXZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:25:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31F6A14D85181;
        Tue, 10 Mar 2020 16:25:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:25:00 -0700 (PDT)
Message-Id: <20200310.162500.1654615171721402705.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: simplify getting stats by using
 netdev_stats_to_stats64
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5b4bf717-934b-b0c6-0f66-585dbe3f774d@gmail.com>
References: <5b4bf717-934b-b0c6-0f66-585dbe3f774d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:25:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 10 Mar 2020 23:15:00 +0100

> Let netdev_stats_to_stats64() do the copy work for us.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
