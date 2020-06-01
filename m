Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D711EAE29
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgFASvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbgFASvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:51:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C08AC061A0E;
        Mon,  1 Jun 2020 11:51:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E1D111D53F8B;
        Mon,  1 Jun 2020 11:51:37 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:51:36 -0700 (PDT)
Message-Id: <20200601.115136.1314501977250032604.davem@davemloft.net>
To:     rberg@berg-solutions.de
Cc:     andrew@lunn.ch, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529193003.3717-1-rberg@berg-solutions.de>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:51:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roelof Berg <rberg@berg-solutions.de>
Date: Fri, 29 May 2020 21:30:02 +0200

> Microchip lan7431 is frequently connected to a phy. However, it
> can also be directly connected to a MII remote peer without
> any phy in between. For supporting such a phyless hardware setup
> in Linux we utilized phylib, which supports a fixed-link
> configuration via the device tree. And we added support for
> defining the connection type R/GMII in the device tree.
 ...

Applied, thank you.
