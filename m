Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2823499F5A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391345AbfHVTEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:04:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731821AbfHVTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 15:04:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60320153410AC;
        Thu, 22 Aug 2019 12:04:48 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:04:47 -0700 (PDT)
Message-Id: <20190822.120447.538380205267677448.davem@davemloft.net>
To:     jan.dakinevich@virtuozzo.com
Cc:     linux-kernel@vger.kernel.org, den@virtuozzo.com,
        khorenko@virtuozzo.com, jan.dakinevich@gmail.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, johannes.berg@intel.com,
        dsahern@gmail.com, christian@brauner.io,
        stephen@networkplumber.org, Jason@zx2c4.com,
        jakub.kicinski@netronome.com, willemb@google.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        john.hurley@netronome.com, pabeni@redhat.com, brouer@redhat.com,
        bigeasy@linutronix.de, edumazet@google.com, lirongqing@baidu.com,
        ap420073@gmail.com, ptalbert@redhat.com,
        herbert@gondor.apana.org.au, tglx@linutronix.de, dima@arista.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH 0/3] rework netlink skb allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566470851-4694-1-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1566470851-4694-1-git-send-email-jan.dakinevich@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 12:04:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Date: Thu, 22 Aug 2019 10:48:08 +0000

> Currently, userspace is able to initiate costly high-order allocation in 
> kernel sending large broadcast netlink message, which is considered 
> undesirable. At the same time, unicast message are safe in this regard, 
> because they uses vmalloc-ed memory.
> 
> This series introduces changes, that allow broadcast messages to be 
> allocated with vmalloc() as well as unicast.

I'm tossing this series for the same reason I tossed the AF_UNIX change.
