Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9983566D8
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfFZKen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:34:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfFZKen (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 06:34:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7068481DFA;
        Wed, 26 Jun 2019 10:34:43 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF28B1001925;
        Wed, 26 Jun 2019 10:34:40 +0000 (UTC)
Date:   Wed, 26 Jun 2019 12:34:36 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] ipv6: fix suspicious RCU usage in rt6_dump_route()
Message-ID: <20190626123436.2dd2f11d@redhat.com>
In-Reply-To: <20190626100528.218097-1-edumazet@google.com>
References: <20190626100528.218097-1-edumazet@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 26 Jun 2019 10:34:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 03:05:28 -0700
Eric Dumazet <edumazet@google.com> wrote:

> syzbot reminded us that rt6_nh_dump_exceptions() needs to be called
> with rcu_read_lock()
> 
> net/ipv6/route.c:1593 suspicious rcu_dereference_check() usage!

Thanks for fixing this too.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano
