Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9AA20A91A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgFYXb4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 19:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgFYXbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:31:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5A8C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:31:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BD5E154FE830;
        Thu, 25 Jun 2020 16:31:55 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:31:54 -0700 (PDT)
Message-Id: <20200625.163154.920576324128273596.davem@davemloft.net>
To:     toke@redhat.com
Cc:     ldir@darbyshire-bryant.me.uk, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: Re: [PATCH RESEND net-next] sch_cake: add RFC 8622 LE PHB support
 to CAKE diffserv handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625201800.208689-1-toke@redhat.com>
References: <20200625201800.208689-1-toke@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:31:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 25 Jun 2020 22:18:00 +0200

> From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> 
> Change tin mapping on diffserv3, 4 & 8 for LE PHB support, in essence
> making LE a member of the Bulk tin.
> 
> Bulk has the least priority and minimum of 1/16th total bandwidth in the
> face of higher priority traffic.
> 
> NB: Diffserv 3 & 4 swap tin 0 & 1 priorities from the default order as
> found in diffserv8, in case anyone is wondering why it looks a bit odd.
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> [ reword commit message slightly ]
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
