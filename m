Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953741DA4A0
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgESWev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:34:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B9EC061A0E;
        Tue, 19 May 2020 15:34:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8777F128EDAB4;
        Tue, 19 May 2020 15:34:50 -0700 (PDT)
Date:   Tue, 19 May 2020 15:34:49 -0700 (PDT)
Message-Id: <20200519.153449.1340018473891698454.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next v1] hinic: add support to set and get pause
 param
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518233848.29536-1-luobin9@huawei.com>
References: <20200518233848.29536-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:34:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Mon, 18 May 2020 23:38:48 +0000

> add support to set pause param with ethtool -A and get pause
> param with ethtool -a. Also remove set_link_ksettings ops for VF.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

This doesn't apply cleanly to net-next.
