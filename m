Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB220628B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389152AbgFWVEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393015AbgFWVEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:04:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9557AC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 14:04:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 426BB129293FD;
        Tue, 23 Jun 2020 14:04:06 -0700 (PDT)
Date:   Tue, 23 Jun 2020 14:04:03 -0700 (PDT)
Message-Id: <20200623.140403.608261759970969999.davem@davemloft.net>
To:     fido_max@inbox.ru
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org
Subject: Re: [PATCH net-next v3 0/3] Add Marvell 88E1340S, 88E1548P support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623050044.12303-1-fido_max@inbox.ru>
References: <20200623050044.12303-1-fido_max@inbox.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 14:04:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>
Date: Tue, 23 Jun 2020 08:00:41 +0300

> This patch series add new PHY id support.
> Russell King asked to use single style for referencing functions.

I already applied your v2 series yesterday.

Also, when you post a new version of a patch or patch series you have
to have a changelog so that I know what is different in this version.
