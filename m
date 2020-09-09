Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADFA26357C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgIISFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIISF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:05:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45659C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:05:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84A8212954904;
        Wed,  9 Sep 2020 10:48:38 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:05:24 -0700 (PDT)
Message-Id: <20200909.110524.975075010832926641.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 0/2] net: skb_put_padto() fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909082740.204752-1-edumazet@google.com>
References: <20200909082740.204752-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 10:48:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  9 Sep 2020 01:27:38 -0700

> sysbot reported a bug in qrtr leading to use-after-free.
> 
> First patch fixes the issue.
> 
> Second patch addes __must_check attribute to avoid similar
> issues in the future.

Series applied and queued up for -stable, thanks!
