Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53F51E68FF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391395AbgE1SDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391390AbgE1SDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:03:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130B4C08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 11:03:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B976E12959D58;
        Thu, 28 May 2020 11:02:59 -0700 (PDT)
Date:   Thu, 28 May 2020 11:02:59 -0700 (PDT)
Message-Id: <20200528.110259.1344103793250434137.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ncardwell@google.com, ycheng@google.com
Subject: Re: [PATCH net-next] tcp: ipv6: support RFC 6069 (TCP-LD)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528003458.90435-1-edumazet@google.com>
References: <20200528003458.90435-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 11:02:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 27 May 2020 17:34:58 -0700

> Make tcp_ld_RTO_revert() helper available to IPv6, and
> implement RFC 6069 :
> 
> Quoting this RFC :
> 
> 3. Connectivity Disruption Indication
> 
>    For Internet Protocol version 6 (IPv6) [RFC2460], the counterpart of
>    the ICMP destination unreachable message of code 0 (net unreachable)
>    and of code 1 (host unreachable) is the ICMPv6 destination
>    unreachable message of code 0 (no route to destination) [RFC4443].
>    As with IPv4, a router should generate an ICMPv6 destination
>    unreachable message of code 0 in response to a packet that cannot be
>    delivered to its destination address because it lacks a matching
>    entry in its routing table.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
