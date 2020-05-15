Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3491D4229
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEOAis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbgEOAis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:38:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E97C061A0C;
        Thu, 14 May 2020 17:38:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F059114CF4DC4;
        Thu, 14 May 2020 17:38:47 -0700 (PDT)
Date:   Thu, 14 May 2020 17:38:47 -0700 (PDT)
Message-Id: <20200514.173847.660724277766563.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: add set_ringparam ethtool_ops support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513223733.6854-1-luobin9@huawei.com>
References: <20200513223733.6854-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:38:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Wed, 13 May 2020 22:37:33 +0000

> support to change TX/RX queue depth with ethtool -G
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied.
