Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF3720279E
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgFUAcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUAcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:32:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C5CC061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:32:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D12BD120ED49C;
        Sat, 20 Jun 2020 17:32:11 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:32:11 -0700 (PDT)
Message-Id: <20200620.173211.41576810184648578.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, mapengyu@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix firmware not resetting tp->ocp_base
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fa7fd9bd-15c0-4533-b698-c4814406ad74@gmail.com>
References: <fa7fd9bd-15c0-4533-b698-c4814406ad74@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:32:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 18 Jun 2020 23:25:50 +0200

> Typically the firmware takes care that tp->ocp_base is reset to its
> default value. That's not the case (at least) for RTL8117.
> As a result subsequent PHY access reads/writes the wrong page and
> the link is broken. Fix this be resetting tp->ocp_base explicitly.
> 
> Fixes: 229c1e0dfd3d ("r8169: load firmware for RTL8168fp/RTL8117")
> Reported-by: Aaron Ma <mapengyu@gmail.com>
> Tested-by: Aaron Ma <mapengyu@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for v5.5 -stable, thanks.
