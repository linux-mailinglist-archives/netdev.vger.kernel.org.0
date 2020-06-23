Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1042A204827
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbgFWD4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730515AbgFWD4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:56:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451DAC061573;
        Mon, 22 Jun 2020 20:56:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7ACBD120F93F8;
        Mon, 22 Jun 2020 20:56:54 -0700 (PDT)
Date:   Mon, 22 Jun 2020 20:56:53 -0700 (PDT)
Message-Id: <20200622.205653.86213582708540733.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     keescook@google.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        parav@mellanox.com
Subject: Re: linux-next: build failure after merge of the kspp tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623135134.61741e78@canb.auug.org.au>
References: <20200623135134.61741e78@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 20:56:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Jun 2020 13:51:34 +1000

> I have added the following merge fix patch.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 23 Jun 2020 13:43:06 +1000
> Subject: [PATCH] net/core/devlink.c: remove new uninitialized_var() usage
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks Stephen.
