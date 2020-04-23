Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6DB1B5283
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgDWC2M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 22:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgDWC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:28:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A0CC03C1AA;
        Wed, 22 Apr 2020 19:28:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D4BC127AA060;
        Wed, 22 Apr 2020 19:28:11 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:28:10 -0700 (PDT)
Message-Id: <20200422.192810.397679580233184854.davem@davemloft.net>
To:     jere.leppanen@nokia.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com
Subject: Re: [PATCH net 0/2] sctp: Fix problems with peer restart when in
 SHUTDOWN-PENDING state and socket is closed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421190342.548226-1-jere.leppanen@nokia.com>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:28:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jere Leppänen <jere.leppanen@nokia.com>
Date: Tue, 21 Apr 2020 22:03:40 +0300

> These patches are related to the scenario described in commit
> bdf6fa52f01b ("sctp: handle association restarts when the socket is
> closed."). To recap, when our association is in SHUTDOWN-PENDING state
> and we've closed our one-to-one socket, while the peer crashes without
> being detected, restarts and reconnects using the same addresses and
> ports, we start association shutdown.
> 
> In this case, Cumulative TSN Ack in the SHUTDOWN that we send has
> always been incorrect. Additionally, bundling of the SHUTDOWN with the
> COOKIE-ACK was broken by a later commit. This series fixes both of
> these issues.

Series applied, thanks.
