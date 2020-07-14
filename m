Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870FE220073
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgGNWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgGNWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:10:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5E8C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 15:10:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D13C15E52DD4;
        Tue, 14 Jul 2020 15:10:50 -0700 (PDT)
Date:   Tue, 14 Jul 2020 15:10:49 -0700 (PDT)
Message-Id: <20200714.151049.555696886733080030.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: add support for RTL8125B
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
References: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 15:10:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 14 Jul 2020 17:43:20 +0200

> This series adds support for RTL8125B rev.b.
> Tested with a Delock 89564 PCIe card.

Series applied, thanks Heiner.
