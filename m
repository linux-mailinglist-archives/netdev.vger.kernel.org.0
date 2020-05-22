Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6C21DF2CA
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgEVXNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731175AbgEVXNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:13:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42709C061A0E;
        Fri, 22 May 2020 16:13:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A31CA12750EC8;
        Fri, 22 May 2020 16:13:37 -0700 (PDT)
Date:   Fri, 22 May 2020 16:13:36 -0700 (PDT)
Message-Id: <20200522.161336.526663904778578885.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] DP83869 Enhancements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521174738.3151-1-dmurphy@ti.com>
References: <20200521174738.3151-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:13:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Thu, 21 May 2020 12:47:36 -0500

> These are improvements to the DP83869 Ethernet PHY driver.  OP-mode and port
> mirroring may be strapped on the device but the software only retrives these
> settings from the device tree.  Reading the straps and initializing the
> associated stored variables so when setting the PHY up and down the PHY's
> configuration values will be retained.

Series applied, thank you.
