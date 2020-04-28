Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB311BCCF4
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgD1UFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD1UFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:05:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF73C03C1AB;
        Tue, 28 Apr 2020 13:05:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB60A1210A3F1;
        Tue, 28 Apr 2020 13:05:45 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:05:45 -0700 (PDT)
Message-Id: <20200428.130545.1878103691480474686.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, afd@ti.com
Subject: Re: [PATCH net v2 2/2] net: phy: DP83TC811: Fix WoL in config init
 to be disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427212112.25368-3-dmurphy@ti.com>
References: <20200427212112.25368-1-dmurphy@ti.com>
        <20200427212112.25368-3-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 13:05:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Mon, 27 Apr 2020 16:21:12 -0500

> +		return phy_write_mmd(phydev, DP83822_DEVADDR,
                                             ^^^^^^^^^^^^^^^^

Please don't submit patches that have not even had a conversation with
the compiler.

This register define only exists in dp83822.c and you are trying to use
it in dp83tc811.c

If this doesn't compile, how did you do functional testing of this
change?

If you compile tested these changes against a tree other than the 'net'
tree, please don't do that.

Thanks.
