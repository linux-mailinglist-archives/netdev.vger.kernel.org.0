Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8EA6615C
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfGKVnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:43:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47350 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbfGKVnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:43:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8F5B14DB02C7;
        Thu, 11 Jul 2019 14:43:48 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:43:48 -0700 (PDT)
Message-Id: <20190711.144348.399000958748865888.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        marek@cloudflare.com
Subject: Re: [PATCH net] ipv6: tcp: fix flowlabels reflection for RST
 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710134011.221210-1-edumazet@google.com>
References: <20190710134011.221210-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:43:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 Jul 2019 06:40:09 -0700

> In 323a53c41292 ("ipv6: tcp: enable flowlabel reflection in some RST packets")
> and 50a8accf1062 ("ipv6: tcp: send consistent flowlabel in TIME_WAIT state")
> we took care of IPv6 flowlabel reflections for two cases.
> 
> This patch takes care of the remaining case, when the RST packet
> is sent on behalf of a 'full' socket.
> 
> In Marek use case, this was a socket in TCP_CLOSE state.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Tested-by: Marek Majkowski <marek@cloudflare.com>

Applied.
