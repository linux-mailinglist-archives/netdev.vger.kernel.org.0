Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261BB2000BA
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgFSD0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSD0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:26:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BD3C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:26:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A475120ED4AD;
        Thu, 18 Jun 2020 20:26:07 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:26:06 -0700 (PDT)
Message-Id: <20200618.202606.465950193993392898.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net 0/2] mptcp: cope with syncookie on MP_JOINs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1592388398.git.pabeni@redhat.com>
References: <cover.1592388398.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:26:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 17 Jun 2020 12:08:55 +0200

> Currently syncookies on MP_JOIN connections are not handled correctly: the
> connections fallback to TCP and are kept alive instead of resetting them at
> fallback time.
> 
> The first patch propagates the required information up to syn_recv_sock time,
> and the 2nd patch addresses the unifying the error path for all MP_JOIN
> requests.

Series applied, thanks.
