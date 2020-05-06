Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87241C7C5C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgEFVYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:24:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDCC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 14:24:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9820B12660748;
        Wed,  6 May 2020 14:24:17 -0700 (PDT)
Date:   Wed, 06 May 2020 14:24:16 -0700 (PDT)
Message-Id: <20200506.142416.2294821219714044087.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, jerry.lilijun@huawei.com,
        xudingke@huawei.com
Subject: Re: [PATCH net-next] net: lantiq: Fix use correct return type for
 ndo_start_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588765126-7812-1-git-send-email-wangyunjian@huawei.com>
References: <1588765126-7812-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:24:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Wed, 6 May 2020 19:38:46 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
> the ndo function to use the correct type.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Applied.
