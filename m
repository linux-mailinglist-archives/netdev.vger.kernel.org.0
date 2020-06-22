Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF3204474
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgFVX30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgFVX3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:29:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2473C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:29:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5573A12972162;
        Mon, 22 Jun 2020 16:29:24 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:29:23 -0700 (PDT)
Message-Id: <20200622.162923.2028059632722897298.davem@davemloft.net>
To:     fido_max@inbox.ru
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/3] Add Marvell 88E1340S, 88E1548P support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621075952.11970-1-fido_max@inbox.ru>
References: <20200621075952.11970-1-fido_max@inbox.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:29:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>
Date: Sun, 21 Jun 2020 10:59:49 +0300

> This patch series add new PHY id support.
> Russell King asked to use single style for referencing functions.

Series applied, thanks.

But like Florian said, you should retain Reviewed-by tags when you
make trivial updates to a patch series.

Thanks.
