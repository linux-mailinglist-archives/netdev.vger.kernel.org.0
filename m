Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF555943
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfFYUno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:43:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:43:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AB7C12D6C857;
        Tue, 25 Jun 2019 13:43:44 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:43:43 -0700 (PDT)
Message-Id: <20190625.134343.2260074699747151110.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, gordan.mihaljevic@dektech.com.au,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: rename function msg_get_wrapped() to
 msg_inner_hdr()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561484220-22814-1-git-send-email-jon.maloy@ericsson.com>
References: <1561484220-22814-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 13:43:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Tue, 25 Jun 2019 19:37:00 +0200

> We rename the inline function msg_get_wrapped() to the more
> comprehensible msg_inner_hdr().
> 
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied, thanks Jon.
