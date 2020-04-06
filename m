Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E170519FB16
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbgDFRMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:12:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgDFRMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:12:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D0C215DA2244;
        Mon,  6 Apr 2020 10:12:21 -0700 (PDT)
Date:   Mon, 06 Apr 2020 10:12:20 -0700 (PDT)
Message-Id: <20200406.101220.600419687722951897.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 5.7] r8169: change back SG and TSO to be disabled
 by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <168255ae-6b41-f458-fb67-3a3e853be5a6@gmail.com>
References: <168255ae-6b41-f458-fb67-3a3e853be5a6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 10:12:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 4 Apr 2020 23:52:25 +0200

> There has been a number of reports that using SG/TSO on different chip
> versions results in tx timeouts. However for a lot of people SG/TSO
> works fine. Therefore disable both features by default, but allow users
> to enable them. Use at own risk!
> 
> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

It's unfortunate we have to do this, but better safe than sorry.

Applied and queued up for -stable, and thanks for the backport.
