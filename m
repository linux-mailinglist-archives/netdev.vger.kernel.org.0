Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33D354FE
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 03:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfFEBbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 21:31:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFEBbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 21:31:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D907114FB1D9F;
        Tue,  4 Jun 2019 18:31:18 -0700 (PDT)
Date:   Tue, 04 Jun 2019 18:31:16 -0700 (PDT)
Message-Id: <20190604.183116.1573562404756340727.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: tcp: enable flowlabel reflection in some RST
 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5ce53efb-1a9c-86a8-2b78-e79d670db9bd@gmail.com>
References: <20190604192942.118949-1-edumazet@google.com>
        <5ce53efb-1a9c-86a8-2b78-e79d670db9bd@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 18:31:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 4 Jun 2019 18:16:00 -0700

> On 6/4/19 12:29 PM, Eric Dumazet wrote:
>> This extends commit 22b6722bfa59 ("ipv6: Add sysctl for per
>> namespace flow label reflection"), for some TCP RST packets.
>> 
>> When RST packets are sent because no socket could be found,
>> it makes sense to use flowlabel_reflect sysctl to decide
>> if a reflection of the flowlabel is requested.
>> 
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> Please wait for a V2, I will use another bit from the sysctl to limit the
> risk of regressions.

Ok.
