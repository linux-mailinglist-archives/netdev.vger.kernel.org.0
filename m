Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B9E9422
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfJ3Ahf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:37:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ3Ahe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:37:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42D3C13416A71;
        Tue, 29 Oct 2019 17:37:34 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:37:31 -0700 (PDT)
Message-Id: <20191029.173731.1151091692451287618.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, u9012063@gmail.com
Subject: Re: [PATCH net] erspan: fix the tun_info options_len check for
 erspan
From:   David Miller <davem@davemloft.net>
In-Reply-To: <82c8c015ff19bbd5eb9679b5ce01915037d3cd94.1572275975.git.lucien.xin@gmail.com>
References: <82c8c015ff19bbd5eb9679b5ce01915037d3cd94.1572275975.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:37:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Oct 2019 23:19:35 +0800

> The check for !md doens't really work for ip_tunnel_info_opts(info) which
> only does info + 1. Also to avoid out-of-bounds access on info, it should
> ensure options_len is not less than erspan_metadata in both erspan_xmit()
> and ip6erspan_tunnel_xmit().
> 
> Fixes: 1a66a836da ("gre: add collect_md mode to ERSPAN tunnel")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
