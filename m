Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0F72654F1
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgIJWSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:18:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB179C061573;
        Thu, 10 Sep 2020 15:18:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 042DD135EA712;
        Thu, 10 Sep 2020 15:01:47 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:18:34 -0700 (PDT)
Message-Id: <20200910.151834.517051910380804913.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com, kuba@kernel.org,
        snelson@pensando.io, colin.king@canonical.com, maz@kernel.org,
        luobin9@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Fix some kernel-doc warnings for hns
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910145620.27470-1-wanghai38@huawei.com>
References: <20200910145620.27470-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 15:01:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Thu, 10 Sep 2020 22:56:14 +0800

> Fix some kernel-doc warnings for hns.

Series applied to net-next, thanks.
