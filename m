Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA54D21E16
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 21:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfEQTQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 15:16:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfEQTQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 15:16:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 984B913F6183E;
        Fri, 17 May 2019 12:16:02 -0700 (PDT)
Date:   Fri, 17 May 2019 12:16:00 -0700 (PDT)
Message-Id: <20190517.121600.733033089370450073.davem@davemloft.net>
To:     hujunwei4@huawei.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, zhoukang7@huawei.com,
        mingfangsen@huawei.com, wangxiaogang3@huawei.com,
        mousuanming@huawei.com
Subject: Re: [PATCH v2] tipc: fix modprobe tipc failed after switch order
 of device registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4da8084e-372b-8301-e04f-b780ff4826b3@huawei.com>
References: <4da8084e-372b-8301-e04f-b780ff4826b3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 12:16:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You're working very quickly, and sloppily.

I reverted the v1 of this patch from my tree.

And I'm going to wait some time before applying this one, it needs review.
