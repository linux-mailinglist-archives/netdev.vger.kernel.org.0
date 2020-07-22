Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962AD228DA6
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbgGVBbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGVBbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 21:31:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363E9C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 18:31:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 046A311DB315F;
        Tue, 21 Jul 2020 18:14:27 -0700 (PDT)
Date:   Tue, 21 Jul 2020 18:31:12 -0700 (PDT)
Message-Id: <20200721.183112.373919081990018897.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, gnault@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v3] bareudp: Reverted support to enable &
 disable rx metadata collection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594953312-4580-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1594953312-4580-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 18:14:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Fri, 17 Jul 2020 08:05:12 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The commit fe80536acf83 ("bareudp: Added attribute to enable & disable
> rx metadata collection") breaks the the original(5.7) default behavior of
> bareudp module to collect RX metadadata at the receive. It was added to
> avoid the crash at the kernel neighbour subsytem when packet with metadata
> from bareudp is processed. But it is no more needed as the
> commit 394de110a733 ("net: Added pointer check for
> dst->ops->neigh_lookup in dst_neigh_lookup_skb") solves this crash.
> 
> Fixes: fe80536acf83 ("bareudp: Added attribute to enable & disable rx metadata collection")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Applied.
