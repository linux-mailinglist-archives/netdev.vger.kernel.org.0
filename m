Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A06B8F615
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfHOU6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:58:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfHOU6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 16:58:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A4AB1402BC49;
        Thu, 15 Aug 2019 13:58:52 -0700 (PDT)
Date:   Thu, 15 Aug 2019 13:58:51 -0700 (PDT)
Message-Id: <20190815.135851.1942927063321516679.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: divide the tx and rx bottom functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-301-Taiwan-albertk@realtek.com>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 13:58:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 14 Aug 2019 16:30:17 +0800

> Move the tx bottom function from NAPI to a new tasklet. Then, for
> multi-cores, the bottom functions of tx and rx may be run at same
> time with different cores. This is used to improve performance.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Theoretically, yes.

But do you have actual performance numbers showing this to be worth
the change?

Always provide performance numbers with changes that are supposed to
improve performance.
