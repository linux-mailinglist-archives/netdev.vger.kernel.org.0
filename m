Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBB146415
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfFNQ2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:28:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfFNQ2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:28:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD85E14C11FA2;
        Fri, 14 Jun 2019 09:28:50 -0700 (PDT)
Date:   Fri, 14 Jun 2019 09:28:48 -0700 (PDT)
Message-Id: <20190614.092848.1330188994897458632.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: further mac_config documentation
 improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614103749.s6pahlazm4hqyurg@shell.armlinux.org.uk>
References: <20190614103749.s6pahlazm4hqyurg@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 09:28:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 14 Jun 2019 11:37:49 +0100

> While reviewing the DPAA2 work, it has become apparent that we need
> better documentation about which members of the phylink link state
> structure are valid in the mac_config call.  Improve this
> documentation.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks.
