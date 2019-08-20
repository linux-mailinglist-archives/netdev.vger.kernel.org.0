Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5239695C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbfHTTZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:25:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbfHTTZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:25:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80D1F142CA46B;
        Tue, 20 Aug 2019 12:25:50 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:25:49 -0700 (PDT)
Message-Id: <20190820.122549.1717974409774245848.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com
Subject: Re: [net PATCH] net/smc: make sure EPOLLOUT is raised
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566239761-30252-1-git-send-email-jbaron@akamai.com>
References: <1566239761-30252-1-git-send-email-jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:25:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Mon, 19 Aug 2019 14:36:01 -0400

> Currently, we are only explicitly setting SOCK_NOSPACE on a write timeout
> for non-blocking sockets. Epoll() edge-trigger mode relies on SOCK_NOSPACE
> being set when -EAGAIN is returned to ensure that EPOLLOUT is raised.
> Expand the setting of SOCK_NOSPACE to non-blocking sockets as well that can
> use SO_SNDTIMEO to adjust their write timeout. This mirrors the behavior
> that Eric Dumazet introduced for tcp sockets.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>

Applied and queued up for -stable, thanks Jason.
