Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2201E50E3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgE0WGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgE0WGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:06:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F0DC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 15:06:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 805F2128CEF6B;
        Wed, 27 May 2020 15:06:08 -0700 (PDT)
Date:   Wed, 27 May 2020 15:06:07 -0700 (PDT)
Message-Id: <20200527.150607.1082368777561562663.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, vaclav.zindulka@tlapnet.cz
Subject: Re: [Patch net-next 0/5] net_sched: reduce the number of qdisc
 resets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
References: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 15:06:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 26 May 2020 21:35:22 -0700

> This patchset aims to reduce the number of qdisc resets during
> qdisc tear down. Patch 1~3 are preparation for their following
> patches, especially patch 2 and patch 3 add a few tracepoints
> so that we can observe the whole lifetime of qdisc's. Patch 4
> and patch 5 are the ones do the actual work. Please find more
> details in each patch description.
> 
> Vaclav Zindulka tested this patchset and his large ruleset with
> over 13k qdiscs defined got from 22s to 520ms.

Series applied, thanks Cong.
