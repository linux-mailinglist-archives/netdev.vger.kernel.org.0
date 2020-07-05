Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9576021495F
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgGEArx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEArw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:47:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F3AC061794;
        Sat,  4 Jul 2020 17:47:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98652157A9A2E;
        Sat,  4 Jul 2020 17:47:52 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:47:51 -0700 (PDT)
Message-Id: <20200704.174751.1679610909315179241.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200704001359.1304-1-pablo@netfilter.org>
References: <20200704001359.1304-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:47:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat,  4 Jul 2020 02:13:57 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Use kvfree() to release vmalloc()'ed areas in ipset, from Eric Dumazet.
> 
> 2) UAF in nfnetlink_queue from the nf_conntrack_update() path.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
