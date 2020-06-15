Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0911FA1DF
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgFOUoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbgFOUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:44:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2363C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 13:44:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E17DD1210A401;
        Mon, 15 Jun 2020 13:44:17 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:44:17 -0700 (PDT)
Message-Id: <20200615.134417.367074350232867109.davem@davemloft.net>
To:     sven.auhagen@voleatech.de
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        gregory.clement@bootlin.com, maxime.chevallier@bootlin.com,
        thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com,
        mw@semihalf.com, lorenzo@kernel.org, technoboy85@gmail.com
Subject: Re: [PATCH 1/1] mvpp2: ethtool rxtx stats fix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200614071917.k46e3wvumqp6bj3x@SvensMacBookAir.sven.lan>
References: <20200614071917.k46e3wvumqp6bj3x@SvensMacBookAir.sven.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:44:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>
Date: Sun, 14 Jun 2020 09:19:17 +0200

> The ethtool rx and tx queue statistics are reporting wrong values.
> Fix reading out the correct ones.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Applied and queued up for -stable, thank you.
