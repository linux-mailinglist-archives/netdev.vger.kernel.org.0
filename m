Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2927957D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgIZARa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbgIZAR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:17:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF47C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:17:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22A191001BE19;
        Fri, 25 Sep 2020 17:00:42 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:17:28 -0700 (PDT)
Message-Id: <20200925.171728.541440348039438279.davem@davemloft.net>
To:     ycheng@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH net-next 0/4] simplify TCP loss marking code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925170431.1099943-1-ycheng@google.com>
References: <20200925170431.1099943-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 17:00:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Fri, 25 Sep 2020 10:04:27 -0700

> The TCP loss marking is implemented by a set of intertwined
> subroutines. TCP has several loss detection algorithms
> (RACK, RFC6675/FACK, NewReno, etc) each calls a subset of
> these routines to mark a packet lost. This has led to
> various bugs (and fixes and fixes of fixes).
> 
> This patch set is to consolidate the loss marking code so
> all detection algorithms call the same routine tcp_mark_skb_lost().

Looks good, series applied.

Thanks.
