Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14834284C7C
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgJFNXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:23:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ADFC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:23:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A109127C858F;
        Tue,  6 Oct 2020 06:06:55 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:23:41 -0700 (PDT)
Message-Id: <20201006.062341.1523371510307053663.davem@davemloft.net>
To:     fabf@skynet.be
Cc:     kuba@kernel.org, netdev@vger.kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pshelar@ovn.org, dev@openvswitch.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru
Subject: Re: [PATCH 0/9 net-next] drivers/net: add sw_netstats_rx_add helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005203357.55076-1-fabf@skynet.be>
References: <20201005203357.55076-1-fabf@skynet.be>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 06:06:55 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon,  5 Oct 2020 22:33:57 +0200

> This small patchset creates netstats addition dev_sw_netstats_rx_add()
> based on dev_lstats_add() and replaces some open coding
> in both drivers/net and net branches.

Series applied, thank you.
