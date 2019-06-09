Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E1B3ABC3
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfFIUYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:24:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729554AbfFIUYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:24:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E43614DF1DD5;
        Sun,  9 Jun 2019 13:24:41 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:24:40 -0700 (PDT)
Message-Id: <20190609.132440.1059075761730033493.davem@davemloft.net>
To:     schmitzmic@gmail.com
Cc:     netdev@vger.kernel.org, netdev@vger.kernel-org,
        anders.roxell@linaro.org, andrew@lunn.ch, sfr@canb.auug.org.au
Subject: Re: [PATCH net v3] net: phy: rename Asix Electronics PHY driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559885854-15904-1-git-send-email-schmitzmic@gmail.com>
References: <20190514105649.512267cd@canb.auug.org.au>
        <1559885854-15904-1-git-send-email-schmitzmic@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:24:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>
Date: Fri,  7 Jun 2019 17:37:34 +1200

> [Resent to net instead of net-next - may clash with Anders Roxell's patch
> series addressing duplicate module names]
> 
> Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
> introduced a new PHY driver drivers/net/phy/asix.c that causes a module
> name conflict with a pre-existiting driver (drivers/net/usb/asix.c).
> 
> The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
> by that driver via its PHY ID. A rename of the driver looks unproblematic.
> 
> Rename PHY driver to ax88796b.c in order to resolve name conflict. 
> 
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
> ---
> 
> Changes from v1:
> 
> - merge into single commit (suggested by Andrew Lunn)
> 
> Changes from v2:
> 
> - use rename flag for diff (suggested by Andrew Lunn)

Applied, thanks.
