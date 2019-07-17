Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C336C321
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfGQWYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:24:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfGQWYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:24:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3B1C14EC5846;
        Wed, 17 Jul 2019 15:24:49 -0700 (PDT)
Date:   Wed, 17 Jul 2019 15:24:49 -0700 (PDT)
Message-Id: <20190717.152449.1720887196144102382.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, gordan.mihaljevic@dektech.com.au,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net 1/1] tipc: initialize 'validated' field of received
 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563399824-4462-1-git-send-email-jon.maloy@ericsson.com>
References: <1563399824-4462-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 15:24:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Wed, 17 Jul 2019 23:43:44 +0200

> The tipc_msg_validate() function leaves a boolean flag 'validated' in
> the validated buffer's control block, to avoid performing this action
> more than once. However, at reception of new packets, the position of
> this field may already have been set by lower layer protocols, so
> that the packet is erroneously perceived as already validated by TIPC.
> 
> We fix this by initializing the said field to 'false' before performing
> the initial validation.
> 
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
