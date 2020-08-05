Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB8123CFD2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgHETZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgHETZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:25:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC34C061575
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 12:25:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9291D152E6F3F;
        Wed,  5 Aug 2020 12:08:23 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:25:08 -0700 (PDT)
Message-Id: <20200805.122508.1983611145468632689.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org,
        nicolas.rybowski@tessares.net
Subject: Re: [PATCH net] mptcp: be careful on subflow creation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
References: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 12:08:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue,  4 Aug 2020 18:31:06 +0200

> Nicolas reported the following oops:
 ...
> on some unconventional configuration.
> 
> The MPTCP protocol is trying to create a subflow for an
> unaccepted server socket. That is allowed by the RFC, even
> if subflow creation will likely fail.
> Unaccepted sockets have still a NULL sk_socket field,
> avoid the issue by failing earlier.
> 
> Reported-and-tested-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> Fixes: 7d14b0d2b9b3 ("mptcp: set correct vfs info for subflows")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for v5.7+ -stable, thank you.
