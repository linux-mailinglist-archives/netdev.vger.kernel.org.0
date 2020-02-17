Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D48161D46
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgBQWXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:23:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56106 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgBQWXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:23:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D50D615AA75A5;
        Mon, 17 Feb 2020 14:23:08 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:23:08 -0800 (PST)
Message-Id: <20200217.142308.588904136253746041.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: stmmac: Get rid of custom STMMAC_DEVICE() macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217105827.54512-1-andriy.shevchenko@linux.intel.com>
References: <20200217105827.54512-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:23:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 17 Feb 2020 12:58:27 +0200

> Since PCI core provides a generic PCI_DEVICE_DATA() macro,
> replace STMMAC_DEVICE() with former one.
> 
> No functional change intended.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied to net-next, thank you.
