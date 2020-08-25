Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F96625199E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgHYN3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgHYN3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:29:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAA5C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 06:29:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACDB111E45768;
        Tue, 25 Aug 2020 06:12:45 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:29:31 -0700 (PDT)
Message-Id: <20200825.062931.1607380647178219957.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     kuba@kernel.org, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        gabriel.ganne@6wind.com
Subject: Re: [PATCH net] gtp: add GTPA_LINK info to msg sent to userspace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825125940.21238-1-nicolas.dichtel@6wind.com>
References: <20200825125940.21238-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 06:12:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Tue, 25 Aug 2020 14:59:40 +0200

> During a dump, this attribute is essential, it enables the userspace to
> know on which interface the context is linked to.
> 
> Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>

Applied and queued up for -stable, thank you.
