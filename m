Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C497EB8F1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfJaV0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:26:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfJaV0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:26:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8F3115002421;
        Thu, 31 Oct 2019 14:26:06 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:26:06 -0700 (PDT)
Message-Id: <20191031.142606.2018368283376596287.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, laurentiu.tudor@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:26:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Thu, 31 Oct 2019 01:18:27 +0200

> The dpaa2-eth driver now has support for connecting to its associated PHY
> device found through standard OF bindings. The PHY interraction is handled
> by PHYLINK and even though, at the moment, only RGMII_* phy modes are
> supported by the driver, this is just the first step into adding the
> necessary changes to support the entire spectrum of capabilities.
> 
> This comes after feedback on the initial DPAA2 MAC RFC submitted here:
> https://lwn.net/Articles/791182/
> 
> The notable change is that now, the DPMAC is not a separate driver, and
> communication between the DPMAC and DPNI no longer happens through
> firmware. Rather, the DPMAC is now a set of API functions that other
> net_device drivers (DPNI, DPSW, etc) can use for PHY management.
> 
> The change is incremental, because the DPAA2 architecture has many modes of
> connecting net devices in hardware loopback (for example DPNI to DPNI).
> Those operating modes do not have a DPMAC and phylink instance.
> 
> The documentation patch provides a more complete view of the software
> architecture and the current implementation.
 ...

Series applied.
