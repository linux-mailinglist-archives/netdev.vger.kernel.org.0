Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E131E3235
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391888AbgEZWRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389638AbgEZWRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:17:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CB1C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:17:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E2B3120ED4BE;
        Tue, 26 May 2020 15:17:08 -0700 (PDT)
Date:   Tue, 26 May 2020 15:17:07 -0700 (PDT)
Message-Id: <20200526.151707.1906193590139471783.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 0/5] tipc: add some improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
References: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:17:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Tue, 26 May 2020 16:38:33 +0700

> This series adds some improvements to TIPC.
> 
> The first patch improves the TIPC broadcast's performance with the 'Gap
> ACK blocks' mechanism similar to unicast before, while the others give
> support on tracing & statistics for broadcast links, and an alternative
> to carry broadcast retransmissions via unicast which might be useful in
> some cases.
> 
> Besides, the Nagle algorithm can now automatically 'adjust' itself
> depending on the specific network condition a stream connection runs by
> the last patch.

Series applied, thanks.
