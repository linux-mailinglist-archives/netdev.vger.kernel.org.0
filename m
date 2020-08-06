Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5E23D4E7
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 02:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHFAvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 20:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHFAvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 20:51:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51A0C061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 17:51:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEE4B1568D2D1;
        Wed,  5 Aug 2020 17:34:18 -0700 (PDT)
Date:   Wed, 05 Aug 2020 17:51:03 -0700 (PDT)
Message-Id: <20200805.175103.2241972513134150734.davem@davemloft.net>
To:     dnelson@redhat.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com, rrichter@marvell.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next] net: thunderx: initialize VF's mailbox mutex
 before first usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805181848.237132-1-dnelson@redhat.com>
References: <20200805181848.237132-1-dnelson@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 17:34:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dean Nelson <dnelson@redhat.com>
Date: Wed,  5 Aug 2020 13:18:48 -0500

> A VF's mailbox mutex is not getting initialized by nicvf_probe() until after
> it is first used. And such usage is resulting in...
 ...
> This problem is resolved by moving the call to mutex_init() up earlier
> in nicvf_probe().
> 
> Fixes: 609ea65c65a0 ("net: thunderx: add mutex to protect mailbox from concurrent calls for same VF")
> Signed-off-by: Dean Nelson <dnelson@redhat.com>

Applied, thank you.
