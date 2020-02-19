Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70ABB164DE9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSSr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:47:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSSrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:47:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EBE815AD1977;
        Wed, 19 Feb 2020 10:47:55 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:47:54 -0800 (PST)
Message-Id: <20200219.104754.1226041715847841139.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        aviad.krawczyk@huawei.com, luoxianjun@huawei.com
Subject: Re: [PATCH net-next 1/2] hinic: Fix a irq affinity bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218194013.23837-1-luobin9@huawei.com>
References: <20200218194013.23837-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 10:47:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Tue, 18 Feb 2020 19:40:12 +0000

> do not use a local variable as an input parameter of irq_set_affinity_hint
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Bug fixes should target 'net' instead of 'net-next'.

Every patch series containing more than one patch should have an appropriate
header posting.
