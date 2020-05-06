Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B4D1C7C39
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgEFVSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729162AbgEFVSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:18:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED64EC061A0F;
        Wed,  6 May 2020 14:18:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37697123229EC;
        Wed,  6 May 2020 14:18:10 -0700 (PDT)
Date:   Wed, 06 May 2020 14:18:09 -0700 (PDT)
Message-Id: <20200506.141809.1664241067295315347.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     maxime.chevallier@bootlin.com, mcroce@redhat.com,
        rmk+kernel@armlinux.org.uk, antoine.tenart@bootlin.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 net] net: mvpp2: prevent buffer overflow in
 mvpp22_rss_ctx()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506101622.GB77004@mwanda>
References: <20200506101622.GB77004@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:18:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 6 May 2020 13:16:22 +0300

> The "rss_context" variable comes from the user via  ethtool_get_rxfh().
> It can be any u32 value except zero.  Eventually it gets passed to
> mvpp22_rss_ctx() and if it is over MVPP22_N_RSS_TABLES (8) then it
> results in an array overflow.
> 
> Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
