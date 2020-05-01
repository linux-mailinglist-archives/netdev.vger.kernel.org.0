Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C281C2084
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgEAWYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAWYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:24:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5C8C061A0C;
        Fri,  1 May 2020 15:24:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7294B14F43DBE;
        Fri,  1 May 2020 15:24:01 -0700 (PDT)
Date:   Fri, 01 May 2020 15:24:00 -0700 (PDT)
Message-Id: <20200501.152400.457588151775953645.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, afd@ti.com
Subject: Re: [PATCH net v3 0/2] WoL fixes for DP83822 and DP83tc811
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428160354.2879-1-dmurphy@ti.com>
References: <20200428160354.2879-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:24:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Tue, 28 Apr 2020 11:03:52 -0500

> The WoL feature for each device was enabled during boot or when the PHY was
> brought up which may be undesired.  These patches disable the WoL in the
> config_init.  The disabling and enabling of the WoL is now done though the
> set_wol call.

Series applied, thanks.
