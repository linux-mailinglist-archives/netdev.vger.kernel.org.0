Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E978D37F36
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbfFFVFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:05:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57824 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfFFVFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:05:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B03414E119F8;
        Thu,  6 Jun 2019 14:05:04 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:05:03 -0700 (PDT)
Message-Id: <20190606.140503.320240166416804603.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v4 07/20] net: axienet: Re-initialize MDIO
 registers properly after reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559767353-17301-8-git-send-email-hancock@sedsystems.ca>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
        <1559767353-17301-8-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 14:05:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Wed,  5 Jun 2019 14:42:20 -0600

> +int axienet_mdio_setup(struct axienet_local *lp)
> +{
> +	int ret;
> +	struct mii_bus *bus;
> +	struct device_node *mdio_node;

Please use reverse christmas tree ordering (longest to shortest line) for
local variables.
