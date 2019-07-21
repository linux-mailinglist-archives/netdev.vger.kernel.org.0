Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBA16F4BA
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfGUSmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:42:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfGUSmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:42:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B6C015258BBE;
        Sun, 21 Jul 2019 11:42:51 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:42:50 -0700 (PDT)
Message-Id: <20190721.114250.1893607784895600131.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tipc: Fix a typo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190721103811.29724-1-christophe.jaillet@wanadoo.fr>
References: <20190721103811.29724-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:42:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 21 Jul 2019 12:38:11 +0200

> s/tipc_toprsv_listener_data_ready/tipc_topsrv_listener_data_ready/
> (r and s switched in topsrv)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> The function name could also be removed from the comment. It does not
> bring any useful information IMHO.

Applied, thanks Christophe.
