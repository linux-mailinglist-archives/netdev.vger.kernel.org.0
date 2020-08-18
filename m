Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC6524914F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 01:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHRXBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 19:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgHRXBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 19:01:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075E4C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:01:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10616127E56EC;
        Tue, 18 Aug 2020 15:44:45 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:01:30 -0700 (PDT)
Message-Id: <20200818.160130.2105424681578712407.davem@davemloft.net>
To:     maximmi@mellanox.com
Cc:     mkubecek@suse.cz, andrew@lunn.ch, kuba@kernel.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] ethtool-netlink bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200817133407.22687-1-maximmi@mellanox.com>
References: <20200817133407.22687-1-maximmi@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 15:44:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Mon, 17 Aug 2020 16:34:04 +0300

> This series contains a few bug fixes for ethtool-netlink. These bugs are
> specific for the netlink interface, and the legacy ioctl interface is
> not affected. These patches aim to have the same behavior in
> ethtool-netlink as in the legacy ethtool.
> 
> Please also see the sibling series for the userspace tool.
> 
> v2 changes: Added Fixes tags.

Series applied and queued up for -stable, thank you.
