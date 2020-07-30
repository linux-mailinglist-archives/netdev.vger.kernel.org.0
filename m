Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED6C233C35
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgG3XiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbgG3XiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:38:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C20C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:38:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A2BE126BFE20;
        Thu, 30 Jul 2020 16:21:36 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:38:20 -0700 (PDT)
Message-Id: <20200730.163820.505646845935151146.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next] rtnetlink: add support for protodown reason
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595877677-45849-1-git-send-email-roopa@cumulusnetworks.com>
References: <1595877677-45849-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:21:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Mon, 27 Jul 2020 12:21:17 -0700

> +/**
> + *	dev_get_proto_down_reason - returns protodown reason
> + *
> + *	@dev: device
> + */
> +u32 dev_get_proto_down_reason(const struct net_device *dev)
> +{
> +	return dev->proto_down_reason;
> +}
> +EXPORT_SYMBOL(dev_get_proto_down_reason);

This helper is excessive, please remove it and just dereference the
netdev member directly.

Thank you.
