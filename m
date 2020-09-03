Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1504225CD50
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgICWRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgICWRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:17:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBA1C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:17:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AE53127B7FE9;
        Thu,  3 Sep 2020 15:00:58 -0700 (PDT)
Date:   Thu, 03 Sep 2020 15:17:44 -0700 (PDT)
Message-Id: <20200903.151744.559405902736572474.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, maheshb@google.com
Subject: Re: [PATCH net-next] ip: expose inet sockopts through inet_diag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901221008.611862-1-weiwan@google.com>
References: <20200901221008.611862-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 15:00:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Tue,  1 Sep 2020 15:10:08 -0700

> Expose all exisiting inet sockopt bits through inet_diag for debug purpose.
> Corresponding changes in iproute2 ss will be submitted to output all
> these values.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied, thank you.
