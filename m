Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F056E33
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfFZP74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:59:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFZP74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:59:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6AA114A8CAC5;
        Wed, 26 Jun 2019 08:59:55 -0700 (PDT)
Date:   Wed, 26 Jun 2019 08:59:53 -0700 (PDT)
Message-Id: <20190626.085953.330976047821740418.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/11] net: hns3: some code optimizations &
 bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <573582a3-23fc-8591-f71b-af977ed6fd0e@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
        <20190622.095323.1495992426494142587.davem@davemloft.net>
        <573582a3-23fc-8591-f71b-af977ed6fd0e@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 08:59:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tanhuazhong <tanhuazhong@huawei.com>
Date: Wed, 26 Jun 2019 15:44:05 +0800

> Hi, david, has this patchset merged into net-next, why I cannot see it
> after pulling net-next? Or is there some problem about this patchset I
> have missed?

Sorry, I forgot to push it out from my laptop while traveling.

It should be there now.
