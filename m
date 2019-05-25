Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18A2A5E4
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 19:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEYRxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 13:53:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57370 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfEYRx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 13:53:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB36714FC7125;
        Sat, 25 May 2019 10:53:28 -0700 (PDT)
Date:   Sat, 25 May 2019 10:53:25 -0700 (PDT)
Message-Id: <20190525.105325.1113754964856663524.davem@davemloft.net>
To:     stranche@codeaurora.org
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, subashab@codeaurora.org
Subject: Re: [PATCH net-next] udp: Avoid post-GRO UDP checksum recalculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558640177-10984-1-git-send-email-stranche@codeaurora.org>
References: <1558640177-10984-1-git-send-email-stranche@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 May 2019 10:53:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>
Date: Thu, 23 May 2019 13:36:17 -0600

> @@ -472,11 +472,15 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>  					      struct sk_buff *skb, bool ipv4)
>  {
>  	struct sk_buff *segs;
> +	netdev_features_t features = NETIF_F_SG;

When you respin this based upon Paolo's feedback, please reverse christmas
tree these local variables.

Thank you.
