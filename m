Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE7620B945
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgFZTVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZTVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 15:21:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5BAC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 12:21:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C8E1120F19CB;
        Fri, 26 Jun 2020 12:21:00 -0700 (PDT)
Date:   Fri, 26 Jun 2020 12:21:00 -0700 (PDT)
Message-Id: <20200626.122100.951777555352905335.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] ionic: update the queue count on open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626055837.3304-1-snelson@pensando.io>
References: <20200626055837.3304-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 12:21:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 25 Jun 2020 22:58:37 -0700

> Let the network stack know the real number of queues that
> we are using.
> 
> v2: added error checking
> 
> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied and queued up for -stable, thank you.
