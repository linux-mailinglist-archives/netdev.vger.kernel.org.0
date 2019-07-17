Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5256C141
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfGQTBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 15:01:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQTBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 15:01:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E52A11264E7C3;
        Wed, 17 Jul 2019 12:01:31 -0700 (PDT)
Date:   Wed, 17 Jul 2019 12:01:31 -0700 (PDT)
Message-Id: <20190717.120131.1614957687610581259.davem@davemloft.net>
To:     hariprasad.kelam@gmail.com
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: fix warning "NULL check before some freeing
 functions is not needed"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190716022002.GA19592@hari-Inspiron-1545>
References: <20190716022002.GA19592@hari-Inspiron-1545>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 12:01:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Tue, 16 Jul 2019 07:50:02 +0530

> This patch removes NULL checks before calling kfree.
> 
> fixes below issues reported by coccicheck
> net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied.
