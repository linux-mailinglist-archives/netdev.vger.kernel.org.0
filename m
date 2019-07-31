Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D586A7D1BB
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 01:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfGaXN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 19:13:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 19:13:59 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CE8C12659B7F;
        Wed, 31 Jul 2019 16:13:58 -0700 (PDT)
Date:   Wed, 31 Jul 2019 19:13:57 -0400 (EDT)
Message-Id: <20190731.191357.886589630333387649.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: bridge: mcast: add delete due to
 fast-leave mdb flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730122041.14647-1-nikolay@cumulusnetworks.com>
References: <20190730122041.14647-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 16:13:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 30 Jul 2019 15:20:41 +0300

> In user-space there's no way to distinguish why an mdb entry was deleted
> and that is a problem for daemons which would like to keep the mdb in
> sync with remote ends (e.g. mlag) but would also like to converge faster.
> In almost all cases we'd like to age-out the remote entry for performance
> and convergence reasons except when fast-leave is enabled. In that case we
> want explicit immediate remote delete, thus add mdb flag which is set only
> when the entry is being deleted due to fast-leave.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied, thanks Nikolay.
