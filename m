Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D4221178E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgGBBGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgGBBGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 21:06:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D952AC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 18:06:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E32B214E56DC4;
        Wed,  1 Jul 2020 18:06:39 -0700 (PDT)
Date:   Wed, 01 Jul 2020 18:06:39 -0700 (PDT)
Message-Id: <20200701.180639.1585055162486382394.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org,
        hkallweit1@gmail.com, cphealy@gmail.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next v4 03/10] net: ethtool: netlink: Add support
 for triggering a cable test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <944f629f-97f1-61a4-e3ab-50219a1cd8a7@gmail.com>
References: <20200701155621.2b6ea9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200701.160014.637327748926165441.davem@davemloft.net>
        <944f629f-97f1-61a4-e3ab-50219a1cd8a7@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 18:06:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 1 Jul 2020 17:26:23 -0700

> Yes this is annoying, I will have some patches posted tonight that
> untangle the dependency.

Thank you.
