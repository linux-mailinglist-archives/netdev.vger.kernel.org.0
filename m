Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7530C2C3848
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgKYEzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKYEzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:55:15 -0500
X-Greylist: delayed 456 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Nov 2020 20:55:15 PST
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AB3C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:55:15 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 007A94CBCE204;
        Tue, 24 Nov 2020 20:47:36 -0800 (PST)
Date:   Tue, 24 Nov 2020 20:47:23 -0800 (PST)
Message-Id: <20201124.204723.2063364355702441857.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, f.fainelli@gmail.com,
        andrea.mayer@uniroma2.it, dsahern@gmail.com,
        stephen@networkplumber.org, ast@kernel.org
Subject: Re: [PATCH net v2] Documentation: netdev-FAQ: suggest how to post
 co-dependent series
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201125041524.190170-1-kuba@kernel.org>
References: <20201125041524.190170-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (shards.monkeyblade.net [0.0.0.0]); Tue, 24 Nov 2020 20:47:37 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 24 Nov 2020 20:15:24 -0800

> Make an explicit suggestion how to post user space side of kernel
> patches to avoid reposts when patchwork groups the wrong patches.
> 
> v2: mention the cases unlike iproute2 explicitly
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!!
