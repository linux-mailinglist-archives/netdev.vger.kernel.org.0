Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000CA151A03
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgBDLkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 06:40:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgBDLkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:40:01 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEBD9133E904C;
        Tue,  4 Feb 2020 03:39:59 -0800 (PST)
Date:   Tue, 04 Feb 2020 12:39:58 +0100 (CET)
Message-Id: <20200204.123958.1136310259052678902.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, pablo@netfilter.org, laforge@gnumonks.org,
        netdev@vger.kernel.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [PATCH net] gtp: use __GFP_NOWARN to avoid memalloc warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204032459.15728-1-ap420073@gmail.com>
References: <20200204032459.15728-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 03:40:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue,  4 Feb 2020 03:24:59 +0000

> gtp hashtable size is received by user-space.
> So, this hashtable size could be too large. If so, kmalloc will internally
> print a warning message.
> This warning message is actually not necessary for the gtp module.
> So, this patch adds __GFP_NOWARN to avoid this message.
 ...
> Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thanks.
