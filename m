Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4E20E11A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389649AbgF2UwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731385AbgF2TN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A76C03E97A;
        Sun, 28 Jun 2020 20:53:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71370129AA550;
        Sun, 28 Jun 2020 20:53:09 -0700 (PDT)
Date:   Sun, 28 Jun 2020 20:53:08 -0700 (PDT)
Message-Id: <20200628.205308.878058643318358498.davem@davemloft.net>
To:     luc.vanoostenryck@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, oss-drivers@netronome.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] always use netdev_tx_t for xmit()'s return type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 20:53:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Date: Sun, 28 Jun 2020 21:53:22 +0200

> The ndo_start_xmit() methods should return a 'netdev_tx_t', not
> an int, and so should return NETDEV_TX_OK, not 0.
> The patches in the series fix most of the remaning drivers and
> subsystems (those included in allyesconfig on x86).

Series applied, thanks.
