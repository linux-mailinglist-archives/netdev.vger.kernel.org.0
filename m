Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A575DD9993
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394420AbfJPSvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731889AbfJPSvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 14:51:52 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D999089B000;
        Wed, 16 Oct 2019 18:51:51 +0000 (UTC)
Received: from localhost (ovpn-112-65.ams2.redhat.com [10.36.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6549212C53;
        Wed, 16 Oct 2019 18:51:45 +0000 (UTC)
Date:   Wed, 16 Oct 2019 20:51:38 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     walteste@inf.ethz.ch, bcodding@redhat.com, gsierohu@redhat.com,
        nforro@redhat.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv4: Return -ENETUNREACH if we can't create
 route but saddr is valid
Message-ID: <20191016205138.0c5a0058@redhat.com>
In-Reply-To: <20191016.142159.1388461310782297107.davem@davemloft.net>
References: <7bcfeaac2f78657db35ccf0e624745de41162129.1570722417.git.sbrivio@redhat.com>
        <20191016.142159.1388461310782297107.davem@davemloft.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 16 Oct 2019 18:51:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 14:21:59 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Stefano Brivio <sbrivio@redhat.com>
> Date: Thu, 10 Oct 2019 17:51:50 +0200
> 
> > I think this should be considered for -stable, < 5.2  
> 
> Changes meant for -stable should not target net-next, but rather net.

Oh, sorry for that. I thought this would be the best way for patches
that are not strictly (or proven) fixes for net, but still make sense
for stable.

I generalised David Ahern's hint from a different case, I thought you
agreed (<20190618.092512.1610110055396742434.davem@davemloft.net>).

Resending for net now.

-- 
Stefano
