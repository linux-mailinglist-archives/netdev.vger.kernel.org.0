Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C823169E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgG2AKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbgG2AKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:10:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E35C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:10:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D014128D305A;
        Tue, 28 Jul 2020 16:53:44 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:10:28 -0700 (PDT)
Message-Id: <20200728.171028.1881170661773930094.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     eric.dumazet@gmail.com, sishuai@purdue.edu, tgraf@suug.ch,
        netdev@vger.kernel.org, pfonseca@purdue.edu
Subject: Re: [v2 PATCH 0/2] rhashtable: Fix unprotected RCU dereference in
 __rht_ptr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724101220.GA15913@gondor.apana.org.au>
References: <20200724101220.GA15913@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:53:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 24 Jul 2020 20:12:20 +1000

> This patch series fixes an unprotected dereference in __rht_ptr.
> The first patch is a minimal fix that does not use the correct
> RCU markings but is suitable for backport, and the second patch
> cleans up the RCU markings.

Series applied, thank you.
