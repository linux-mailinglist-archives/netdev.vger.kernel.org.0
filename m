Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDE3251B81
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgHYOzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgHYOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 10:55:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF20C061574;
        Tue, 25 Aug 2020 07:55:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EB90133F575F;
        Tue, 25 Aug 2020 07:38:17 -0700 (PDT)
Date:   Tue, 25 Aug 2020 07:55:02 -0700 (PDT)
Message-Id: <20200825.075502.1718539397369760482.davem@davemloft.net>
To:     joe@perches.com
Cc:     trivial@kernel.org, pantelis.antoniou@gmail.com, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/29] fs_enet: Avoid comma separated statements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <418850ae2026b293ea6ba3b8b19b8a7f8dfcaf3d.1598331149.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
        <418850ae2026b293ea6ba3b8b19b8a7f8dfcaf3d.1598331149.git.joe@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 07:38:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 24 Aug 2020 21:56:14 -0700

> Use semicolons and braces.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
