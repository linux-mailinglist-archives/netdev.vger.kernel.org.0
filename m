Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1B6153159
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBENAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:00:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgBENAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:00:19 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4306A158E2162;
        Wed,  5 Feb 2020 05:00:18 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:00:16 +0100 (CET)
Message-Id: <20200205.140016.424519322133912475.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, f.fainelli@gmail.com
Subject: Re: [PATCH v2 2/2] net: dsa: microchip: Platform data shan't
 include kernel.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205092903.71347-2-andriy.shevchenko@linux.intel.com>
References: <20200205092903.71347-1-andriy.shevchenko@linux.intel.com>
        <20200205092903.71347-2-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:00:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed,  5 Feb 2020 11:29:03 +0200

> Replace with appropriate types.h.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> v2: Add tag, incorporate into 'net: dsa:' series

Applied.
