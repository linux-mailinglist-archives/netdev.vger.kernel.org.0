Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1608320FD62
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgF3UFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgF3UFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:05:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A0DC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:05:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B4A412766B63;
        Tue, 30 Jun 2020 13:05:41 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:05:40 -0700 (PDT)
Message-Id: <20200630.130540.2026401433080352413.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/2] Convert Broadcom B53 to mac_link_up()
 resolved state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630102430.GZ1551@shell.armlinux.org.uk>
References: <20200630102430.GZ1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:05:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 30 Jun 2020 11:24:30 +0100

> These two patches update the Broadcom B53 DSA support to use the newly
> provided resolved link state via mac_link_up() rather than using the
> state in mac_config().

Series applied.
