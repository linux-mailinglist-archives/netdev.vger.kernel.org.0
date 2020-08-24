Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C0250C35
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgHXXTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXXTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:19:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4F7C061574;
        Mon, 24 Aug 2020 16:19:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25A1D12924E97;
        Mon, 24 Aug 2020 16:02:53 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:19:37 -0700 (PDT)
Message-Id: <20200824.161937.197785505315942083.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next 0/6] MAINTAINERS: Remove self from PHY LIBRARY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822201126.8253-1-f.fainelli@gmail.com>
References: <20200822201126.8253-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 16:02:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sat, 22 Aug 2020 13:11:20 -0700

> Hi David, Heiner, Andrew, Russell,
> 
> This patch series aims at allowing myself to keep track of the Ethernet
> PHY and MDIO bus drivers that I authored or contributed to without
> being listed as a maintainer in the PHY library anymore.
> 
> Thank you for the fish, I will still be around.

I applied this to 'net' because I think it's important to MAINTAINERS
information to be as uptodate as possible.

Thanks Florian.
