Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E511ED542
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 19:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgFCRr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 13:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgFCRr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 13:47:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07277C08C5C0;
        Wed,  3 Jun 2020 10:47:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC1D61281D6B2;
        Wed,  3 Jun 2020 10:47:25 -0700 (PDT)
Date:   Wed, 03 Jun 2020 10:47:25 -0700 (PDT)
Message-Id: <20200603.104725.187287052578354245.davem@davemloft.net>
To:     richard_siegfried@systemli.org
Cc:     gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: dccp: Add SIOCOUTQ IOCTL support (send buffer
 fill)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603111051.12224-1-richard_siegfried@systemli.org>
References: <20200603111051.12224-1-richard_siegfried@systemli.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jun 2020 10:47:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Sailer <richard_siegfried@systemli.org>
Date: Wed,  3 Jun 2020 13:10:51 +0200

> This adds support for the SIOCOUTQ IOCTL to get the send buffer fill
> of a DCCP socket, like UDP and TCP sockets already have.
> 
> Regarding the used data field: DCCP uses per packet sequence numbers,
> not per byte, so sequence numbers can't be used like in TCP. sk_wmem_queued
> is not used by DCCP and always 0, even in test on highly congested paths.
> Therefore this uses sk_wmem_alloc like in UDP.
> 
> Signed-off-by: Richard Sailer <richard_siegfried@systemli.org>
> ---
> v3: whitespace fixes

net-next is CLOSED
