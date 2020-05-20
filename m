Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BDB1DBC5B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETSJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETSJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:09:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D729CC061A0E;
        Wed, 20 May 2020 11:09:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D686612988105;
        Wed, 20 May 2020 11:09:29 -0700 (PDT)
Date:   Wed, 20 May 2020 11:09:29 -0700 (PDT)
Message-Id: <20200520.110929.2181298468209354297.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next v1] hinic: add support to set and get pause
 param
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ef6201bb-238a-2131-c9ad-0825c2326b73@huawei.com>
References: <db07445f-245c-7b19-ef65-939f159fc53f@huawei.com>
        <20200519.195905.432048543421387943.davem@davemloft.net>
        <ef6201bb-238a-2131-c9ad-0825c2326b73@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 11:09:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "luobin (L)" <luobin9@huawei.com>
Date: Wed, 20 May 2020 12:39:27 +0800

> It's because I made this patch based on the previous patch
> ([PATCH net-next v1] hinic: add set_channels ethtool_ops support), so

Don't ever silently create dependencies like this.

Either submit new dependant patches after the required ones go in, or
put them together into a logical numbered patch series.
