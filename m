Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75821D1F3B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390672AbgEMTbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390474AbgEMTbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:31:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9847C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:31:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C84D127E95A7;
        Wed, 13 May 2020 12:31:23 -0700 (PDT)
Date:   Wed, 13 May 2020 12:31:22 -0700 (PDT)
Message-Id: <20200513.123122.1741815115141237500.davem@davemloft.net>
To:     hch@lst.de
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [PATCH] net: ignore sock_from_file errors in __scm_install_fd
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513110759.2362955-1-hch@lst.de>
References: <20200513110759.2362955-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:31:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 13:07:59 +0200

> The code had historically been ignoring these errors, and my recent
> refactoring changed that, which broke ssh in some setups.
> 
> Fixes: 2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied, please put something like "[PATCH net-next]" in the Subject
line next time.

Thank you.
