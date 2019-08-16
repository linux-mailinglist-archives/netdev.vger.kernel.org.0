Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B558C903D3
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfHPOSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbfHPOSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 10:18:17 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 308D43090FC8;
        Fri, 16 Aug 2019 14:18:17 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2A54A4FAE;
        Fri, 16 Aug 2019 14:18:15 +0000 (UTC)
Date:   Fri, 16 Aug 2019 16:18:14 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC ipsec-next 0/7] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20190816141814.GA12002@bistromath.localdomain>
References: <cover.1561457281.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1561457281.git.sd@queasysnail.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 16 Aug 2019 14:18:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steffen,

2019-06-25, 12:11:33 +0200, Sabrina Dubroca wrote:
> This patchset introduces support for TCP encapsulation of IKE and ESP
> messages, as defined by RFC 8229 [0]. It is an evolution of what
> Herbert Xu proposed in January 2018 [1] that addresses the main
> criticism against it, by not interfering with the TCP implementation
> at all. The networking stack now has infrastructure for this: TCP ULPs
> and Stream Parsers.

Have you had a chance to look at this?  I was going to rebase and
resend, but the patches still apply to ipsec-next and net-next (patch
2 is already in net-next as commit bd95e678e0f6).

Thanks,

-- 
Sabrina
