Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E94E1C9FDC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgEHA6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEHA6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:58:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB541C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:58:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD4CC1193779D;
        Thu,  7 May 2020 17:58:47 -0700 (PDT)
Date:   Thu, 07 May 2020 17:58:46 -0700 (PDT)
Message-Id: <20200507.175846.466674137616679284.davem@davemloft.net>
To:     zhangkaiheb@126.com
Cc:     ycheng@google.com, edumazet@google.com, ncardwell@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: tcp_mark_head_lost is only valid for sack-tcp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507030830.GA8611@toolchain>
References: <20200507030830.GA8611@toolchain>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:58:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang kai <zhangkaiheb@126.com>
Date: Thu, 7 May 2020 11:08:30 +0800

> so tcp_is_sack/reno checks are removed from tcp_mark_head_lost.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>

Applied to net-next, thanks.
