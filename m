Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905FF20D500
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbgF2TNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731393AbgF2TN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48494C08C5DB
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 20:59:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9A30129AD886;
        Sun, 28 Jun 2020 20:59:49 -0700 (PDT)
Date:   Sun, 28 Jun 2020 20:59:49 -0700 (PDT)
Message-Id: <20200628.205949.950863347970162259.davem@davemloft.net>
To:     colton.w.lewis@protonmail.com
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/2] net: core: correct trivial kernel-doc
 inconsistencies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200628213912.116330-2-colton.w.lewis@protonmail.com>
References: <20200621234431.GZ1551@shell.armlinux.org.uk>
        <3034206.AJdgDx1Vlc@laptop.coltonlewis.name>
        <20200628213912.116330-2-colton.w.lewis@protonmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 20:59:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colton Lewis <colton.w.lewis@protonmail.com>
Date: Sun, 28 Jun 2020 21:39:38 +0000

> Silence documentation build warnings by correcting kernel-doc comments.
> 
> ./include/linux/netdevice.h:2138: warning: Function parameter or member 'napi_defer_hard_irqs' not described in 'net_device'
> 
> Signed-off-by: Colton Lewis <colton.w.lewis@protonmail.com>

Applied.
