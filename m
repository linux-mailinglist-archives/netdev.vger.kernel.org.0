Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE441CE544
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgEKUUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:20:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA2CC061A0C;
        Mon, 11 May 2020 13:20:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71FCE12848D30;
        Mon, 11 May 2020 13:20:42 -0700 (PDT)
Date:   Mon, 11 May 2020 13:20:41 -0700 (PDT)
Message-Id: <20200511.132041.1228631973458705284.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: add link_ksettings ethtool_ops support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511055857.4966-1-luobin9@huawei.com>
References: <20200511055857.4966-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:20:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Mon, 11 May 2020 05:58:57 +0000

> add set_link_ksettings implementation and improve the implementation
> of get_link_ksettings
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied, thank you.
