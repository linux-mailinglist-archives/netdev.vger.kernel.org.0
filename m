Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA4A2EB724
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbhAFAxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbhAFAxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:53:44 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771FAC061793
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 16:53:04 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id DA7A04CBCE1FB;
        Tue,  5 Jan 2021 16:53:03 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:53:03 -0800 (PST)
Message-Id: <20210105.165303.692592440460221271.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jerry.lilijun@huawei.com,
        xudingke@huawei.com
Subject: Re: [PATCH net v2] macvlan: remove redundant null check on data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1609828294-6284-1-git-send-email-wangyunjian@huawei.com>
References: <1609828294-6284-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:53:04 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Tue, 5 Jan 2021 14:31:34 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Because macvlan_common_newlink() and macvlan_changelink() already
> checked NULL data parameter, so the additional check is unnecessary,
> just remove it.
> 
> Fixes: 79cf79abce71 ("macvlan: add source mode")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
> v2:
>   * change code styles and commit log suggested by Jakub Kicinski
> ---

Applied to net-next, thanks.
