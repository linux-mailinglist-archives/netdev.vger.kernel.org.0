Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9252247F7
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 04:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgGRCEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 22:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGRCEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 22:04:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F51C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 19:04:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 613AD11E45917;
        Fri, 17 Jul 2020 19:04:23 -0700 (PDT)
Date:   Fri, 17 Jul 2020 19:04:22 -0700 (PDT)
Message-Id: <20200717.190422.575221916814775707.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ne2k-pci: Use netif_msg_init to initialize
 msg_enable bits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717182148.GA4905@mx-linux-amd>
References: <20200717182148.GA4905@mx-linux-amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 19:04:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Fri, 17 Jul 2020 20:21:48 +0200

> Use netif_msg_enable() to process param settings.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

Applied.
