Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39361C05FC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD3TNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3TNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:13:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E41C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:13:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C4D51288C190;
        Thu, 30 Apr 2020 12:13:44 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:13:43 -0700 (PDT)
Message-Id: <20200430.121343.587592968548263339.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, jerry.lilijun@huawei.com,
        xudingke@huawei.com
Subject: Re: [PATCH net-next] net: caif: Fix use correct return type for
 ndo_start_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588241776-35896-1-git-send-email-wangyunjian@huawei.com>
References: <1588241776-35896-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:13:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Thu, 30 Apr 2020 18:16:16 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
> the ndo function to use the correct type.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Applied, thank you.
