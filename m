Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C6F5ACD7
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfF2SWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfF2SWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 14:22:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C745307D90E;
        Sat, 29 Jun 2019 18:22:05 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BBEC5D9CA;
        Sat, 29 Jun 2019 18:22:03 +0000 (UTC)
Date:   Sat, 29 Jun 2019 20:21:59 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: Fix off-by-one in route dump counter without
 netlink strict checking
Message-ID: <20190629202159.46ad6723@redhat.com>
In-Reply-To: <74faa085e6af026f8b9f0d3cce8a94147781f257.1561830851.git.sbrivio@redhat.com>
References: <74faa085e6af026f8b9f0d3cce8a94147781f257.1561830851.git.sbrivio@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Sat, 29 Jun 2019 18:22:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 19:55:08 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> Always increment the per-node counter by one if we previously dumped
> a regular route, so that it matches the current skip counter.
> 
> Fixes: ee28906fd7a1 ("ipv4: Dump route exceptions if requested")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Sorry David, this was meant for net-next.

-- 
Stefano
