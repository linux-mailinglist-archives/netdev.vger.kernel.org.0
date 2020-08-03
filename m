Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FCB23B006
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgHCWMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgHCWMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:12:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F253C06174A;
        Mon,  3 Aug 2020 15:12:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10EC512771D6C;
        Mon,  3 Aug 2020 14:55:38 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:12:22 -0700 (PDT)
Message-Id: <20200803.151222.446729320721620447.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     kuba@kernel.org, mkubecek@suse.cz, f.fainelli@gmail.com,
        andrew@lunn.ch, linux@rempel-privat.de, yuehaibing@huawei.com,
        ayal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/ethtool] ethnl_set_linkmodes: remove redundant
 null check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731045908.32466-1-gaurav1086@gmail.com>
References: <20200731045908.32466-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 14:55:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Fri, 31 Jul 2020 00:58:44 -0400

> info cannot be NULL here since its being accessed earlier
> in the function: nlmsg_parse(info->nlhdr...). Remove this
> redundant NULL check.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Applied, thank you.
