Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B001E68E7
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 19:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405672AbgE1Ryj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 13:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405666AbgE1Ryi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 13:54:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE72C08C5C6;
        Thu, 28 May 2020 10:54:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2393C12959D26;
        Thu, 28 May 2020 10:54:36 -0700 (PDT)
Date:   Thu, 28 May 2020 10:54:35 -0700 (PDT)
Message-Id: <20200528.105435.2233696657374817541.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/3] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527224018.3610-1-pablo@netfilter.org>
References: <20200527224018.3610-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 10:54:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 28 May 2020 00:40:15 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Uninitialized when used in __nf_conntrack_update(), from
>    Nathan Chancellor.
> 
> 2) Comparison of unsigned expression in nf_confirm_cthelper().
> 
> 3) Remove 'const' type qualifier with no effect.
> 
> This batch is addressing fallout from the previous pull request.
> 
> Please, pull this updates from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
