Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460E519CDE8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 02:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391003AbgDCArj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 20:47:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390997AbgDCArj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 20:47:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9730A12740187;
        Thu,  2 Apr 2020 17:47:38 -0700 (PDT)
Date:   Thu, 02 Apr 2020 17:47:35 -0700 (PDT)
Message-Id: <20200402.174735.1088204254915987225.davem@davemloft.net>
To:     vincent@bernat.ch
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        kafai@fb.com, dsahern@gmail.com
Subject: Re: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for
 non-root users
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331132009.1306283-1-vincent@bernat.ch>
References: <20200331132009.1306283-1-vincent@bernat.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 17:47:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>
Date: Tue, 31 Mar 2020 15:20:10 +0200

> Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
> non-root user to bind a socket to an interface if it is not already
> bound.
 ...

Ok I'm convinced now, thanks for your patience.

Applied, thanks.

