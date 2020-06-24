Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276D3206A93
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgFXD1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXD1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:27:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEE9C061573;
        Tue, 23 Jun 2020 20:27:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BC6C1298630D;
        Tue, 23 Jun 2020 20:27:41 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:27:40 -0700 (PDT)
Message-Id: <20200623.202740.2271941543708082998.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net] dcb_doit: remove redundant skb check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623025057.20348-1-gaurav1086@gmail.com>
References: <20200621165657.9814-1-gaurav1086@gmail.com>
        <20200623025057.20348-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:27:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Mon, 22 Jun 2020 22:50:39 -0400

> skb cannot be NULL here since its already being accessed
> before: sock_net(skb->sk). Remove the redundant null check.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Applied.
