Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055531DF2C0
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbgEVXLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbgEVXLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:11:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13446C061A0E;
        Fri, 22 May 2020 16:11:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75369120ED480;
        Fri, 22 May 2020 16:11:34 -0700 (PDT)
Date:   Fri, 22 May 2020 16:11:33 -0700 (PDT)
Message-Id: <20200522.161133.75296957266065703.davem@davemloft.net>
To:     hch@lst.de
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        David.Laight@ACULAB.COM, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: do a single memdup_user in sctp_setsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
References: <20200521174724.2635475-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:11:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 19:46:35 +0200

> based on the review of Davids patch to do something similar I dusted off
> the series I had started a few days ago to move the memdup_user or
> copy_from_user from the inidividual sockopts into sctp_setsockopt,
> which is done with one patch per option, so it might suit Marcelo's
> taste a bit better.  I did not start any work on getsockopt.

I think you and David still need to discuss how to move forward here,
there doesn't seem to be consensus yet.

Thanks.
