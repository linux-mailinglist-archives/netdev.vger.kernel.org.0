Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF77369F1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfFFCTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:19:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfFFCTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 22:19:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD97E1457784D;
        Wed,  5 Jun 2019 19:19:03 -0700 (PDT)
Date:   Wed, 05 Jun 2019 19:19:03 -0700 (PDT)
Message-Id: <20190605.191903.756231080836216664.davem@davemloft.net>
To:     liuzhiqiang26@huawei.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        mingfangsen@huawei.com, zhoukang7@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH net] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3792c359-98b3-c312-d87a-204a846a3c11@huawei.com>
References: <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
        <20190605.184902.257610327160365131.davem@davemloft.net>
        <3792c359-98b3-c312-d87a-204a846a3c11@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 19:19:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Date: Thu, 6 Jun 2019 10:06:55 +0800

>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Date: Wed, 5 Jun 2019 18:49:49 +0800
>> 
>>> small cleanup: "struct request_sock_queue *queue" parameter of reqsk_queue_unlink
>>> func is never used in the func, so we can remove it.
>>>
>>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> 
>> Applied, thanks.
>> 
> 
> Hi, David Miller.
> So sorry for forgetting to sign partner's name who find the cleanup together.
> I have sent v2 patch with my partner's signature.
> 
> I am so sorry for the mistake.

It is already pushed out to my public GIT tree and the commit is immutable.
