Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5130204811
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbgFWDtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgFWDtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:49:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEB2C061573;
        Mon, 22 Jun 2020 20:49:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07257120F93FB;
        Mon, 22 Jun 2020 20:49:19 -0700 (PDT)
Date:   Mon, 22 Jun 2020 20:49:19 -0700 (PDT)
Message-Id: <20200622.204919.211760892950235272.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     kuba@kernel.org, mkubecek@suse.cz, f.fainelli@gmail.com,
        andrew@lunn.ch, leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix check in ethtool_rx_flow_rule_create
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621153051.8553-1-gaurav1086@gmail.com>
References: <20200621153051.8553-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 20:49:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Sun, 21 Jun 2020 11:30:17 -0400

> Fix check in ethtool_rx_flow_rule_create
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Applied and queued up for -stable with the following Fixes: tag added:

Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")

Thank you.
