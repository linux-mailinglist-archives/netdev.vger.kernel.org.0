Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898093BEF9
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388927AbfFJVzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388757AbfFJVzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:55:40 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B50B93082291;
        Mon, 10 Jun 2019 21:55:40 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE9419C59;
        Mon, 10 Jun 2019 21:55:36 +0000 (UTC)
Date:   Mon, 10 Jun 2019 23:55:32 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190610235532.5a4f9f0d@redhat.com>
In-Reply-To: <91d0b4a4-46ba-5dd0-e387-c9a0ba195506@gmail.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
        <f5ca22e91017e90842ee00aa4fd41dcdf7a6e99b.1560016091.git.sbrivio@redhat.com>
        <35689c52-0969-0103-663b-c9f909f4c727@gmail.com>
        <20190610234502.41949c97@redhat.com>
        <91d0b4a4-46ba-5dd0-e387-c9a0ba195506@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 10 Jun 2019 21:55:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 15:47:16 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/10/19 3:45 PM, Stefano Brivio wrote:
> > Indeed, we don't have to add much: just make this work for IPv4 too,
> > honour NLM_F_MATCH, and skip filtering (further optimisation) on
> > NLM_F_DUMP_FILTERED in iproute2 (ip neigh already uses that).  
> 
> you can't. Not all of iproute2's filter options are handled by the
> kernel (and nor should they be).

Right, of course. Discard that last part.

-- 
Stefano
