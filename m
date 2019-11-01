Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E33ECAC4
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfKAWIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:08:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:08:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D07F1151B099A;
        Fri,  1 Nov 2019 15:07:58 -0700 (PDT)
Date:   Fri, 01 Nov 2019 15:07:58 -0700 (PDT)
Message-Id: <20191101.150758.990075102437937211.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, olteanv@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: Fix phylink_dbg() macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031224227.6992-1-f.fainelli@gmail.com>
References: <20191031224227.6992-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 15:07:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 31 Oct 2019 15:42:26 -0700

> The phylink_dbg() macro does not follow dynamic debug or defined(DEBUG)
> and as a result, it spams the kernel log since a PR_DEBUG level is
> currently used. Fix it to be defined appropriately whether
> CONFIG_DYNAMIC_DEBUG or defined(DEBUG) are set.
> 
> Fixes: 17091180b152 ("net: phylink: Add phylink_{printk, err, warn, info, dbg} macros")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable.
