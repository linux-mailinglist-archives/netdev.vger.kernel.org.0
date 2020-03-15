Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3266185B03
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCOHTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:19:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgCOHTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:19:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69BF113E8116A;
        Sun, 15 Mar 2020 00:19:19 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:19:18 -0700 (PDT)
Message-Id: <20200315.001918.739481260505523590.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net-next v2 0/2] mptcp: simplify mptcp_accept()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584114674.git.pabeni@redhat.com>
References: <cover.1584114674.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:19:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 13 Mar 2020 16:52:40 +0100

> Currently we allocate the MPTCP master socket at accept time.
> 
> The above makes mptcp_accept() quite complex, and requires checks is several
> places for NULL MPTCP master socket.
> 
> These series simplify the MPTCP accept implementation, moving the master socket
> allocation at syn-ack time, so that we drop unneeded checks with the follow-up
> patch.
> 
> v1 -> v2:
> - rebased on top of 2398e3991bda7caa6b112a6f650fbab92f732b91

Series applied, thanks.
