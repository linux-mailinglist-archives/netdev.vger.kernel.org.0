Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987CDAB31A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404143AbfIFHRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:17:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbfIFHRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:17:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2963718C8939;
        Fri,  6 Sep 2019 07:17:50 +0000 (UTC)
Received: from ovpn-204-113.brq.redhat.com (ovpn-204-113.brq.redhat.com [10.40.204.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A9761001284;
        Fri,  6 Sep 2019 07:17:48 +0000 (UTC)
Message-ID: <a921aab4b68c6028e0c92b168a525acde96f07c5.camel@redhat.com>
Subject: Re: [PATCH net] tcp: ulp: fix possible crash in
 tcp_diag_get_aux_size()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>
In-Reply-To: <20190905202041.138085-1-edumazet@google.com>
References: <20190905202041.138085-1-edumazet@google.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 06 Sep 2019 09:17:47 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Fri, 06 Sep 2019 07:17:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-05 at 13:20 -0700, Eric Dumazet wrote:
> tcp_diag_get_aux_size() can be called with sockets in any state.
> 
> icsk_ulp_ops is only present for full sockets.
> 
> For SYN_RECV or TIME_WAIT ones we would access garbage.
> 

hello Eric, 

thanks for fixing this!

Acked-by: Davide Caratti <dcaratti@redhat.com>


