Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC562580FB
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgHaSXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbgHaSXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 14:23:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B157AC061575;
        Mon, 31 Aug 2020 11:23:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F33CD12837DA1;
        Mon, 31 Aug 2020 11:06:08 -0700 (PDT)
Date:   Mon, 31 Aug 2020 11:22:52 -0700 (PDT)
Message-Id: <20200831.112252.101534188648531041.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/8] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 11:06:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 31 Aug 2020 11:36:40 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Do not delete clash entries on reply, let them expire instead,
>    from Florian Westphal.
> 
> 2) Do not report EAGAIN to nfnetlink, otherwise this enters a busy loop.
>    Update nfnetlink_unicast() to translate EAGAIN to ENOBUFS.
> 
> 3) Remove repeated words in code comments, from Randy Dunlap.
> 
> 4) Several patches for the flowtable selftests, from Fabian Frederick.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
