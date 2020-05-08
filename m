Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD61CA005
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgEHBRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEHBRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:17:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C5C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:17:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E97E2119376FA;
        Thu,  7 May 2020 18:17:50 -0700 (PDT)
Date:   Thu, 07 May 2020 18:17:50 -0700 (PDT)
Message-Id: <20200507.181750.1941831617744583039.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH net-next] net: relax SO_TXTIME CAP_NET_ADMIN check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507170539.157454-1-edumazet@google.com>
References: <20200507170539.157454-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:17:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 May 2020 10:05:39 -0700

> Now sch_fq has horizon feature, we want to allow QUIC/UDP applications
> to use EDT model so that pacing can be offloaded to the kernel (sch_fq)
> or the NIC.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Applied, thanks Eric.
