Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F321154A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfEBIY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36031 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfEBIY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:24:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B19F30675B0;
        Thu,  2 May 2019 08:24:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 528537EA5E;
        Thu,  2 May 2019 08:24:24 +0000 (UTC)
Message-ID: <24b9d33236fc8e7846386b70f104d6f40f083d51.camel@redhat.com>
Subject: Re: [PATCH net] udp: fix GRO packet of death
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Date:   Thu, 02 May 2019 10:24:23 +0200
In-Reply-To: <20190502015628.22215-1-edumazet@google.com>
References: <20190502015628.22215-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 02 May 2019 08:24:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-05-01 at 18:56 -0700, Eric Dumazet wrote:
> syzbot was able to crash host by sending UDP packets with a 0 payload.
> 
> TCP does not have this issue since we do not aggregate packets without
> payload.
> 
> Since dev_gro_receive() sets gso_size based on skb_gro_len(skb)
> it seems not worth trying to cope with padded packets.

Ooops... I messed-up badly! Thanks Eric for fixing this.

(too late, still)

Acked-by: Paolo Abeni <pabeni@redhat.com>

