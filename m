Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C7372138
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391943AbfGWVC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:02:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbfGWVC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:02:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDF0A153BF10D;
        Tue, 23 Jul 2019 14:02:55 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:02:55 -0700 (PDT)
Message-Id: <20190723.140255.1785812525450069326.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list
 for TCP frames
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:02:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Tue, 23 Jul 2019 20:28:43 +0300

> Using Rx skb bulking for all frames may negatively impact the
> performance in some TCP termination scenarios, as it effectively
> bypasses GRO.

"may"?

Please provide numbers so that we know exactly whether it actually
hurts performance one way or another.

Thank you.
