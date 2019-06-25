Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFA5558EC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfFYUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:34:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50704 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfFYUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:34:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06923128FF110;
        Tue, 25 Jun 2019 13:34:15 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:34:15 -0700 (PDT)
Message-Id: <20190625.133415.1358006150660179231.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, gordan.mihaljevic@dektech.com.au,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: simplify stale link failure criteria
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561477003-25362-1-git-send-email-jon.maloy@ericsson.com>
References: <1561477003-25362-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 13:34:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Tue, 25 Jun 2019 17:36:43 +0200

> In commit a4dc70d46cf1 ("tipc: extend link reset criteria for stale
> packet retransmission") we made link retransmission failure events
> dependent on the link tolerance, and not only of the number of failed
> retransmission attempts, as we did earlier. This works well. However,
> keeping the original, additional criteria of 99 failed retransmissions
> is now redundant, and may in some cases lead to failure detection
> times in the order of minutes instead of the expected 1.5 sec link
> tolerance value.
> 
> We now remove this criteria altogether.
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
