Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C542CFFF6
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgLFAdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgLFAdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:33:40 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2F5C0613CF
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 16:33:00 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 274524CBC6EF1;
        Sat,  5 Dec 2020 16:32:58 -0800 (PST)
Date:   Sat, 05 Dec 2020 16:32:53 -0800 (PST)
Message-Id: <20201205.163253.601302619732933737.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     kuba@kernel.org, nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: improve rtl_rx and NUM_RX_DESC
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
References: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 05 Dec 2020 16:32:58 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 6 Dec 2020 00:58:12 +0100

> This series improves rtl_rx() and the handling of NUM_RX_DESC.

Series applied, thanks Heiner!

