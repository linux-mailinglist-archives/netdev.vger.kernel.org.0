Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651E71C7C3C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgEFVSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728665AbgEFVSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:18:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B332AC061A0F;
        Wed,  6 May 2020 14:18:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E9EC123229ED;
        Wed,  6 May 2020 14:18:15 -0700 (PDT)
Date:   Wed, 06 May 2020 14:18:14 -0700 (PDT)
Message-Id: <20200506.141814.1060708966400070196.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     maxime.chevallier@bootlin.com, kuba@kernel.org, jiri@mellanox.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 net] net: mvpp2: cls: Prevent buffer overflow in
 mvpp2_ethtool_cls_rule_del()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506101656.GC77004@mwanda>
References: <20200506101622.GB77004@mwanda>
        <20200506101656.GC77004@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:18:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 6 May 2020 13:16:56 +0300

> The "info->fs.location" is a u32 that comes from the user via the
> ethtool_set_rxnfc() function.  We need to check for invalid values to
> prevent a buffer overflow.
> 
> I copy and pasted this check from the mvpp2_ethtool_cls_rule_ins()
> function.
> 
> Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
