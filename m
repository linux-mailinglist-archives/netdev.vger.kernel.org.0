Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90742625D6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIIDWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIIDWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:22:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27400C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 20:22:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B08B711E3E4C3;
        Tue,  8 Sep 2020 20:05:12 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:21:58 -0700 (PDT)
Message-Id: <20200908.202158.255830110879452683.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net-next] ipv6: add tos reflection in TCP reset and ack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908212902.3525935-1-weiwan@google.com>
References: <20200908212902.3525935-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:05:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Tue,  8 Sep 2020 14:29:02 -0700

> Currently, ipv6 stack does not do any TOS reflection. To make the
> behavior consistent with v4 stack, this commit adds TOS reflection in
> tcp_v6_reqsk_send_ack() and tcp_v6_send_reset(). We clear the lower
> 2-bit ECN value of the received TOS in compliance with RFC 3168 6.1.5
> robustness principles.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
