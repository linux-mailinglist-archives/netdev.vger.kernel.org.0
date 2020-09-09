Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DC2635AF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgIISQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIISQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:16:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E12C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:16:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 646B412956472;
        Wed,  9 Sep 2020 10:59:17 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:16:03 -0700 (PDT)
Message-Id: <20200909.111603.1668998511693685528.davem@davemloft.net>
To:     yebin10@huawei.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] hsr: avoid newline at end of message in
 NL_SET_ERR_MSG_MOD
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909093821.54820-1-yebin10@huawei.com>
References: <20200909093821.54820-1-yebin10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 10:59:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>
Date: Wed, 9 Sep 2020 17:38:21 +0800

> clean follow coccicheck warning:
> net//hsr/hsr_netlink.c:94:8-42: WARNING avoid newline at end of message
> in NL_SET_ERR_MSG_MOD
> net//hsr/hsr_netlink.c:87:30-57: WARNING avoid newline at end of message
> in NL_SET_ERR_MSG_MOD
> net//hsr/hsr_netlink.c:79:29-53: WARNING avoid newline at end of message
> in NL_SET_ERR_MSG_MOD
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Applied, thank you.
