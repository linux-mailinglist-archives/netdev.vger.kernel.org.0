Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E354E5C721
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGBCXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:23:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfGBCXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:23:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BC5E14DEB0FC;
        Mon,  1 Jul 2019 19:23:53 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:23:52 -0700 (PDT)
Message-Id: <20190701.192352.1011588252330122649.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, alexei.starovoitov@gmail.com,
        sd@queasysnail.net, dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net] net/tls: make sure offload also gets the keys wiped
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628231139.16842-1-jakub.kicinski@netronome.com>
References: <20190628231139.16842-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:23:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 28 Jun 2019 16:11:39 -0700

> Commit 86029d10af18 ("tls: zero the crypto information from tls_context
> before freeing") added memzero_explicit() calls to clear the key material
> before freeing struct tls_context, but it missed tls_device.c has its
> own way of freeing this structure. Replace the missing free.
> 
> Fixes: 86029d10af18 ("tls: zero the crypto information from tls_context before freeing")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Applied and queued up for -stable.
