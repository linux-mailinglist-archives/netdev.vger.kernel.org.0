Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E9B4102B3
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbhIRBeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232936AbhIRBef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 21:34:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D84761019;
        Sat, 18 Sep 2021 01:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928792;
        bh=fM1jONE1rHNzAPjEztmQsgxqIHJ4sdP5PqHvjUW14n4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i+TTKTu2YV/irey35ls9BKIO/XVvOfafaqgSwEzWndWqLLtUSsPHTRcvhMdCpfhox
         8rO6ZlvG+r2c6xpO/whVwJWNWF6StZAdRsB6yWZC+1mMoE7+hmJcrkcbh8MsiNwEVP
         gcr6iDLHVz8lhmNj+5/g70Zm2waF2xBUzmWCAPvZ2sdjQ2AG1qrRbzYtBtRTM3uybS
         WT8Hf8krcPSNJVBJFYkwn9Tmrj25FaUcbIKSZkPO4HDkmIi4SgQpEP4FpLPy8h9HZV
         /9MMEO4dFj/dN36dCqOhZn7SGzBeviz0NoWON5SkwX+bDtBQklIA+Mn3lhI6uzXiZN
         bGASZfOOPse/w==
Date:   Fri, 17 Sep 2021 18:33:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: socket: add the case sock_no_xxx support
Message-ID: <20210917183311.2db5f332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916122943.19849-1-yajun.deng@linux.dev>
References: <20210916122943.19849-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 20:29:43 +0800 Yajun Deng wrote:
> Those sock_no_{mmap, socketpair, listen, accept, connect, shutdown,
> sendpage} functions are used many times in struct proto_ops, but they are
> meaningless. So we can add them support in socket and delete them in struct
> proto_ops.

So the reason to do this is.. what exactly?

Removing a couple empty helpers (which is not even part of this patch)?

I'm not sold, sorry.
