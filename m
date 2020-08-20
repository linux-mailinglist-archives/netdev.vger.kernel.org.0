Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9569524C8B1
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgHTXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbgHTXik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:38:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FEDC061385;
        Thu, 20 Aug 2020 16:38:39 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 685C2128674C5;
        Thu, 20 Aug 2020 16:21:53 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:38:38 -0700 (PDT)
Message-Id: <20200820.163838.2031881871934638484.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
References: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
        <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:21:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 19 Aug 2020 14:40:52 +0000

> 
> The number of output and input streams was never being reduced, eg when
> processing received INIT or INIT_ACK chunks.
> The effect is that DATA chunks can be sent with invalid stream ids
> and then discarded by the remote system.
> 
> Fixes: 2075e50caf5ea ("sctp: convert to genradix")
> Signed-off-by: David Laight <david.laight@aculab.com>

Applied and queued up for -stable, thanks David.
