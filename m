Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9710CC2914
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbfI3Vqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:46:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfI3VqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:46:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00D55154361D7;
        Mon, 30 Sep 2019 11:08:48 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:08:48 -0700 (PDT)
Message-Id: <20190930.110848.1999516357100146209.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0b0ed452-c576-df5a-2420-2185e75e32e0@gmail.com>
References: <20190927012443.129446-1-edumazet@google.com>
        <20190927.205524.1304517574378068070.davem@davemloft.net>
        <0b0ed452-c576-df5a-2420-2185e75e32e0@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 11:08:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 27 Sep 2019 12:57:45 -0700

> 
> 
> On 9/27/19 11:55 AM, David Miller wrote:
>> From: Eric Dumazet <edumazet@google.com>
>> Date: Thu, 26 Sep 2019 18:24:43 -0700
>> 
>>> syzbot reported a crash in cbq_normalize_quanta() caused
>>> by an out of range cl->priority.
>>  ...
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>> 
>> Fixes: tag?  -stable?
>> 
> 
> I guess I feel always a bit sad to add :
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Please always add it.... so that we can cry together.

Applied and queued up for -stable, thanks.
