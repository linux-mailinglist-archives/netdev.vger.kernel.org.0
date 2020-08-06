Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1675C23E1E3
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 21:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgHFTLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 15:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFTLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 15:11:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06870C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 12:11:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7149A11DB3163;
        Thu,  6 Aug 2020 11:54:55 -0700 (PDT)
Date:   Thu, 06 Aug 2020 12:11:40 -0700 (PDT)
Message-Id: <20200806.121140.1368097981877169091.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, richardcochran@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com
Subject: Re: [PATCH v5 net-next 0/3] Add PTP support for Octeontx2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596731731-31581-1-git-send-email-sundeep.lkml@gmail.com>
References: <1596731731-31581-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Aug 2020 11:54:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is closed, please resubmit these changes when the net-next
tree opens back up again.

Thank you.
