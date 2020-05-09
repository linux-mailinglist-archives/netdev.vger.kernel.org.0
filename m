Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549BF1CC522
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEIXcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbgEIXcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:32:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7129C061A0C;
        Sat,  9 May 2020 16:32:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8407B128ED627;
        Sat,  9 May 2020 16:32:18 -0700 (PDT)
Date:   Sat, 09 May 2020 16:32:17 -0700 (PDT)
Message-Id: <20200509.163217.1372289149714306397.davem@davemloft.net>
To:     joe@perches.com
Cc:     kuba@kernel.org, christophe.jaillet@wanadoo.fr,
        fthain@telegraphics.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fc5cf8da8e70ebb981a9fc3aec6834c74197f0ed.camel@perches.com>
References: <50ef36cd-d095-9abe-26ea-d363d11ce521@wanadoo.fr>
        <20200509111321.51419b19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fc5cf8da8e70ebb981a9fc3aec6834c74197f0ed.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 May 2020 16:32:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 09 May 2020 15:42:36 -0700

> David, maybe I missed some notification about Jakub's role.
> 
> What is Jakub's role in relation to the networking tree?

He is the co-maintainer of the networking tree and you should respect
his actions and feedback as if it were coming from me.
