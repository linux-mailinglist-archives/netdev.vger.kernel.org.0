Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D8313797
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfEDFfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:35:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfEDFfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:35:31 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10EE514DA647B;
        Fri,  3 May 2019 22:35:27 -0700 (PDT)
Date:   Sat, 04 May 2019 01:35:23 -0400 (EDT)
Message-Id: <20190504.013523.1399094253081499865.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove rtl_write_exgmac_batch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0720a8db-562c-d2cb-b992-8c29385461ac@gmail.com>
References: <0720a8db-562c-d2cb-b992-8c29385461ac@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 22:35:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 2 May 2019 20:46:52 +0200

> rtl_write_exgmac_batch is used in only one place, so we can remove it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
