Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582183F2B81
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbhHTLrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbhHTLrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 07:47:15 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CA4C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 04:46:38 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 839684D0F197C;
        Fri, 20 Aug 2021 04:46:34 -0700 (PDT)
Date:   Fri, 20 Aug 2021 12:46:29 +0100 (BST)
Message-Id: <20210820.124629.2213659775230733647.davem@davemloft.net>
To:     luiz.dentz@gmail.com
Cc:     kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2021-08-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210819222307.242695-1-luiz.dentz@gmail.com>
References: <20210819222307.242695-1-luiz.dentz@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 20 Aug 2021 04:46:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Thu, 19 Aug 2021 15:23:07 -0700

> The following changes since commit 4431531c482a2c05126caaa9fcc5053a4a5c495b:
> 
>   nfp: fix return statement in nfp_net_parse_meta() (2021-07-22 05:46:03 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-08-19
> 

There was a major merge conflict with the deferred hci cleanup fix that came in via
'net'.  Please double check my conflict resolution.

Thanks.

