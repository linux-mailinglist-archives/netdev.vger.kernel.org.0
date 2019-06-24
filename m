Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1CA517E3
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbfFXQD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:03:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfFXQD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:03:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FA401504A473;
        Mon, 24 Jun 2019 09:03:25 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:03:25 -0700 (PDT)
Message-Id: <20190624.090325.163853495970223718.davem@davemloft.net>
To:     luoshijie1@huawei.com
Cc:     tgraf@suug.ch, dsahern@gmail.com, netdev@vger.kernel.org,
        liuzhiqiang26@huawei.com, wangxiaogang3@huawei.com,
        mingfangsen@huawei.com, zhoukang7@huawei.com
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 09:03:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luoshijie <luoshijie1@huawei.com>
Date: Tue, 18 Jun 2019 15:14:02 +0000

> From: Shijie Luo <luoshijie1@huawei.com>
> 
> When enable route_localnet, route of the 127/8 address is enabled.
> But in some situations like arp_announce=2, ARP requests or reply
> work abnormally.
> 
> This patchset fix some bugs when enable route_localnet. 
> 
> Change History:
> V2:
> - Change a single patch to a patchset.
> - Add bug fix for arp_ignore = 3.
> - Add a couple of test for enabling route_localnet in selftests.

Series applied to net-next, thanks.
