Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7BC199CA8
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbgCaRNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:13:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbgCaRNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:13:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7CAA15D0EF02;
        Tue, 31 Mar 2020 10:13:10 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:13:09 -0700 (PDT)
Message-Id: <20200331.101309.89913226453738066.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv6: rpl_iptunnel: Fix potential memory
 leak in rpl_do_srh_inline
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331163506.GA5124@embeddedor>
References: <20200331163506.GA5124@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Mar 2020 10:13:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 31 Mar 2020 11:35:06 -0500

> In case memory resources for buf were allocated, release them before
> return.
> 
> Addresses-Coverity-ID: 1492011 ("Resource leak")
> Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied, thanks.
