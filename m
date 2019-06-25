Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E1255912
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfFYUkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:40:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:40:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D45B12D6B6C0;
        Tue, 25 Jun 2019 13:40:35 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:40:35 -0700 (PDT)
Message-Id: <20190625.134035.1744881006366671727.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, gordan.mihaljevic@dektech.com.au,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: eliminate unnecessary skb expansion
 during retransmission
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561478893-31371-1-git-send-email-jon.maloy@ericsson.com>
References: <1561478893-31371-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 13:40:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Tue, 25 Jun 2019 18:08:13 +0200

> We increase the allocated headroom for the buffer copies to be
> retransmitted. This eliminates the need for the lower stack levels
> (UDP/IP/L2) to expand the headroom in order to add their own headers.
> 
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
