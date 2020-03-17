Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118C918776F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbgCQB1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:27:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbgCQB1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 21:27:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7B60157A5E89;
        Mon, 16 Mar 2020 18:27:09 -0700 (PDT)
Date:   Mon, 16 Mar 2020 18:27:08 -0700 (PDT)
Message-Id: <20200316.182708.2275968776439275159.davem@davemloft.net>
To:     yangpc@wangsu.com
Cc:     edumazet@google.com, ncardwell@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v2 0/5] tcp: fix stretch ACK bugs in
 congestion control modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 18:27:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>
Date: Mon, 16 Mar 2020 14:35:06 +0800

> "stretch ACKs" (caused by LRO, GRO, delayed ACKs or middleboxes)
> can cause serious performance shortfalls in common congestion
> control algorithms. Neal Cardwell submitted a series of patches
> starting with commit e73ebb0881ea ("tcp: stretch ACK fixes prep")
> to handle stretch ACKs and fixed stretch ACK bugs in Reno and
> CUBIC congestion control algorithms.
> 
> This patch series continues to fix bic, scalable, veno and yeah
> congestion control algorithms to handle stretch ACKs.
> 
> Changes in v2:
> - Provide [PATCH 0/N] to describe the modifications of this patch series

Series applied, thanks.
