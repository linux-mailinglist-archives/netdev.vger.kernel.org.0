Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B614F5C9
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFVMqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 08:46:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVMqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 08:46:25 -0400
Received: from localhost (unknown [8.46.76.25])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6944715394183;
        Sat, 22 Jun 2019 05:46:16 -0700 (PDT)
Date:   Sat, 22 Jun 2019 08:46:11 -0400 (EDT)
Message-Id: <20190622.084611.1808368522428755652.davem@davemloft.net>
To:     liuzhiqiang26@huawei.com
Cc:     luoshijie1@huawei.com, tgraf@suug.ch, dsahern@gmail.com,
        netdev@vger.kernel.org, wangxiaogang3@huawei.com,
        mingfangsen@huawei.com, zhoukang7@huawei.com
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e52787a0-86fe-bf5f-28f4-3a29dd8ced7b@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
        <e52787a0-86fe-bf5f-28f4-3a29dd8ced7b@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 05:46:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Date: Sat, 22 Jun 2019 16:41:49 +0800

> Friendly ping ...

I'm not applying this patch series without someone reviewing it.
