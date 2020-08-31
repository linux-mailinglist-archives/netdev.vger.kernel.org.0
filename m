Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE92581B6
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgHaTXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgHaTXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:23:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84713C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:23:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4752B12889EDD;
        Mon, 31 Aug 2020 12:06:57 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:23:43 -0700 (PDT)
Message-Id: <20200831.122343.906561042416756827.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] net: phylink: avoid oops during initialisation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1kBc13-00032k-N3@rmk-PC.armlinux.org.uk>
References: <E1kBc13-00032k-N3@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:06:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 28 Aug 2020 11:53:53 +0100

> If we intend to use PCS operations, mac_pcs_get_state() will not be
> implemented, so will be NULL. If we also intend to register the PCS
> operations in mac_prepare() or mac_config(), then this leads to an
> attempt to call NULL function pointer during phylink_start(). Avoid
> this, but we must report the link is down.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you.
