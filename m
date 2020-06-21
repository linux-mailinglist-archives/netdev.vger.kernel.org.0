Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281E32027C4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgFUAsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgFUAsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:48:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB74C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:48:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EE26120ED4AD;
        Sat, 20 Jun 2020 17:48:10 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:48:09 -0700 (PDT)
Message-Id: <20200620.174809.1580262660147867111.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/2] tcp: remove two indirect calls from xmit
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619191235.199506-1-edumazet@google.com>
References: <20200619191235.199506-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:48:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 19 Jun 2020 12:12:33 -0700

> __tcp_transmit_skb() does two indirect calls per packet, lets get rid
> of them.

Series applied, thanks.
