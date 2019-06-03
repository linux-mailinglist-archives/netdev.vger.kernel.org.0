Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E169833AED
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfFCWOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:14:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36152 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfFCWOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:14:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50EC9136E16B0;
        Mon,  3 Jun 2019 15:14:19 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:14:18 -0700 (PDT)
Message-Id: <20190603.151418.114698218593108927.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: use paged versions of phylib MDIO
 access functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f7415a62-625d-06d8-0402-f2f8ef9764df@gmail.com>
References: <f7415a62-625d-06d8-0402-f2f8ef9764df@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:14:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 2 Jun 2019 10:53:49 +0200

> Use paged versions of phylib MDIO access functions to simplify
> the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
