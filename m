Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A63A1C06FA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgD3Tvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgD3Tvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:51:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76C3C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:51:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 440621289FD3C;
        Thu, 30 Apr 2020 12:51:47 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:51:46 -0700 (PDT)
Message-Id: <20200430.125146.1288195412515001021.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-stm32@st-md-mailman.stormreply.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] stmmac: intel: Fixes and cleanups after
 dwmac-intel split
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
References: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:51:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 30 Apr 2020 18:02:47 +0300

> Seems the split of dwmac-intel didn't go well and on top of that new
> functionality in the driver has not been properly tested.
> 
> Patch 1 fixes a nasty kernel crash due to missed error handling.
> Patches 2 and 3 fix the incorrect split (clock and PCI bar handling).
> 
> Patch 4 converts driver to use new PCI IRQ allocation API.
> 
> The rest is a set of clean ups that may have been done in the initial
> submission.
> 
> Series has been tested on couple of Elkhart Lake platforms with different
> behaviour of ethernet hardware.
> 
> Changelog v3:
> - added the cover letter (David)
> - appended separate fix as a first patch
> - marked patches 2 and 3 with Fixes tag

Series applied, thank you.
